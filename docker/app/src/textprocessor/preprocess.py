"""This module handles all textual preprocessing tasks.

@Author: Karthick T. Sharma
"""

import re


def filter_text(context):
    """Remove all signs other than -,-,a-z,A-Z,0-9, and some symbols.....
    and remove all extra blank spaces.

    Args:
        text (str): input string for processing.

    Returns:
        str: processed string.
    """
    text = context.strip()
    text = re.sub('[\u2010-\u2013]', '-', text)
    text = re.sub(r'[^a-zA-Z0-9\.,-?%&*()]', ' ', text)
    text = re.sub(' {2,}', ' ', text)
    return text


def split_text(context, char_range=300):
    """Split the bulk input text into small chunks.

    Args:
        text (str): processed string to be splitted.

    Returns:
        list[str]: list of splitted corpus.
    """
    bulk_text = filter_text(context=context)

    if len(bulk_text) <= char_range:
        return [bulk_text]

    splitted_texts = []
    # split whole input into $(char_range) block of meaningful text.
    # (only split after an full stop has encountered)
    while len(bulk_text) > char_range:
        i = char_range
        while((i < len(bulk_text)) and (bulk_text[i] != '.')):
            i += 1
        splitted_texts.append(bulk_text[:(i+1)])
        bulk_text = bulk_text.replace(bulk_text[:(i+1)], "")
    return splitted_texts


def change_format(false_ans):
    """Change s2v format to fair readable form. Remove '|,_' and toggle case.

    Args:
        false_ans (list[tuple(str,int)]): list of most similar words and their
        similiarity.

    Returns:
        list[str]: false_ans in fair-readable format.
    """
    output = []
    for result in false_ans:
        res = result[0].split('|')
        res = res[0].replace('_', ' ')
        res = res[0].upper() + res[1:]
        output.append(res)
    return output
