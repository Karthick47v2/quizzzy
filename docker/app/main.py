	## IMPORT LIBS
# natural language toolkit for helping utilities
import nltk
nltk.download('punkt')
from nltk.tokenize import sent_tokenize

# text preprocessing
import string
import re

# meaningful keyword extraction
# https://github.com/MaartenGr/KeyBERT
# https://github.com/TimSchopf/KeyphraseVectorizers
from keybert import KeyBERT
from keyphrase_vectorizers import KeyphraseCountVectorizer

# onnx model inferece 
# https://github.com/Ki6an/fastT5
from fastT5 import get_onnx_model, get_onnx_runtime_sessions, OnnxT5 

# working with transformers
from transformers import AutoTokenizer

# helper
import numpy as np
import random
from typing import List

# file dir helper
from pathlib import Path
import os

# generate simialr words
# https://github.com/explosion/sense2vec
from sense2vec import Sense2Vec

# sentence embedding
# https://www.sbert.net/
from sentence_transformers import SentenceTransformer
# commonly used model
sentence_model = SentenceTransformer('all-MiniLM-L12-v2')

# word similiarity
from sklearn.metrics.pairwise import cosine_similarity

# creating APIS
from fastapi import FastAPI        

# body for POST   
from pydantic import BaseModel      



## INITIALIZE ALL REQUIRED MODELS
# load vectors
s2v = Sense2Vec().from_disk("./pre-downloaded/s2v-old")

# initialize keyword extration model (KeyBERT) and keypharse vectorizer for meaningful keywords
kw_model = KeyBERT()
vectorizer = KeyphraseCountVectorizer()

# initialize summarize model
model_path = './pre-downloaded/t5-summarize/'
model_name = "t5-base"
encoder_path = os.path.join(model_path, f"{model_name}-encoder-quantized.onnx")
decoder_path = os.path.join(model_path, f"{model_name}-decoder-quantized.onnx")
init_decoder_path = os.path.join(model_path, f"{model_name}-init-decoder-quantized.onnx")

model_sessions = get_onnx_runtime_sessions((encoder_path,decoder_path,init_decoder_path))
sum_model = OnnxT5(model_path, model_sessions)
sum_tokenizer = AutoTokenizer.from_pretrained(model_path)

# initialize question generation model
model_path = './pre-downloaded/t5-question'
model_name = 't5_question'
encoder_path = os.path.join(model_path, f"{model_name}-encoder-quantized.onnx")
decoder_path = os.path.join(model_path, f"{model_name}-decoder-quantized.onnx")
init_decoder_path = os.path.join(model_path, f"{model_name}-init-decoder-quantized.onnx")

model_sessions = get_onnx_runtime_sessions((encoder_path,decoder_path,init_decoder_path))
q_model = OnnxT5(model_path, model_sessions)
q_tokenizer = AutoTokenizer.from_pretrained(model_path)



## HELPER FUNCIONS FOR SUMMARIZATION
# preprocess the text (removing unwanted signs)
# remove all signs other than -,-,a-z,A-Z,0-9..... and remove all extra blank spaces
def preprocess_bulk_text(text):
  text = text.strip()
  text = re.sub('[\u2010-\u2013]', '-', text)
  text = re.sub('[^a-zA-Z0-9\.,-?%&*()]', ' ', text)
  text = re.sub(' {2,}', ' ', text)
  return text

# split the bulk input text into required input length for summarizing model
def split_text(text, range=300):
  bulk_text = preprocess_bulk_text(text)
  splitted_texts = []
  # split whole input into $(range) block of meaningful text. (only split after a full stop)
  while(len(bulk_text) > range):
    i = range
    while((i < len(bulk_text)) and (bulk_text[i] != '.')):
      i += 1
    splitted_texts.append(bulk_text[:(i+1)])
    bulk_text = bulk_text.replace(bulk_text[:(i+1)], "")
  return splitted_texts

# preprocess splitted text to required input format for summarizer model
def preprocess_splitted_text(text):
  # "summarize: xxxxxxxx" is the input format for model
  encode = sum_tokenizer.encode_plus("summarize: " + text, return_tensors='pt', pad_to_max_length=False, truncation=True)
  return encode["input_ids"], encode["attention_mask"]

# summarize input text
def summarize(text):
  input_tokens_ids, attention_mask = preprocess_splitted_text(text)
  # encoded output
  summary_encoded = sum_model.generate(input_ids=input_tokens_ids, 
                                   attention_mask=attention_mask,
                                   num_beams=3,                       # get the sentence with max prob of 3 tokens
                                   num_return_sequences=1,            # only need 1 outpu
                                   no_repeat_ngram_size=2,            # no repeat of 2 ngram
                                   max_length=512,                    # model's in length - default
                                   early_stopping=True)
  

  # decode summarized token
  output = sum_tokenizer.decode(summary_encoded[0], skip_special_tokens=True, clean_up_tokenization_spaces=True)
  return postprocess_summary(output)

# postpress the output of summarizer model for fair readable output
# capitalize firt word of sentence. put spaces in required place
def postprocess_summary(text):
  output = ""

  for x in sent_tokenize(text):
    x = x.capitalize()
    output += " " + x
  return output



## HELPER FUNCTIONS FOR KEYWORD EXTRACTION
# extract keywords using KeyBERT
def extract_keywords(text, kw_pop):
  kw = kw_model.extract_keywords(text, vectorizer=vectorizer)

  kw_ls = []
  for i in kw:
    # 0 -> keyword, 1-> confidence / probability
    kw_ls.append(i[0])
  return kw_ls

# extract keywords from both summary and original text and only 
# return keywords which are common (extra validation)

