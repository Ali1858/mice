from fastapi import FastAPI,Depends
from fastapi.responses import RedirectResponse
from backend.schemas.dataset_schema import DatasetSchema, TaskSchema
from backend.schemas.prediction_schema import PredictionSchema
from backend.api import predict


router = FastAPI(docs_url="/api/docs")

@router.get("/")
async def docs_redirect():
    return RedirectResponse(url='api/docs')


@router.get("/Datasets",response_model=TaskSchema)
def get_datasets():
    return { "result": { "imdb","newsgroups","tweepfake" } }


@router.get("/Prediction",response_model= PredictionSchema)
def get_prediction(
     task : DatasetSchema = Depends(DatasetSchema),
     input_sentence : str = None,   
):
    
    masked_index,result = predict(task.dataset_type,input_sentence)
    return {
            "input":input_sentence,
            "masked_index":masked_index,
            "prediction": result
            }

      