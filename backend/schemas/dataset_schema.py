from dataclasses import dataclass
from backend.enums.dataset_enum import DatasetEnum
from pydantic import BaseModel
from typing import List

@dataclass
class DatasetSchema:
    dataset_type : DatasetEnum

class Result(BaseModel):
    id : str
    text : str
    
class TaskSchema(BaseModel):
    str : List[Result] 