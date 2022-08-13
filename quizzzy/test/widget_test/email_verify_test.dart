import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:quizzzy/screens/auth/verify.dart';
import 'package:quizzzy/screens/home/home_page.dart';

import '../unit_test/firebase_stub.dart';
import 'home_page_test.dart';

main() {
  setUp(() async {
    Get.testMode = true;
    initStubs();
    await initApp();
    initHomeStubs();
  });

  showVerifyPage(WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: VerifyEmail()));
  }

  testWidgets('Display verification status', (WidgetTester tester) async {
    await showVerifyPage(tester);

    expect(find.textContaining("verify your account"), findsOneWidget);
    expect(find.text('Resend Email'), findsOneWidget);
  });

  testWidgets('Navigate to Home when verified', (WidgetTester tester) async {
    await showVerifyPage(tester);

    await tester.tap(find.byKey(const Key('btn-resend-email')));

    //simulate verification
    when(mockUser.emailVerified).thenAnswer((_) => true);

    await tester.pumpAndSettle(Duration(seconds: 4));

    expect(find.byType(HomePage), findsOneWidget);
  });
}
