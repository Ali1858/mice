from typing import Dict, Any

from allennlp.training.trainer import EpochCallback, GradientDescentTrainer


@EpochCallback.register("epoch_callback")
class TrackEpochCallback:
    """
    A callback that you can pass to the `GradientDescentTrainer` to access the current epoch number
    in your model during training. This callback sets `model.epoch`, which can be read inside of
    `model.forward()`. Since the EpochCallback passes `epoch=-1`
    at the start of the training, we set `model.epoch = epoch + 1` which now denotes the number of
    completed epochs at a given training state.
    """

    def __init__(self):
        super().__init__()

    def __call__(
        self,
        trainer: "GradientDescentTrainer",
        metrics: Dict[str, Any],
        epoch: int,
        is_master: bool,
    ) -> None:
        print(trainer.model.epoch)
        print(trainer.model.beta)
        e = epoch + 1
        trainer.model.epoch = e
        if trainer.model.training and e > 1 and e % 1 == 0:
           if trainer.model.beta > 0.01:
               trainer.model.beta -= 0.099
        
        print(trainer.model.epoch)
        print(trainer.model.beta)