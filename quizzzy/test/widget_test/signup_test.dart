import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:quizzzy/screens/auth/login.dart';
import 'package:quizzzy/screens/auth/signup.dart';

import '../unit_test/firebase_stub.dart';
import '../unit_test/firebase_stub.mocks.dart';

main() {
  setUp(() async {
    Get.testMode = true;
    initStubs();
  });
  testWidgets('Have to route to login', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: SignUp()));

    expect(find.text("Already have an account ?"), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);

    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    expect(find.byType(Login), findsOneWidget);
  });

  group('Signup functionalities', () {
    String email = 'user@mail.com';
    String pass = "Abc@12345";

    tapLogin(WidgetTester tester, String msg) async {
      await tester.pumpWidget(const GetMaterialApp(home: SignUp()));

      await tester.enterText(find.byKey(const Key('input-email')), email);
      await tester.enterText(find.byKey(const Key('input-pass')), pass);

      expect(find.text(email), findsOneWidget);
      expect(find.text(pass), findsOneWidget);

      await tester.tap(find.byKey(const Key('btn-auth')));
      await tester.pump();

      expect(find.text(msg), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 3));
    }

    testWidgets('Navigate to home if signup successful',
        (WidgetTester tester) async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email, password: pass),
      ).thenAnswer((_) async => MockUserCredential());

      await tapLogin(tester, 'Check mail');
    });

    testWidgets('Display error if signup failed', (WidgetTester tester) async {
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email, password: pass),
      ).thenAnswer(((_) =>
          throw FirebaseAuthException(code: "400", message: "Signup failed")));

      await tapLogin(tester, 'Error');
    });
  });
}
