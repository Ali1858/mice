from typing import Dict, Optional


import torch
import torch.nn as nn
import torch.nn.functional as F

from allennlp.data import TextFieldTensors, Vocabulary
from allennlp.data.fields import MetadataField
from allennlp.models.model import Model
from allennlp.modules import FeedForward, Seq2SeqEncoder, Seq2VecEncoder, TextFieldEmbedder
from allennlp.nn import InitializerApplicator, util
from allennlp.nn.util import get_text_field_mask
from allennlp.training.metrics import CategoricalAccuracy


class VMASK(nn.Module):
    def __init__(self):
        super(VMASK, self).__init__()

        self.device = "cuda" #args.device
        self.mask_hidden_dim = 100 #args.mask_hidden_dim
        self.activations = {'tanh': torch.tanh, 'sigmoid': torch.sigmoid, 'relu': torch.relu,
                            'leaky_relu': F.leaky_relu}
        self.activation = self.activations["tanh"]#args.activation]
        self.embed_dim = 1024#args.embed_dim
        self.linear_layer = nn.Linear(self.embed_dim, self.mask_hidden_dim)
        # self.linear_layer2 = nn.Linear(self.mask_hidden_dim, 64)
        self.hidden2p = nn.Linear(self.mask_hidden_dim, 2)
        self.dropout = nn.Dropout(0.3)

    def forward_sent_batch(self, embeds):
        temps = self.dropout(self.activation(self.linear_layer(embeds)))
        # temps = self.linear_layer(embeds)
        # temps2 = self.linear_layer2(temps)
        p = self.hidden2p(temps)  # bsz, seqlen, dim
        return p

    def forward(self, x, p, training):
        if training:
            r = F.gumbel_softmax(p, tau=1,hard=True, dim=2)[:, :, 1:2]
            x_prime = r * x
            return x_prime
        else:
            probs = F.softmax(p, dim=2)[:, :, 1:2]  # select the probs of being 1
            x_prime = probs * x
            return x_prime

    def get_statistics_batch(self, embeds):
        p = self.forward_sent_batch(embeds)
        return p


