import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:quizzzy/screens/home/home.dart';
import 'package:quizzzy/screens/questionnaire/stud_finish_popup.dart';
import 'package:quizzzy/screens/questionnaire/student_view.dart';
import 'package:quizzzy/screens/questionnaire/timesup_popup.dart';
import 'package:quizzzy/screens/score/score.dart';

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

  openQuiz(WidgetTester tester) async {
    await initQuestionBank(tester);

    await tester.tap(find.text(questionnaireName1));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('btn-quiz-start')));
    await tester.pumpAndSettle();
  }

  testWidgets('Display quiz page elements', (WidgetTester tester) async {
    await openQuiz(tester);

    expect(find.byType(StudentView), findsOneWidget);

    expect(find.text(questionnaireSub['question']), findsWidgets);
  });

  group('Times up', () {
    passTime(WidgetTester tester) async {
      await openQuiz(tester);

      await tester.pump(const Duration(minutes: 1));
    }

    testWidgets('Display timeup popup when time exceeded',
        (WidgetTester tester) async {
      await passTime(tester);
      expect(find.byType(TimesupPopup), findsOneWidget);
    });

    testWidgets('Navigate to score after timesup', (WidgetTester tester) async {
      await passTime(tester);

      await tester.tap(find.byKey(const Key('btn-timeup-conf')));
      await tester.pumpAndSettle();

      expect(find.byType(Score), findsOneWidget);
    });
  });

  testWidgets('Finish questionniare and get result',
      (WidgetTester tester) async {
    await openQuiz(tester);

    await tester.tap(find.text(questionnaireSub['crct_ans']));
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.byType(StudFinishPopup), findsOneWidget);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.byType(Score), findsOneWidget);
    // we pressed crct ans so 100%
    expect(find.textContaining('100'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('btn-score-cont')));
    await tester.tap(find.byKey(const Key('btn-score-cont')));
    await tester.pumpAndSettle();

    expect(find.byType(Home), findsOneWidget);
  });
}
