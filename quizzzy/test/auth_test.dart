import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quizzzy/src/service/fbase_auth.dart';

// mock firebase user
class MockUser extends Mock implements User {}

// mock firebase respose
class MockAuthResult extends Mock implements UserCredential {}

// mock firebaseauth
class MockFirebaseAuth extends Mock implements FirebaseAuth {
  final MockUser _mockUser = MockUser();
  @override
  User? get currentUser => _mockUser;
}

main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late Auth auth;
  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    auth = Auth(auth: mockFirebaseAuth);
  });

  // test functionality of firebase login
  group("User login", () {
    test("Verified user login", () async {
      when(mockFirebaseAuth.currentUser!.emailVerified).thenReturn(true);
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
            email: "user@mail.com", password: "Abc@12345"),
      ).thenAnswer((realInvocation) async => MockAuthResult());
      expect(await auth.userLogin("user@mail.com", "Abc@12345"), "Verified");
    });

    test("Non-verified user login", () async {
      when(mockFirebaseAuth.currentUser!.emailVerified).thenReturn(false);
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
            email: "user@mail.com", password: "Abc@12345"),
      ).thenAnswer((realInvocation) async => MockAuthResult());
      expect(
          await auth.userLogin("user@mail.com", "Abc@12345"), "Not Verified");
    });

    test("Unsuccessful login", () async {
      when(mockFirebaseAuth.currentUser!.emailVerified).thenReturn(false);
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
            email: "user@mail.com", password: "Abc@12345"),
      ).thenAnswer(((realInvocation) =>
          throw FirebaseAuthException(code: "400", message: "Login failed")));
      expect(
          await auth.userLogin("user@mail.com", "Abc@12345"), "Login failed");
    });
  });

  // test functionality of firebase signup
  group("User signup", () {
    test("Successful signup", () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
            email: "user@mail.com", password: "Abc@12345"),
      ).thenAnswer((realInvocation) async => MockAuthResult());
      expect(await auth.userSignup("user@mail.com", "Abc@12345"), "Success");
    });

    test("Unsuccessful signup", () async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
            email: "user@mail.com", password: "Abc@12345"),
      ).thenAnswer(((realInvocation) =>
          throw FirebaseAuthException(code: "400", message: "Signup failed")));
      expect(
          await auth.userSignup("user@mail.com", "Abc@12345"), "Signup failed");
    });
  });
}
