"""This module contains helper functions for flask application.

@Author: Karthick T. Sharma
"""


def extract_dict(input_dict):
    """Extract key and value from dictionary into string.

    Args:
        dict (dict(str: str)): key value pairs of input args.

    Returns:
        str: parsed dictionary
    """
    output = ""
    for key, value in input_dict.items():
        output += f"{key}: {value} "
    return output[:-1]
