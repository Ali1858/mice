# The Research project for Machine Learning Application 2022: Team move37
## Minimal Contrastive Editing (MiCE) 🐭

Our research is based on MICE model. This repository contains code for the paper , [Explaining NLP Models via Minimal Contrastive Editing (MiCE)](https://arxiv.org/pdf/2012.13985.pdf) and SOCMasker [] integrated together.

```
## Installation

1.  Clone the repository.
    ```bash
    git clone https://github.com/Ali1858/mice.git
    cd mice
    ```

2.  [Download and install Conda](https://conda.io/projects/conda/en/latest/user-guide/install/index.html).

3.  Create a Conda environment.

    ```bash
    conda create -n mice python=3.7
    ```
 
4.  Activate the environment.

    ```bash
    conda activate mice
    ```
    
5.  Download the requirements.

    ```bash
    pip3 install -r requirements.txt
    ```
```

## Quick Start
Note: Our research project doesn't support RACE dataset. We only support IMDB, FakeTweep, Newsgroups Dataset.

1. **Download Task Data**: Download the FakeTweep dataset here:[Link](https://www.kaggle.com/datasets/mtesconi/twitter-deep-fake-text). 
All other task-specific datasets are automatically downloaded by the commands below.
2. **Download Pretrained Models**: You can download pretrained models by running:

    ```bash
    bash download_models.sh
    ```

      For each task (IMDB/Newsgroups/Faketweep), this script saves the:
      
      - Predictor model to: `trained_predictors/{TASK}/model/model.tar.gz`.
      - Editor checkpoint to: `results/{TASK}/editors/mice/{TASK}_editor.pth`.

4. **Generate Edits**: Run the following command to generate edits for a particular task with our pretrained editor. It will write edits to `results/{TASK}/edits/{STAGE2EXP}/edits.csv`.

        python run_stage_two.py -task {TASK} -stage2_exp {STAGE2EXP} -editor_path results/{TASK}/editors/mice/{TASK}_editor.pth -mask_type socmask
        
      
      For instance, to generate edits for the IMDB task, the following command will save edits to `results/imdb/edits/mice_binary/edits.csv`:
      
      ```bash
      python run_stage_two.py -task imdb -stage2_exp mice_binary -editor_path results/imdb/editors/mice/imdb_editor.pth -mask_type socmask
      ```
      
      
4. **Inspect Edits**: Inspect these edits with the demo notebook `notebooks/analyzesoc.ipynb`.

### Training Editors
The following command will train an editor (i.e. run Stage 1 of MiCE) for a particular task. It saves checkpoints to `results/{TASK}/editors/{STAGE1EXP}/checkpoints/`.

    python run_stage_one.py -task {TASK} -stage1_exp {STAGE1EXP} -mask_type socmask


### Generating Edits
The following command will find MiCE edits (i.e. run Stage 2 of MiCE) for a particular task. It saves edits to `results/{TASK}/edits/{STAGE2EXP}/edits.csv`. `-editor_path` determines the Editor model to use. Defaults to our pretrained Editor.

    python run_stage_two.py -task {TASK} -stage2_exp {STAGE2EXP} -editor_path results/{TASK}/editors/mice/{TASK}_editor.pth -mask_type socmask


## Contribution:
Our Main contribution to this project is SOC based masked. We introduce the SOC-inspired technique where we compare logits based on the predicted class Instead of a predetermined class logit for the whole dataset. We also address the issue of sub-words by merging them together before getting the word importance and then assigning the same word importance to all sub-words. Along with that we also filter out the punctuation tokens and deprioritize them by assigning importance to -99.

Algorithm Details: 
1. Merging all the sub-words together and mapping the word importance of a single word to its sub-words. Additionally, filtering out the punctuations. 
2. Masking of each token of the sentence iteratively and getting beatch predictions using the Roberta model for all the masked input text.
3. Comparing the difference of predicted class’s logits from masked input sentence with an original unmasked sentence.
4. Ranking of the work importance for each word token in the sentence.
    -Using descending order of the ranks assigned to each word token

Please look at SOCMasker class in masker.py file for more details.

## Metrics comparision of SOC-based and Gradient-based technique

<img src="https://user-images.githubusercontent.com/13449847/193086121-220c901c-353a-40d4-932f-02ae7f2a27bb.jpeg" width="450" height="450" />
<img src="https://user-images.githubusercontent.com/13449847/193086128-1bda80f3-7869-48f2-a3f4-3ac3622913b7.jpeg" width="450" height="450" />

## Setup Details:


### FrontEnd:
    Hosting: Firebase (Free user bandwidth)
    Tech Stack: Flutter (Framework), Dart (Programming Language)
    Implementation: 
    UI majorly consists of toggle buttons for easy switching of datasets. Graphs are being used in order to visualize the evaluation metrics. The UI also consists of integration with the backend in order to perform API REST operations. The responses are displayed accordingly. Each component of the UI is responsive. 

    Please find more detail inside frontend folder.


### BackEnd: 
	Hosting: GCP Cloud (Compute Instance - promotional credits)
    GCP Instance spec: RAM 16 GB
    Persistent storage: 80 GB
    Machine type: e2-standard-4 CPU 
    Platform: Intel Broadwell, Architecture x86/64
    Image: Debian GNU/Linux 11(bullseye)
    Zone: Europe-west3-a
    Tech Stack: API - Python 3.7.14, Web framework - Fast API
    Implementation: 
    Backend is added in order to provide REST APIs to be used from the UI. The first API provides the three different datasets and the predefined inputs. The second API gives the prediction for the custom and the predefined inputs.

    Please find more detail inside backend folder.

### ML:
    Training: Google Colab pro+
    Instance spec: 51 GB RAM
    GPU: Google Colab pro+
    PREDICTOR Model architecture: Roberta model
    EDITOR MODEL architecture: t5-samll model

    Read our report for more detials.


## Citation
```bibtex
@inproceedings{Ross2020ExplainingNM,
    title = "Explaining NLP Models via Minimal Contrastive Editing (MiCE)",
    author = "Ross, Alexis  and Marasovi{\'c}, Ana  and Peters, Matthew E.",
    booktitle = "Findings of the Association for Computational Linguistics: ACL 2021",
    publisher = "Association for Computational Linguistics",
    url= "https://arxiv.org/abs/2012.13985",
}
