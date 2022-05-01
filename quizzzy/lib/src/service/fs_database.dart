import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

User? user = FirebaseAuth.instance.currentUser;
CollectionReference users = FirebaseFirestore.instance.collection("users");

// get user type from firestore (teacher / student)
Future<String?> getUserType() async {
  DocumentSnapshot docSnap = await users.doc(user?.uid).get();

  if (docSnap.exists) {
    Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
    return data['userType'];
  }
  return null;
}

Future<String?> getGeneratorStatus() async {
  DocumentSnapshot docSnap = await users.doc(user?.uid).get();

  if (docSnap.exists) {
    Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
    return data['isGenerated'] == true
        ? "Generated"
        : (data['isWaiting'] ? "Waiting" : "None");
  }
  return null;
}

Future<void> saveTokenToDatabase(String token) async =>
    await users.doc(user?.uid).set({
      'token': token,
    }, SetOptions(merge: true));
