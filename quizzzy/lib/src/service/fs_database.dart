import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

User? user = FirebaseAuth.instance.currentUser;
CollectionReference users = FirebaseFirestore.instance.collection("users");

// class FirebaseUser {
//   late String _name;
//   late String _userType;
//   late bool _isGenerated;

//   void setUser(String name, String type, bool isGen) {
//     _name = name;
//     _userType = type;
//     _isGenerated = isGen;
//   }

//   String get getName {
//     return _name;
//   }

//   String get getUserType {
//     return _userType;
//   }

//   bool get getIsGenerated {
//     return _isGenerated;
//   }
// }

// FirebaseUser fbUser = FirebaseUser();

// get user type from firestore (teacher / student)
Future<String?> getUserType() async {
  DocumentSnapshot docSnap = await users.doc(user?.uid).get();

  if (docSnap.exists) {
    Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
    if (data['userType'] != null) {
      // fbUser.setUser(data['name'], data['userType'], data['isGenerated']);
    }
    return data['userType'];
  }
  return null;
}

Future<String?> getGeneratorStatus() async {
  // DocumentSnapshot docSnap = await users.doc(user?.uid).get();
  DocumentSnapshot docSnap = await users.doc("testID").get();

  if (docSnap.exists) {
    Map<String, dynamic> data = docSnap.data() as Map<String, dynamic>;
    return data['isGenerated'] == true
        ? "Generated"
        : (data['isWaiting'] ? "Waiting" : "None");
  }
  return null;
}
