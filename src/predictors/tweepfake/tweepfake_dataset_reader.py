import pandas as pd
from typing import Dict, List, Optional
import logging
from allennlp.data import Tokenizer
from overrides import overrides
from nltk.tree import Tree
from allennlp.common.file_utils import cached_path
from allennlp.data.dataset_readers.dataset_reader import DatasetReader
from allennlp.data.fields import LabelField, TextField, Field
from allennlp.data.instance import Instance
from allennlp.data.token_indexers import TokenIndexer, SingleIdTokenIndexer
from allennlp.data.tokenizers import Token
from allennlp.data.tokenizers.spacy_tokenizer import SpacyTokenizer
from allennlp.common.checks import ConfigurationError
from pathlib import Path
from itertools import chain
import os.path as osp
import tarfile
import numpy as np
import math

from src.predictors.predictor_utils import clean_text 
logger = logging.getLogger(__name__)

def get_label(label):
    assert "human" in label or "bot" in label
    return "1" if "human" in label else "0"


@DatasetReader.register("tweepfake")
class TweepfakeDatasetReader(DatasetReader):

    def __init__(self,
                 token_indexers: Dict[str, TokenIndexer] = None,
                 tokenizer: Optional[Tokenizer] = None,
                 **kwargs) -> None:
        super().__init__(**kwargs)

        self._tokenizer = tokenizer or SpacyTokenizer()
        self._token_indexers = token_indexers or \
                {"tokens": SingleIdTokenIndexer()}

        self.random_seed = 0 # numpy random seed
    
    
    def get_inputs(self,file_path,return_labels = False):

        if file_path == 'test':
            file_path = "src/predictors/tweepfake/test.csv"
        elif file_path == 'train':
            file_path = "src/predictors/tweepfake/train.csv"

        df = pd.read_csv(file_path)
        df = df[:10]
        np.random.seed(self.random_seed)
        strings = [None] * len(df)
        labels = [None] * len(df)
      
        for index,row in df[:10].iterrows():
          labels[index] = get_label(str(row['account.type']))
          strings[index] = clean_text(row['text'], special_chars=["<br />", "\t"])

        if return_labels:
            return strings, labels
        return strings  

    
    def text_to_instance(
            self, string: str, label:str = None) -> Optional[Instance]:
        tokens = self._tokenizer.tokenize(string)
        text_field = TextField(tokens, token_indexers=self._token_indexers)
        fields: Dict[str, Field] = {"tokens": text_field}
        if label is not None:
            fields["label"] = LabelField(label)
        return Instance(fields)