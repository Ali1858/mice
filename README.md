## Application
- Backend application for Move

## Getting Started
- Go to terminal and take git pull by giving project directory and backend branch
`git clone -b backend <project-directory>`

## Setup virtual environment
- To manage and activate virtual environment to your project
`pip3 install virtualenv`
`virtualenv venv --python=python3.7`    
`source venv/bin/activate`   

- restart VScode and open any python file to activate the environment
## Setup requirements
- To download the project requirements using
`pip install -r requirements.txt`

## Download Pretrained Models
- To download Pretrained Models, make sure that you have wget package installed
`bash download_models.sh`

## Run Fast API swagger 
- To run the API endpoints using uvicorn, 
`uvicorn backend.endpoints:router --host=0.0.0.0 --reload`

## Test API endpoints
- To run the dataset API 
`curl -X 'GET' 'http://127.0.0.1:8000/Datasets' -H 'accept: application/json'`

- To run the Prediction API 
`curl -X 'GET' 'http://127.0.0.1:8000/Prediction?input_sentence=< your input>&dataset_type=<dataset>' -H 'accept: application/json'`


# Containerize a Backend FastAPI with Docker
- To run this project, you'll need to have [Docker](https://docs.docker.com/get-docker/) installed.

## Getting started
- Build the container, providing a tag:  

`docker build -t moveapi_backend . `

- Then you can run the container, passing in a name for the container, and the previously used tag:  

`docker run -d --name api -p 8000:8000 moveapi_backend`

- Note that if you used the code as-is with the `--reload` option that you won't be able to kill the container using `CTRL + C`.  

- Instead in another terminal window you can kill the container using Docker's kill command:  
`docker kill api`