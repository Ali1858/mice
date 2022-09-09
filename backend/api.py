from src.utils import get_args,logger,wrap_text
from src.stage_two import load_models
from src.edit_finder import EditFinder, EditEvaluator
import numpy as np
from tqdm import tqdm
import torch
import os
import sys
import re
import emoji
import time


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

    _text = clean_text(input_sentence)
    inputs = [_text]

    np.random.seed(0)
    input_indices = np.array(range(len(inputs)))
    np.random.shuffle(input_indices)
        
    fieldnames = ["idx","edited_input","edited_label","orig_label", 
                      "orig_contrast_prob_pred","new_contrast_prob_pred", 
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
                values = [ s_idx,s['edited_input'] ,s['edited_label'],edited_list.orig_label,edited_list.orig_contrast_prob,
                        s['edited_contrast_prob'].tolist(),s['minimality'], s['num_edit_rounds'],s['mask_frac'],duration,error
                ]
                list_dict.append(dict(zip(fieldnames, values)))       

    return indices,list_dict



def remove(text, special_chars=["\n", "\t"]):
    text = "\n".join(text.splitlines())
    for char in special_chars:
        text = text.replace(char, " ")
    text = re.sub(r'http\S+|www\S+', '', text)
    return text



def emojize(match):
    return chr(int(match.group(0)[2:], 16))
   



def clean_text(text, special_chars=["\n", "\t"]):
    text = remove(text,special_chars)
    try:
        text_ = re.sub(r"U\+[0-9A-F]+", emojize, text)
    except Exception as e:
        return None
    if "id=" in text_ and "src=" in text_:
        return None
    text_ =  emoji.demojize(text_,language="alias",delimiters=("",""))
    text_ = text_.replace("“",'"').replace("”",'"').replace("’’","'").replace("’","'").replace("‘","'").replace("…","...").replace("<>","")
    text_ = text_.replace('Ã¯Â¿Â½',"'").replace("âĢľ",'"').replace("âĢĻ","'").replace("ï¿½","'")
    

    return " ".join(text_.split())