import 'package:firebase_auth/firebase_auth.dart';

import 'package:quizzzy/service/firestore_db.dart';

/// Firebase Authentication operations
class Auth {
  late FirebaseAuth _auth;
  static Auth? _instance;

  /// Private named constructor for creating singleton.
  Auth._internal() {
    _auth = FirebaseAuth.instance;
  }

  Auth.test(FirebaseAuth testAuth) {
    _auth = testAuth;
  }

  /// Returns an object of [Auth] type without making a new one.
  factory Auth() {
    _instance ??= Auth._internal();
    return _instance!;
  }

  /// The [FirebaseAuth] instance.
  FirebaseAuth get auth => _auth;

  /// User authentication - Login
  ///
  /// Throws error if [FirebaseAuthException] occurs. Returns verification status.
  Future<String> userLogin(String email, String password) async {
    late String res;
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((_) {
        if (_auth.currentUser!.emailVerified) {
          res = "Verified";
          FirestoreService().user = _auth.currentUser;
        } else {
          res = "Not Verified";
        }
      });
    } on FirebaseAuthException catch (e) {
      res = e.message!;
    }
    return res;
  }

  /// User authentication - Signup
  ///
  /// Throws error if [FirebaseAuthException] occurs. Signs out when account is created.
  Future<String> userSignup(String email, String password) async {
    late String res;
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((_) => _auth.currentUser!.sendEmailVerification())
          .then((_) => res = "Success");
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      res = e.message!;
    }
    return res;
  }

  /// User authentication - Signout
  ///
  /// Throws error if [FirebaseAuthException] occurs.
  Future<String> userSignout() async {
    late String res;
    try {
      await _auth.signOut().then((_) => res = 'Success');
    } on FirebaseAuthException catch (e) {
      res = e.message!;
    }
    return res;
  }
}