# max keywords per summary-original pair is 5 so that we can reduce 
# unnecessary extra questions
def filter_keywords(original, summarized, kw_pop=5):
  orig_ls = extract_keywords(original, kw_pop)
  sum_ls = extract_keywords(summarized, kw_pop)
  orig_ls = set(orig_ls)
  return list(orig_ls.intersection(sum_ls))



## HELPER FUNCTIONS FOR FALSE ANSWERS
# generate false answers from correct answer 
def false_answers(query, word_similarity_threshold=0.7):
  # get the best sense for given word (like NOUN, PRONOUN, VERB...)
  query_al = s2v.get_best_sense(query.lower().replace(' ', '_'))

  # sometimes word won't be in sense2vec in that case we can't produce any output -- ##### TODO DO: DROP THAT QUESTION
  try:
    assert query_al in s2v
    # get most similar 20 words (if any)
    temp = s2v.most_similar(query_al, n=20)
    formatted_string = change_format(query_al, temp)
    formatted_string.insert(0, query)
    # if answers are numbers then we don't need to filter 
    if query_al.split('|')[1] == 'CARDINAL':
      return formatted_string[:4]
    # else filter because sometimes similar words will be US, U.S, USA, AMERICA.. bt all are same no?
    return filter_output(query, formatted_string)
  except:
    return None

# change s2v format to fair readable form
def change_format(query, distractors):
  output = []
  for result in distractors:
    res = result[0].split('|')
    res = res[0].replace('_', ' ')
    res = res[0].upper() + res[1:]
    output.append(res)
  return output

# generate embeddings 
def return_embedding(answer, distractors):
  return sentence_model.encode([answer]), sentence_model.encode(distractors)

# filter false answers 
def filter_output(orig, dummies):
  ans_embedded, dis_embedded = return_embedding(orig, dummies)
  # filter using MMMR 
  dist = mmr(ans_embedded, dis_embedded,dummies)

  filtered_dist = []
  for d in dist:
    # 0 -> word, 1 -> confidence / probability
    filtered_dist.append(d[0])

  return filtered_dist

# Mdicersity using MR - Maximal Marginal Relevence
def mmr(doc_embedding, word_embedding, words, top_n=4, diversity=0.9):
  # extract similarity between words and docs
  word_doc_similarity = cosine_similarity(word_embedding, doc_embedding)
  word_similarity = cosine_similarity(word_embedding)
  
  kw_idx = [np.argmax(word_doc_similarity)]
  dist_idx = [i for i in range(len(words)) if i != kw_idx[0]]

  for i in range(top_n - 1):
    dist_similarities = word_doc_similarity[dist_idx, :]
    target_similarities = np.max(word_similarity[dist_idx][:, kw_idx], axis=1)

    # calculate MMR
    mmr = (1 - diversity) * dist_similarities - diversity * target_similarities.reshape(-1, 1)
    mmr_idx = dist_idx[np.argmax(mmr)]

    # update kw
    kw_idx.append(mmr_idx)
    dist_idx.remove(mmr_idx)

  return [(words[idx], round(float(word_doc_similarity.reshape(1, -1)[0][idx]), 4)) for idx in kw_idx]



## HELPER FUNCTIONS FOR QUESTION GENERATION
# preprocess the summary for question generation
def preprocess_summary(context, answer):
  # "context: XXXXXXXXxxxxx answer: XXXXXXXXX" is the required format for question generation model
  text = "context: {} answer: {}".format(context, answer)
  encode = q_tokenizer.encode_plus(text, 
                                   return_tensors='pt',
                                   max_length = 382,                  # for meaningful context-question pair ---- no a magical number
                                   pad_to_max_length=False,      
                                   truncation=True)
  return encode["input_ids"], encode["attention_mask"]

# generate questions from context-answer pair
def gen_question(context, answer):
  input_tokens_ids, attention_mask = preprocess_summary(context, answer)

  # encoded output
  question_encoded = q_model.generate(input_ids=input_tokens_ids, 
                                             attention_mask=attention_mask,
                                             num_beams=5,             # 5 gave good results 
                                             no_repeat_ngram_size=2,  #
                                             max_length=72,           # single question's max token len-- just an arbitary no -- but its enough
                                             early_stopping=True)
  
  # decode summarized token and post process it before print
  output = q_tokenizer.decode(question_encoded[0], skip_special_tokens=True, clean_up_tokenization_spaces=True)
  output = output.replace("question: ", "")
  output = output.strip()
  return output



## MAIN FUNCTION
def generate_que_n_ans(context):
    # generate questions from keywords
    splitted_text = split_text(context)

    summary = []
    filtered_kw = []
    questions = []
    crct_ans = []
    all_answers = []

    # summarize and find keywords for each splitted text
    for i in range(len(splitted_text)):
        summary.append(summarize(splitted_text[i]))
        filtered_kw.append(filter_keywords(splitted_text[i], summary[i]))

    # generate questions and false answers for each keywords
    for i in range(len(filtered_kw)):
        for x in filtered_kw[i]:
            results = false_answers(x)
            if results != None:
                questions.append(gen_question(summary[i], x))
                crct_ans.append(x)
                random.shuffle(results)
                all_answers.append(results)
    # squeezing the 2d list to 1d for API response ## 2d nested list give error --
    all_answers = sum(all_answers, [])
    return questions, crct_ans, all_answers



## FastAPI setup
app = FastAPI()

# body classes for req n' res
class ModelInput(BaseModel):
    context: str

class ModelOutput(BaseModel):
    questions: List[str]
    crct_ans: List[str]
    all_answers: List[str]



## API
# req -> context and ans-s,
# res -> questions    
@app.post('/get-questions')
def model_inference(request: ModelInput):
    context = request.context
    questions, crct_ans, all_ans = generate_que_n_ans(context)
    return ModelOutput(questions=questions, crct_ans=crct_ans, all_answers=all_ans)