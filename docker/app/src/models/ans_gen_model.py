"""extract keywords from context and find similar words
    with diversity for those keywords.
"""

import numpy as np
import os


from sklearn.metrics.pairwise import cosine_similarity
from keyphrase_vectorizers import KeyphraseCountVectorizer
from sentence_transformers import SentenceTransformer
from sense2vec import Sense2Vec
from keybert import KeyBERT


from src.preprocess import change_format


class AnsGenModel:
    """class holding all operations related to mcq answer
    generation"""
    _SENTENCE_TRANSFORMER_MODEL = 'all-MiniLM-L12-v2'

    def __init__(self):
        """initialize false answer generation models.
        """
        self._init_sentence_transformer()
        self._init_sense2vec()
        self._init_keybert()

    def _init_sentence_transformer(self):
        """initialize sentence embedding .

           https://www.sbert.net/
        """
        self._sentence_model = SentenceTransformer(
            AnsGenModel._SENTENCE_TRANSFORMER_MODEL)

    def _init_sense2vec(self):
        """initialize word vectors to get similar words.

           https://github.com/explosion/sense2vec
        """
        self.s2v = None

        # for unit test only
        if not os.path.isdir(os.getcwd() + 'pre-downloaded'):
            # pylint: disable=import-outside-toplevel
            import urllib.request
            import tarfile
            s2v_url = "https://github.com/explosion/sense2vec/releases/download/"
            s2v_ver_url = s2v_url + "v1.0.0/s2v_reddit_2015_md.tar.gz"
            with urllib.request.urlopen(s2v_ver_url) as req:
                with tarfile.open(fileobj=req, mode='r|gz') as file:
                    file.extractall()
                    self._s2v = Sense2Vec().from_disk("s2v_old")

        else:
            self._s2v = Sense2Vec().from_disk("./pre-downloaded/s2v-old")

    def _init_keybert(self):
        """initialize keyword extration model (KeyBERT) and keypharse
           vectorizer for meaningful keywords.

           https://github.com/MaartenGr/KeyBERT
           https://github.com/TimSchopf/KeyphraseVectorizers
        """
        self._kw_model = KeyBERT()
        self._vectorizer = KeyphraseCountVectorizer()

    def _extract_keywords(self, text):
        """extract keywords from corpus using KeyBERT.

        Args:
            text (str): corpus used to extract keywords.

        Returns:
            list[str]: list of keywords extracted from input corpus.
        """
        kwx = self._kw_model.extract_keywords(
            text, vectorizer=self._vectorizer)

        kw_ls = []
        for i in kwx:
            # 0 -> keyword, 1-> confidence / probability
            kw_ls.append(i[0])
        return kw_ls

    def filter_keywords(self, original, summarized):
        """extract keywords from both summary and original text and only return keywords.
           which are common.

        Args:
            original (str): original corpus.
            summarized (str): summarized corpus.

        Returns:
            list[str]: list of keywords common for both corpus.
        """
        orig_ls = set(self._extract_keywords(original))
        sum_ls = self._extract_keywords(summarized)
        return list(orig_ls.intersection(sum_ls))

    def _get_embedding(self, answer, distractors):
        """return sentence model embedding of answer and distractors.

        Args:
            answer (str): correct answer.
            distractors (list[str]): false answers.

        Returns:
            tuple[list[str], list[str]]: sentence model embedding of answer and distractors.
        """
        return self._sentence_model.encode([answer]), self._sentence_model.encode(distractors)

    def _filter_output(self, orig, dummies):
        """filter out final answers.

        Args:
            orig (str): correct answer.
            dummies (list[str]): false answers list generated from correct answer.

        Returns:
            list[str]: list of final answer which has low similarity.
        """
        ans_embedded, dis_embedded = self._get_embedding(orig, dummies)
        # filter using MMMR
        dist = self._mmr(ans_embedded, dis_embedded, dummies)

        filtered_dist = []
        for dis in dist:
            # 0 -> word, 1 -> confidence / probability
            filtered_dist.append(dis[0].capitalize())

        return filtered_dist

    # pylint: disable=no-self-use
    def _mmr(self, doc_embedding, word_embedding, words, diversity=0.9):
        """word diversity using MMR - Maximal Marginal Relevence.

        Args:
            doc_embedding (list[str]): sentence embedding of correct answer.
            word_embedding (list[str]): sentence embedding of false answer.
            words (list[str]): flase answers.
            diversity (float, optional): diversity coefficient. Defaults to 0.9.

        Returns:
            list[str]: list of final answers.
        """
        # extract similarity between words and docs
        word_doc_similarity = cosine_similarity(word_embedding, doc_embedding)
        word_similarity = cosine_similarity(word_embedding)

        kw_idx = [np.argmax(word_doc_similarity)]
        dist_idx = [i for i in range(len(words)) if i != kw_idx[0]]

        for i in range(3):
            dist_similarities = word_doc_similarity[dist_idx, :]
            target_similarities = np.max(
                word_similarity[dist_idx][:, kw_idx], axis=1)

            # calculate MMR
            mmr = (1 - diversity) * dist_similarities - \
                diversity * target_similarities.reshape(-1, 1)
            mmr_idx = dist_idx[np.argmax(mmr)]

            # update kw
            kw_idx.append(mmr_idx)
            dist_idx.remove(mmr_idx)

        return [(words[idx], round(float(word_doc_similarity.reshape(1, -1)[0][idx]), 4))
                for idx in kw_idx]

    def false_answers(self, query):
        """generate false anwers from correct answer.

        Args:
            query (str): correct answer.

        Returns:
            list[str]: list of final answers if input is valid, else None.
        """
        # get the best sense for given word (like NOUN, PRONOUN, VERB...)
        query_al = self._s2v.get_best_sense(query.lower().replace(' ', '_'))
        # pylint: disable=fixme
        # sometimes word won't be in sense2vec in that case we can't produce any
        # output -- ##### TODO DO: DROP THAT QUESTION
        try:
            assert query_al in self._s2v
            # get most similar 20 words (if any)
            temp = self._s2v.most_similar(query_al, n=20)
            formatted_string = change_format(temp)
            formatted_string.insert(0, query)
            # if answers are numbers then we don't need to filter
            if query_al.split('|')[1] == 'CARDINAL':
                return formatted_string[:4]
            # else filter because sometimes similar words will be US, U.S, USA, AMERICA..
            #  bt all are same no?
            return self._filter_output(query, formatted_string)
        except AssertionError:
            return None
