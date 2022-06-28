import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'db_model/question_set.dart';

late String? userType;

class FirestoreService {
  User? _user;
  CollectionReference _users;
  late FirebaseFunctions fFunc;

  FirestoreService({inst, user, fbFunc})
      : _user = user,
        _users = inst.collection("users") {
    inst.settings = const Settings(persistenceEnabled: false);
    fFunc = fbFunc;
  }

  set user(User? user) => _user = user;
  // ignore: unnecessary_getters_setters
  User? get user => _user;

  set users(CollectionReference users) => _users = users;
  // ignore: unnecessary_getters_setters
  CollectionReference get users =>
      _users; ///////////////////////////////////////////////////////

  // get user type from firestore (teacher / student)
  Future<String?> getUserType() async {
    return await _users.doc(_user?.uid).get().then((docSnap) {
      if (docSnap.exists) {
        Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
        userType = data['userType'];
        return data['userType'];
      } else {
        return "None";
      }
    }).onError((error, stackTrace) => error.toString());
  }

  Future<String> getGeneratorStatus() async {
    return await _users.doc(_user?.uid).get().then((docSnap) {
      if (docSnap.exists) {
        Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
        return data['isGenerated'] == true
            ? "Generated"
            : (data['isWaiting'] ? "Waiting" : "None");
      } else {
        return "None";
      }
    }).onError((error, stackTrace) => error.toString());
  }

  Future<bool> saveTokenToDatabase(String token) async {
    HttpsCallable callable = fFunc.httpsCallable('storeUserInfo');
    return await callable.call(<String, dynamic>{
      'token': token,
    }).then((value) => value.data['status'] == 200);
  }

  Future<DocumentSnapshot?> getUserDoc(String colID) async =>
      _users.doc(_user?.uid).collection(colID).doc('0').get();

  Future<List<dynamic>> getQuestionnaireNameList() async {
    HttpsCallable callable = fFunc.httpsCallable('sendSubCollectionIDs');
    return await callable.call().then((value) => value.data['ids']);
  }

  Future<List<Map<String, dynamic>>> getQuestionnaire(String colID) async {
    return await _users
        .doc(_user?.uid)
        .collection(colID)
        .get()
        .then((value) => value.docs.map((doc) => doc.data()).toList());
  }

  Future<bool> saveUser(String name, String type) async {
    HttpsCallable callable = fFunc.httpsCallable('storeUserInfo');
    return await callable.call(<String, dynamic>{
      'name': name,
      'userType': type,
    }).then((value) => value.data['status'] == 200);
  }

  Future<bool> setWaiting(bool state) async {
    HttpsCallable callable = fFunc.httpsCallable('storeUserInfo');
    return await callable.call(<String, dynamic>{
      'isWaiting': state,
    }).then((value) => value.data['status'] == 200);
  }

  Future<bool> deleteQuestionnaire(String colPath) async {
    HttpsCallable callable = fFunc.httpsCallable('dltSubCollection');
    return await callable.call(<String, dynamic>{
      'colPath': colPath,
    }).then((value) => value.data['status'] == 200);
  }

  Future<bool> saveModifiedQuiz(List<QuestionSet> qSet) async {
    HttpsCallable callable = fFunc.httpsCallable('storeQuiz');
    return await callable.call(<String, dynamic>{
      'qSet': qSet,
    }).then((value) => value.data['status'] == 200);
  }
}

late FirestoreService fs;
