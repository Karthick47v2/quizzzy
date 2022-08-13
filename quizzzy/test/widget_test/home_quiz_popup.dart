import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:quizzzy/screens/home/quiz_code_popup.dart';

import '../unit_test/firebase_stub.dart';
import 'home_page_test.dart';

main() {
  setUp(() async {
    Get.testMode = true;
    initStubs();
    initHomeStubs();

    await initApp();
  });

  testWidgets('Show quiz code popup', (WidgetTester tester) async {
    await tapOnScreen(tester, const Key('btn-attempt-quiz'));
    expect(find.byType(QuizCodePopup), findsOneWidget);
  });

  group('Textbox interactivity', () {
    testWidgets('Should close widget if code is correct',
        (WidgetTester tester) async {
      await tapOnScreen(tester, const Key('btn-attempt-quiz'));
      await tester.enterText(find.byKey(const Key('input-code')), "test-user");
      expect(find.text('test-user'), findsOneWidget);

      await tester.tap(find.byKey(
        const Key('btn-quiz-code-confirm'),
      ));

      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('test-user'), findsNothing);
    });

    testWidgets('Should popop error when code is incorrect',
        (WidgetTester tester) async {
      await tapOnScreen(tester, const Key('btn-attempt-quiz'));
      await tester.enterText(find.byKey(const Key('input-code')), "test_user");
      expect(find.text('test_user'), findsOneWidget);

      await tester.tap(find.byKey(
        const Key('btn-quiz-code-confirm'),
      ));

      await tester.pump();
      expect(find.text('Error'), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });
  });
}
