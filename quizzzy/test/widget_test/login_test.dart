import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:quizzzy/screens/auth/login.dart';
import 'package:quizzzy/screens/auth/signup.dart';
import 'package:quizzzy/screens/auth/verify.dart';
import 'package:quizzzy/screens/home/home.dart';

import '../unit_test/firebase_stub.dart';
import '../unit_test/firebase_stub.mocks.dart';
import 'home_page_test.dart';

main() {
  setUp(() async {
    Get.testMode = true;
    initStubs();
    await initApp();
    initHomeStubs();
  });
  testWidgets('Have to route to signup', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: Login()));

    expect(find.text("Don't have an account ?"), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);

    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    expect(find.byType(SignUp), findsOneWidget);
  });

  group('Login functionalities', () {
    String email = 'test_user@gmail.com';
    String pass = 'Test_User1';

    when(
      mockFirebaseAuth.signInWithEmailAndPassword(email: email, password: pass),
    ).thenAnswer((_) async => MockUserCredential());

    tapLogin(WidgetTester tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: Login()));

      await tester.enterText(find.byKey(const Key('input-email')), email);
      await tester.enterText(find.byKey(const Key('input-pass')), pass);

      expect(find.text(email), findsOneWidget);
      expect(find.text(pass), findsOneWidget);

      await tester.tap(find.byKey(const Key('btn-auth')));
      await tester.pumpAndSettle();
    }

    testWidgets('Navigate to home if login successful',
        (WidgetTester tester) async {
      when(mockUser.emailVerified).thenAnswer((_) => true);

      await tapLogin(tester);

      expect(find.byType(Home), findsOneWidget);
    });

    testWidgets('Navigate to verfiy page if user not verified',
        (WidgetTester tester) async {
      when(mockUser.emailVerified).thenAnswer((_) => false);

      await tapLogin(tester);

      expect(find.byType(VerifyEmail), findsOneWidget);
    });

    testWidgets('Display error if login failed', (WidgetTester tester) async {
      when(
        mockFirebaseAuth.signInWithEmailAndPassword(
            email: email, password: pass),
      ).thenAnswer(((_) =>
          throw FirebaseAuthException(code: "400", message: "Login failed")));

      await tapLogin(tester);

      expect(find.text("Error"), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 3));
    });
  });
}
