import re
import emoji


def clean_text(text, special_chars=["\n", "\t"]):
    for char in special_chars:
        text = text.replace(char, " ")
    text = re.sub(r'http\S+|www\S+', '', text)
    return text


def emojize(match):
    return chr(int(match.group(0)[2:], 16))

def fake_tweep_clean(text, special_chars=["\n", "\t"]):
    text = clean_text(text,special_chars)
    try:
        text_ = re.sub(r"U\+[0-9A-F]+", emojize, text)
    except Exception as e:
        return None
    text_ =  emoji.demojize(text_,language="alias",delimiters=("",""))
    text_ = text_.replace("“",'"').replace("”",'"').replace("’’","'").replace("…","...")
    text_ = text_.replace('Ã¯Â¿Â½',"'").replace("âĢľ",'"').replace("âĢĻ","'")

    return " ".join(text_.split(" "))
