import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:quizzzy/service/fbase_auth.dart';

class FirestoreService {
  late User? _user;
  late CollectionReference _users;
  late FirebaseFunctions fFunc;

  static FirestoreService? _instance;

  /// Private named constructor for creating singleton.
  FirestoreService._internal() {
    _user = Auth().auth.currentUser;
    _users = FirebaseFirestore.instance.collection("users");
    fFunc = FirebaseFunctions.instance;
  }

  FirestoreService.test(
      User user, CollectionReference users, FirebaseFunctions func) {
    _user = user;
    _users = users;
    fFunc = func;
  }

  /// Returns an object of [FirestoreService] type without making a new one.
  factory FirestoreService() {
    _instance ??= FirestoreService._internal();
    return _instance!;
  }

  /// The [User] object.
  set user(User? user) => _user = user!;
  User? get user => _user;

  /// The [CollectionReference]object.
  set users(CollectionReference users) => _users = users;

  /// Get user type
  ///
  /// Returns user's user type from [Firestore]. Throws error if any unexpected error occurs.
  Future<String?> getUserType() async {
    return await _users.doc(_user!.uid).get().then((docSnap) {
      if (docSnap.exists) {
        Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
        if (data['userType'] != null) {
          return data['userType'];
        }
      }
      return "None";
    }).onError((error, stackTrace) => error.toString());
  }

  /// Get question generation status.
  ///
  /// Returns wheter previous request is processed or not from [Firestore]. Throws error if any
  /// unexpected error occurs.
  Future<bool> getGeneratorStatus() async {
    return await _users.doc(_user!.uid).get().then((docSnap) {
      if (docSnap.exists) {
        Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
        return data['GeneratorWorking'];
      }
    }).onError((error, stackTrace) => error.toString());
  }

  /// Get user document from [Firestore].
  Future<DocumentSnapshot?> getUserDoc(String colID) async =>
      _users.doc(_user!.uid).collection(colID).doc('0').get();

  /// Get all questionnaire label list from [Firestore].
  Future<List<dynamic>> getQuestionnaireNameList() async {
    HttpsCallable callable = fFunc.httpsCallable('sendSubCollectionIDs');
    return await callable.call().then((value) => value.data['ids']);
  }

  /// Get a questionnaire from [Firestore].
  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getQuestionnaire(
      String colID, String userID) async {
    return await _users
        .doc(userID == "" ? _user!.uid : userID)
        .collection(colID)
        .get()
        .then((value) => value.docs.map((doc) => doc).toList());
  }

  /// Saves Firebase Cloud Messaging (FCM) token to [Firestore].
  ///
  /// Returns whether operation is success or not.
  Future<bool> saveTokenToDatabase(String token) async {
    HttpsCallable callable = fFunc.httpsCallable('storeUserInfo');
    return await callable.call(<String, dynamic>{
      'token': token,
    }).then((value) => value.data['status'] == 200);
  }

  /// Store user info to [Firestore].
  ///
  /// If [isFirstTime] then store initial user details, else stores waiting status for question
  /// generation. Returns whether operation is success or not.
  Future<bool> saveUser(bool isFirstTime,
      {String name = "", String type = "", bool state = false}) async {
    Map<String, dynamic> dict =
        isFirstTime ? {'name': name, 'userType': type} : {'isWaiting': state};
    HttpsCallable callable = fFunc.httpsCallable('storeUserInfo');
    return await callable
        .call(dict)
        .then((value) => value.data['status'] == 200);
  }

  Future<bool> generateQuiz(String quizID) async {
    HttpsCallable callable = fFunc.httpsCallable('addQuiz');
    return await callable.call(<String, dynamic>{'quizID': quizID}).then(
        (value) => value.data['status'] == 200);
  }

  Future<bool> sendScore(String quizID, double score, String author) async {
    HttpsCallable callable = fFunc.httpsCallable('updateScore');
    return await callable.call(<String, dynamic>{
      'quizID': quizID,
      'score': score,
      'author': author
    }).then((value) => value.data['status'] == 200);
  }

  /// Store user type on database
  ///
  /// Throws error if any server error occurs
  Future<bool> sendUserType(
    String str,
    bool isTeacher,
  ) async {
    // explicitly initialize inorder to reload
    User? user = Auth().auth.currentUser;

    await user!.reload();
    await user.updateDisplayName(str);
    await user.reload();
    FirestoreService().user = Auth().auth.currentUser;

    return await saveUser(true,
        name: str, type: isTeacher ? 'Teacher' : 'Student');
  }

  Future<bool> deleteQuestions(String name, List<String> qID) async {
    HttpsCallable callable = fFunc.httpsCallable('dltQuestions');
    return await callable.call(<String, dynamic>{
      'col': name,
      'qID': qID,
    }).then((value) => value.data['status'] == 200);
  }
}
