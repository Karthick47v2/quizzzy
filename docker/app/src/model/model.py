"""This module contains all tasks related to transformer model

@Author: Karthick T. Sharma
"""

import os
import gdown

from fastT5 import get_onnx_runtime_sessions, OnnxT5
from transformers import AutoTokenizer


class Model:
    """Abstract class for model predictions."""

    def __init__(self, model_name, path_id):
        """Load model into memory.

           https://github.com/Ki6an/fastT5
        """

        os.environ["TOKENIZERS_PARALLELISM"] = "false"

        model_path = f"./resources/{model_name}"  # put dot
        if not os.path.isdir(os.getcwd() + model_path[1:]):
            gdown.download_folder(
                id=path_id, output=model_path[2:], quiet=True, use_cookies=False)

        encoder_path = os.path.join(
            model_path, f"{model_name}-encoder-quantized.onnx")
        decoder_path = os.path.join(
            model_path, f"{model_name}-decoder-quantized.onnx")
        init_decoder_path = os.path.join(
            model_path, f"{model_name}-init-decoder-quantized.onnx")

        model_sessions = get_onnx_runtime_sessions(
            (encoder_path, decoder_path, init_decoder_path))
        self.__model = OnnxT5(model_path, model_sessions)
        self.__tokenizer = AutoTokenizer.from_pretrained(model_path)

    def tokenize_corpus(self, text, max_length):
        """Tokeninze model input.

        Args:
            text (str): preprocessed corpus.
            max_length (int, optional): limits length of returned sequence.

        Returns:
            tupe[str, str]: tuple of tokens and attention masks.
        """

        encode = self.__tokenizer.encode_plus(
            text, return_tensors='pt', max_length=max_length,
            pad_to_max_length=False, truncation=True)

        return encode["input_ids"], encode["attention_mask"]

    def __extract_dict(self, input_dict):
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

    # pylint: disable=too-many-arguments
    def inference(self, num_beams, no_repeat_ngram_size, model_max_length,
                  num_return_sequences=None, token_max_length=None, **kwargs):
        """Generate output from model.

        Args:
            num_beams (int): max no. of output to be considered.
            no_repeat_ngram_size (int): all ngrams of that size can only occur once.
            model_max_length (int): max length generated tokens can have.
            num_return_sequences (_type_, optional): No of returned sequences. Defaults to None.
            token_max_length (int, optional): max length returned sequence can have. Defaults
            to None.

        Returns:
            str: unprocessed model output.
        """

        text = self.__extract_dict(kwargs)

        input_tokens_ids, attention_mask = self.tokenize_corpus(
            text, token_max_length)

        # encoded output
        encoded_output = self.__model.generate(input_ids=input_tokens_ids,
                                               attention_mask=attention_mask,
                                               num_beams=num_beams,
                                               num_return_sequences=num_return_sequences,
                                               no_repeat_ngram_size=no_repeat_ngram_size,
                                               max_length=model_max_length,
                                               early_stopping=True)

        # decode summarized token
        output = self.__tokenizer.decode(
            encoded_output[0], skip_special_tokens=True, clean_up_tokenization_spaces=True)
        return output
