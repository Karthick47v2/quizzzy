import firebase_admin
from firebase_admin import firestore
from firebase_admin import credentials


class FirebaseService:
    def __init__(self):
        """initialize firebase firestore client.
        """
        firebase_admin.initialize_app(
            credentials.Certificate("./secret/serviceAccountKey.json"))
        self._db = firestore.client()

    def update_generated_status(self, request, status):
        """change status of 'isGenerated' is firestore.

        Args:
            request (ModelInput): request format from flutter.
            status (bool): state whether question generated.
        """
        docRef = self._db.collection('users').document(request.uid)
        docRef.update({'isGenerated': status})

    def send_results_to_fs(self, request, questions, crct_ans, all_ans):
        """send generated question to appropiate fs doc.

        Args:
            request (ModelInput): request format from flutter.
            questions (list[str]): list of generated questions.
            crct_ans (list[str]): list of correct answers.
            all_ans (list[list[str]]): list of list of all answers.
        """
        docRef = self._db.collection('users').document(request.uid)
        for i in range(len(questions)):
            dict = {
                'question': questions[i],
                'crct_ans': crct_ans[i],
                'all_ans': all_ans[i * 4: 4 + i * 4]
            }
            docRef.collection(request.name).document(str(i)).set(dict)
