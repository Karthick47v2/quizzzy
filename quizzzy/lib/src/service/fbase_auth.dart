import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth auth;

  Auth({required this.auth});

  Future<String> userLogin(String email, String password) async {
    late String res;
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((_) => {
                if (auth.currentUser!.emailVerified)
                  {res = "Verified"}
                else
                  {res = "Not Verified"}
              });
    } on FirebaseAuthException catch (e) {
      res = e.message!;
    }
    return res;
  }

  Future<String> userSignup(String email, String password) async {
    late String res;
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((_) => res = "Success");
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      res = e.message!;
    }
    return res;
  }
  ////////////////IMPLEMENT SIGHOUT
  // Future<String> userSignout(String email, String password) async {
  //   late String res;
  //   try {
  //     await auth
  //         .createUserWithEmailAndPassword(email: email, password: password)
  //         .then((_) => res = "Success");
  //     await auth.signOut();
  //   } on FirebaseAuthException catch (e) {
  //     res = e.message!;
  //   }
  //   return res;
  // }
}

late Auth auth;
