import imp
from fastapi import FastAPI,Depends
from fastapi.responses import RedirectResponse
from backend.schemas.dataset_schema import DatasetSchema, TaskSchema
from backend.schemas.prediction_schema import PredictionSchema
from backend.api import archivedresult, predict
from typing import List
import json
import os 

router = FastAPI(docs_url="/api/docs")

@router.get("/")
async def docs_redirect():
    return RedirectResponse(url='api/docs')


@router.get("/Datasets")
def get_datasets():
    input_path =  os.path.join("backend","data","input.json")
    with open(input_path) as json_file:
        result = json.load(json_file)
    return result


@router.get("/Prediction",response_model=List[PredictionSchema])
def get_prediction(
     task : DatasetSchema = Depends(DatasetSchema),
     input_sentence : str = None,   
):

    is_available = archivedresult(task.dataset_type,input_sentence)

    if is_available:
        return is_available

    else :
        masked_index,result = predict(task.dataset_type,input_sentence)
        return [{
            "input":input_sentence,
            "masked_index":masked_index,
            "prediction": result
            }]