@Model.register("vmasker2_classifier")
class BasicClassifier(Model):
    """
    This `Model` implements a basic text classifier. After embedding the text into
    a text field, we will optionally encode the embeddings with a `Seq2SeqEncoder`. The
    resulting sequence is pooled using a `Seq2VecEncoder` and then passed to
    a linear classification layer, which projects into the label space. If a
    `Seq2SeqEncoder` is not provided, we will pass the embedded text directly to the
    `Seq2VecEncoder`.
    Registered as a `Model` with name "basic_classifier".
    # Parameters
    vocab : `Vocabulary`
    text_field_embedder : `TextFieldEmbedder`
        Used to embed the input text into a `TextField`
    seq2seq_encoder : `Seq2SeqEncoder`, optional (default=`None`)
        Optional Seq2Seq encoder layer for the input text.
    seq2vec_encoder : `Seq2VecEncoder`
        Required Seq2Vec encoder layer. If `seq2seq_encoder` is provided, this encoder
        will pool its output. Otherwise, this encoder will operate directly on the output
        of the `text_field_embedder`.
    feedforward : `FeedForward`, optional, (default = `None`)
        An optional feedforward layer to apply after the seq2vec_encoder.
    dropout : `float`, optional (default = `None`)
        Dropout percentage to use.
    num_labels : `int`, optional (default = `None`)
        Number of labels to project to in classification layer. By default, the classification layer will
        project to the size of the vocabulary namespace corresponding to labels.
    namespace : `str`, optional (default = `"tokens"`)
        Vocabulary namespace corresponding to the input text. By default, we use the "tokens" namespace.
    label_namespace : `str`, optional (default = `"labels"`)
        Vocabulary namespace corresponding to labels. By default, we use the "labels" namespace.
    initializer : `InitializerApplicator`, optional (default=`InitializerApplicator()`)
        If provided, will be used to initialize the model parameters.
    """

    def __init__(
        self,
        vocab: Vocabulary,
        text_field_embedder: TextFieldEmbedder,
        seq2vec_encoder: Seq2VecEncoder,
        seq2seq_encoder: Seq2SeqEncoder = None,
        feedforward: Optional[FeedForward] = None,
        dropout: float = None,
        num_labels: int = None,
        label_namespace: str = "labels",
        namespace: str = "tokens",
        initializer: InitializerApplicator = InitializerApplicator(),
        **kwargs,
    ) -> None:

        super().__init__(vocab, **kwargs)
        self.device = "cuda" 
        self._text_field_embedder = text_field_embedder
        self._seq2seq_encoder = seq2seq_encoder
        self._seq2vec_encoder = seq2vec_encoder
        self._feedforward = feedforward
        self.maskmodel = VMASK()

        # parameters = filter(lambda p: p.requires_grad, self._text_field_embedder.parameters())
        # for param in parameters:
        #     param.requires_grad = False

        if feedforward is not None:
            self._classifier_input_dim = feedforward.get_output_dim()
        else:
            self._classifier_input_dim = self._seq2vec_encoder.get_output_dim()

        if dropout:
            self._dropout = torch.nn.Dropout(dropout)
        else:
            self._dropout = None
        self._label_namespace = label_namespace
        self._namespace = namespace

        if num_labels:
            self._num_labels = num_labels
        else:
            self._num_labels = vocab.get_vocab_size(namespace=self._label_namespace)
        self._classification_layer = torch.nn.Linear(self._classifier_input_dim, self._num_labels)
        self._accuracy = CategoricalAccuracy()
        self._loss = torch.nn.CrossEntropyLoss()
        # self._info_loss = torch.nn.KLDivLoss()
        self.beta = 1
        initializer(self)
        self.incoming_epoch = -1

    def l1_penalty(params, l1_lambda=0.001):
        """Returns the L1 penalty of the params."""
        l1_norm = sum(p.abs().sum() for p in params)
        return l1_lambda*l1_norm


    def forward(  # type: ignore
        self,
        tokens: TextFieldTensors,
        label: torch.IntTensor = None,
        metadata: MetadataField = None
    ) -> Dict[str, torch.Tensor]:

        """
        # Parameters
        tokens : `TextFieldTensors`
            From a `TextField`
        label : `torch.IntTensor`, optional (default = `None`)
            From a `LabelField`
        # Returns
        An output dictionary consisting of:
            - `logits` (`torch.FloatTensor`) :
                A tensor of shape `(batch_size, num_labels)` representing
                unnormalized log probabilities of the label.
            - `probs` (`torch.FloatTensor`) :
                A tensor of shape `(batch_size, num_labels)` representing
                probabilities of the label.
            - `loss` : (`torch.FloatTensor`, optional) :
                A scalar loss to be optimised.
        """
        embedded_text = self._text_field_embedder(tokens)
        mask = get_text_field_mask(tokens)


        p = self.maskmodel.get_statistics_batch(embedded_text)
        embedded_text = self.maskmodel(embedded_text, p, self.training)

        vmask_probs = F.softmax(p, dim=2)

        p = torch.ones(vmask_probs.shape[-1],device=self.device)/ vmask_probs.shape[-1]
        p = p.view(1, vmask_probs.shape[-1])
        p_prior = p.expand(vmask_probs.shape)



        probs_pos = vmask_probs[:,:,1]
        p_prior_pos = p_prior[:,:,1]
        probs_neg = vmask_probs[:,:,0]
        p_prior_neg = p_prior[:,:,0]

        # self.infor_loss = torch.mean(probs_pos * torch.log(p_prior_pos+1e-8) + probs_neg*torch.log(p_prior_neg+1e-8))

        self.infor_loss = torch.mean(probs_pos * torch.log(probs_pos+1e-8) + probs_neg*torch.log(probs_neg+1e-8))
        # self.infor_loss = self.infor_loss + self.l1_penalty(self.maskmodel.linear_layer.parameters())
        # self.infor_loss = self._info_loss(p,p_prior)

        vmask = torch.argmax(vmask_probs, dim=2)
        print(self.infor_loss)

        if self._seq2seq_encoder:
            embedded_text = self._seq2seq_encoder(embedded_text, mask=mask)

        embedded_text = self._seq2vec_encoder(embedded_text, mask=mask)

        if self._dropout:
            embedded_text = self._dropout(embedded_text)

        if self._feedforward is not None:
            embedded_text = self._feedforward(embedded_text)

        logits = self._classification_layer(embedded_text)
        probs = torch.nn.functional.softmax(logits, dim=-1)

        output_dict = {"logits": logits, "probs": probs,"vmask_probs":vmask_probs,"vmask":vmask}
        output_dict["token_ids"] = util.get_token_ids_from_text_field_tensors(tokens)
        if label is not None:
            loss = self._loss(logits, label.long().view(-1))
            if self.training:
                print(self.beta,self.epoch,loss,self.infor_loss)
                loss = loss + (self.beta*self.infor_loss)
            output_dict["loss"] = loss
            self._accuracy(logits, label)

        if self.training and self.incoming_epoch != self.epoch and self.epoch >= 1 and self.epoch % 1 == 0:
            self.incoming_epoch = self.epoch
            if self.beta > 0.03:
                self.beta -= 0.09
        return output_dict

    def make_output_human_readable(
        self, output_dict: Dict[str, torch.Tensor]
    ) -> Dict[str, torch.Tensor]:
        """
        Does a simple argmax over the probabilities, converts index to string label, and
        add `"label"` key to the dictionary with the result.
        """
        predictions = output_dict["probs"]
        if predictions.dim() == 2:
            predictions_list = [predictions[i] for i in range(predictions.shape[0])]
        else:
            predictions_list = [predictions]
        classes = []
        for prediction in predictions_list:
            label_idx = prediction.argmax(dim=-1).item()
            label_str = self.vocab.get_index_to_token_vocabulary(self._label_namespace).get(
                label_idx, str(label_idx)
            )
            classes.append(label_str)
        output_dict["label"] = classes
        tokens = []
        for instance_tokens in output_dict["token_ids"]:
            tokens.append(
                [
                    self.vocab.get_token_from_index(token_id.item(), namespace=self._namespace)
                    for token_id in instance_tokens
                ]
            )
        output_dict["tokens"] = tokens
        return output_dict

    def get_metrics(self, reset: bool = False) -> Dict[str, float]:
        metrics = {"accuracy": self._accuracy.get_metric(reset)}
        return metrics

    default_predictor = "text_classifier"