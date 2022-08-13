import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quizzzy/service/firebase_auth.dart';

import 'firebase_stub.dart';
import 'firebase_stub.mocks.dart';

main() {
  setUp(() {
    initStubs();
  });

  group("User login", () {
    test("Unsuccessful login", () async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
            email: "user@mail.com", password: "Abc@12345"),
      ).thenAnswer(((_) =>
          throw FirebaseAuthException(code: "400", message: "Login failed")));
      expect(
          await Auth().userLogin("user@mail.com", "Abc@12345"), "Login failed");
    });

    test("Non-verified user login", () async {
      when(mockUser.emailVerified).thenAnswer((_) => false);
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
            email: "user@mail.com", password: "Abc@12345"),
      ).thenAnswer((_) async => MockUserCredential());
      expect(
          await Auth().userLogin("user@mail.com", "Abc@12345"), "Not Verified");
    });
  });

  group("User signup", () {
    test("Successful signup", () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
            email: "user@mail.com", password: "Abc@12345"),
      ).thenAnswer((_) async => MockUserCredential());
      expect(await Auth().userSignup("user@mail.com", "Abc@12345"), "Success");
    });

    test("Unsuccessful signup", () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
            email: "user@mail.com", password: "Abc@12345"),
      ).thenAnswer(((_) =>
          throw FirebaseAuthException(code: "400", message: "Signup failed")));
      expect(await Auth().userSignup("user@mail.com", "Abc@12345"),
          "Signup failed");
    });
  });

  group("User signout", () {
    test("Successful signout", () async {
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});
      expect(await Auth().userSignout(), "Success");
    });

    test("Unsuccessful signout", () async {
      when(mockFirebaseAuth.signOut()).thenAnswer(((_) =>
          throw FirebaseAuthException(code: "400", message: "Signup failed")));
      expect(await Auth().userSignout(), "Signup failed");
    });
  });
}
