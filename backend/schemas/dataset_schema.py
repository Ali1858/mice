from dataclasses import dataclass
from backend.enums.dataset_enum import DatasetEnum
from pydantic import BaseModel
from typing import List

@dataclass
class DatasetSchema:
    dataset_type : DatasetEnum


class TaskSchema(BaseModel):
    result : List[str] 