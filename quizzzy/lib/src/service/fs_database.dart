import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

User? user = FirebaseAuth.instance.currentUser;
CollectionReference users = FirebaseFirestore.instance.collection("users");

// get user type from firestore (teacher / student)
Future<bool> getUserType() async {
  try {
    DocumentSnapshot docSnap = await users.doc(user?.email).get();

    if (docSnap.exists) {
      Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
      return data['isTeacher'];
    }
  } catch (e) {}
  return false;
}
