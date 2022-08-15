import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:quizzzy/screens/question_bank/share_quiz_popup.dart';
import 'package:quizzzy/screens/questionnaire/teacher_view.dart';

import '../unit_test/firebase_stub.dart';
import 'home_page_test.dart';
import 'question_bank_test.dart';

main() {
  setUp(() async {
    Get.testMode = true;
    initStubs();
    initHomeStubs();
    await initApp();
  });

  group('Teacher view of popup', () {
    studentDict['userType'] = 'Teacher';
    popupOnTap(WidgetTester tester) async {
      await initQuestionBank(tester);

      await tester.tap(find.text(questionnaireName1));
      await tester.pumpAndSettle();
    }

    testWidgets('Share quiz popup', (WidgetTester tester) async {
      await popupOnTap(tester);

      await tester.tap(find.byKey(const Key('btn-quiz-share')));
      await tester.pump();

      expect(find.byType(ShareQuizPopup), findsOneWidget);

      expect(
          find.textContaining('$mockUID-$questionnaireName1'), findsOneWidget);
    });

    testWidgets('Modify questions', (WidgetTester tester) async {
      await popupOnTap(tester);

      await tester.tap(find.byKey(const Key('btn-quiz-modify')));
      await tester.pump();

      expect(find.byType(TeacherView), findsOneWidget);
    });
  });
}
