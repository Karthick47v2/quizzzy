import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

late String userType;

class FirestoreService {
  User? _user;
  CollectionReference _users;

  FirestoreService({required users, required user})
      : _user = user,
        _users = users;

  set user(User? user) => _user = user;
  User? get user => _user;

  set users(CollectionReference users) => _users = users;
  // ignore: unnecessary_getters_setters
  CollectionReference get users =>
      _users; ///////////////////////////////////////////////////////

  // get user type from firestore (teacher / student)
  Future<String?> getUserType() async {
    DocumentSnapshot docSnap = await _users.doc(_user?.uid).get();

    if (docSnap.exists) {
      Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
      userType = data['userType'];
      return data['userType'];
    }
    return null;
  }

  Future<String?> getGeneratorStatus() async {
    DocumentSnapshot docSnap = await _users.doc(_user?.uid).get();

    if (docSnap.exists) {
      Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
      return data['isGenerated'] == true
          ? "Generated"
          : (data['isWaiting'] ? "Waiting" : "None");
    }
    return null;
  }

  Future saveTokenToDatabase(String token) async =>
      await _users.doc(_user?.uid).set({
        'token': token,
      }, SetOptions(merge: true));

  Future<DocumentSnapshot?> getUserDoc(String colID) async =>
      _users.doc(_user?.uid).collection(colID).doc('0').get();

  Future<List<dynamic>> getQuestionnaireNameList(String docPath) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('sendSubCollectionIDs');
    final res = await callable.call(<String, dynamic>{
      'docPath': docPath,
    });
    return res.data['ids'];
  }

  Future<List<Map<String, dynamic>>> getQuestionnaire(String colID) async {
    var snapShot = await _users.doc(_user?.uid).collection(colID).get();
    final allData = snapShot.docs.map((doc) => doc.data()).toList();
    return allData;
  }

  Future<bool> saveUser(String docPath, String type) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('storeUserInfo');
    final res = await callable.call(<String, dynamic>{
      'docPath': docPath,
      'name': _user?.displayName,
      'type': type,
    });
    return res.data['status'] == 200;
  }

  Future<bool> deleteQuestionnaire(String colPath) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('dltSubCollection');
    final res = await callable.call(<String, dynamic>{
      'colPath': colPath,
    });
    return res.data['status'] == 200;
  }
}

late FirestoreService fs;
