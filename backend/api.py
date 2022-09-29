from src.utils import get_args,logger,wrap_text
from src.stage_two import load_models
from src.edit_finder import EditFinder, EditEvaluator
from src.predictors.predictor_utils import fake_tweep_clean,clean_text
import numpy as np
from tqdm import tqdm
import torch
import os
import sys
import time
import json


def archivedresult(task,input_sentence):

    inout_path =  os.path.join("backend","data","input.json")
    with open(inout_path) as json_file:
        input_file = json.load(json_file)     
                
    key = [item['id'] for item in input_file[task] if input_sentence == item['text']]             
    
    if key:
        archived_path =  os.path.join("backend","data","output.json")
        with open(archived_path) as json_file:
                result = json.load(json_file)
        result = [item['result'] for item in result[task] if key[0] == item['id']]       
        return result
    else:
        return key    

def get_label_imdb(p):
    assert "1" in p or "0" in p
    return "pos" if "1" in p else "neg"


def get_label_tweepfake(p):
    assert "1" in p or "0" in p
    return "human" if "bot" in p else "0"


def get_label_newsgroups(p):
    label = {0:"comp",1:"rec",2:"sci",3:"talk",4:"soc",5:"misc",6:"alt"}
    assert "6" in p or "5" in p or "4" in p or "3" in p or "2" in p or "1" in p or "0" in p
    return label.get(int(p))
    

def predict(task,input_sentence):

    editor_path =  os.path.join("results",task, "editors/mice/",task +"_editor.pth")
    sys.argv = ["stage2","-task",task,"-editor_path",editor_path,"-stage2_exp","mice_binary"]
    args = get_args("stage2")

    editor, predictor = load_models(args)

    edit_evaluator = EditEvaluator()
    edit_finder = EditFinder(predictor, editor, 
            beam_width=args.search.beam_width, 
            max_mask_frac=args.search.max_mask_frac,
            search_method=args.search.search_method,
            max_search_levels=args.search.max_search_levels)
    
    if task == "tweepfake":
        _text = fake_tweep_clean(input_sentence)
    else:
        _text = clean_text(input_sentence)

    inputs = [_text]
    np.random.seed(0)
    input_indices = np.array(range(len(inputs)))
    np.random.shuffle(input_indices)
        
    fieldnames = ["idx","edited_input","new_pred","orig_label", "new_contrast_prob_pred", 
                      "minimality", "num_edit_rounds", "mask_frac", "duration", "error"]

    list_dict,indices = [],[]

    for idx, i in tqdm(enumerate(input_indices), total=len(input_indices)):
            inp = inputs[i]
            logger.info(wrap_text(f"ORIGINAL INSTANCE ({i}): {inp}"))
            start_time = time.time()
            error = False
            try:
                edited_list = edit_finder.minimally_edit(inp, 
                        max_edit_rounds=args.search.max_edit_rounds, 
                        edit_evaluator=edit_evaluator)

                orig_contrast_prob = edited_list.orig_contrast_prob
                orig_label = edited_list.orig_label
                contrast_label = edited_list.contrast_label

                if task == "imdb":
                    contrast_label = get_label_imdb(contrast_label)
                elif task == "tweepfake":
                    contrast_label = get_label_tweepfake(contrast_label) 
                elif task == "newsgroups":
                    contrast_label = get_label_newsgroups(contrast_label)     
                
                torch.cuda.empty_cache()
                sorted_list = edited_list.get_sorted_edits()
                masked_sentence = sorted_list[0]['masked_sentence']
               
                indices = [index for index,word in enumerate(masked_sentence.split(" ")) if 'extra' in word]

            except Exception as e:
                logger.info("ERROR: ", e)
                error = True
                sorted_list = []

            end_time = time.time()
            duration = end_time - start_time

            for s_idx, s in enumerate(sorted_list):

                if task == "tweepfake":
                   edited_label = get_label_tweepfake(s['edited_label'])
                   orig_label = get_label_tweepfake(edited_list.orig_label)
                
                elif task == "imdb":
                   edited_label = get_label_imdb(s['edited_label'])
                   orig_label = get_label_imdb(edited_list.orig_label)   

                elif task == "newsgroups":
                   edited_label = get_label_newsgroups(s['edited_label'])
                   orig_label = get_label_newsgroups(edited_list.orig_label)     
                               
                values = [ s_idx,s['edited_input'] ,edited_label,orig_label,
                        s['edited_contrast_prob'].tolist(),s['minimality'], s['num_edit_rounds'],s['mask_frac'],duration,error
                ]

                list_dict.append(dict(zip(fieldnames, values)))       

    return indices,list_dict,orig_contrast_prob,orig_label,contrast_label


