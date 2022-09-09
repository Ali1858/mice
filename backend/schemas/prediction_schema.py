from dataclasses import dataclass
from pydantic import BaseModel
from typing import List


class Result(BaseModel):
    idx : int
    edited_input : str
    edited_label : str
    orig_label : str
    orig_contrast_prob_pred : float
    new_contrast_prob_pred : float
    minimality : float
    num_edit_rounds : int
    mask_frac : float
    duration : float
    error : bool


class PredictionSchema(BaseModel):
    input : str 
    masked_index : List[int]
    prediction : List[Result]

  
