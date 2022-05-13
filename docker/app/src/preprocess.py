"""preprocess inputs for models"""

import re


def preprocess_bulk_text(text):
    """remove all signs other than -,-,a-z,A-Z,0-9, and some symbols.....
       and remove all extra blank spaces.

    Args:
        text (str): input string for preprocessing.

    Returns:
        str: preprocessed string or input string for model.
    """
    text = text.strip()
    text = re.sub('[\u2010-\u2013]', '-', text)
    text = re.sub(r'[^a-zA-Z0-9\.,-?%&*()]', ' ', text)
    text = re.sub(' {2,}', ' ', text)
    return text


def split_text(text, char_range=300):
    """split the bulk input text into required input length for summarizing model.

    Args:
        text (str): preprocessed string to be splitted.
        char_range (int, optional): approx character range of splitted chars. Defaults to 300.

    Returns:
        list[str]: list of splitted corpus.
    """
    bulk_text = preprocess_bulk_text(text)

    if len(bulk_text) <= char_range:
        return [bulk_text]

    splitted_texts = []
    # split whole input into $(char_range) block of meaningful text. (only split after a full stop)
    while len(bulk_text) > char_range:
        i = char_range
        while((i < len(bulk_text)) and (bulk_text[i] != '.')):
            i += 1
        splitted_texts.append(bulk_text[:(i+1)])
        bulk_text = bulk_text.replace(bulk_text[:(i+1)], "")
    return splitted_texts


def preprocess_splitted_text(text, sum_model):
    """preprocess splitted text to required input format for summarizer model.

    Args:
        text (str): splitted preprocessed corpus which is going to be tokenized.
        mcq (SummarizeModel): instance of SummarizeModel.

    Returns:
        tupe[str, str]: tuple of tokens and attention masks.
    """
    encode = sum_model.tokenize(text)
    return encode["input_ids"], encode["attention_mask"]


def preprocess_summary(context, answer, que_model):
    """preprocess summary to required input format for question generator model.

    Args:
        context (str): corpus to input model context.
        answer (str): input model answer.
        que_model (AnsGenModel): instance of AnsGenModel

    Returns:
        tupe[str, str]: tuple of tokens and attention masks.
    """
    encode = que_model.tokenize(context, answer)
    return encode["input_ids"], encode["attention_mask"]


def change_format(distractors):
    """ change s2v format to fair readable form. Remove '|,_' and toggle case.

    Args:
        distractors (list[tuple(str,int)]): list of most similar words and their 
        similiarity.

    Returns:
        list[str]: human-readable format of distractors.
    """
    output = []
    for result in distractors:
        res = result[0].split('|')
        res = res[0].replace('_', ' ')
        res = res[0].upper() + res[1:]
        output.append(res)
    return output
