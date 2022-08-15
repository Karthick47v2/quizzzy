import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:quizzzy/screens/home/home.dart';
import 'package:quizzzy/screens/question_bank/delete_popup.dart';
import 'package:quizzzy/screens/question_bank/question_bank.dart';

import '../custom_mock/custom_mock.dart';
import '../unit_test/firebase_stub.dart';
import 'home_page_test.dart';

main() {
  setUp(() async {
    Get.testMode = true;
    initStubs();
    initHomeStubs();
    await initApp();
  });

  initQuestionBank(WidgetTester tester) async {
    when(mockHttpsCallable.call(any))
        .thenAnswer((_) => Future.value(HttpsCallableResultMock.test({
              'ids': [questionnaireName1, questionnaireName2]
            })));

    await tester.pumpWidget(const GetMaterialApp(home: Home()));

    await tapOnScreen(tester, const Key('btn-q-bank'));
    await tester.pump();

    expect(find.byType(QuestionBank), findsOneWidget);

    await tester.pumpAndSettle();
  }

  testWidgets('Display list of questionnaires', (WidgetTester tester) async {
    await initQuestionBank(tester);
    expect(find.text('Select Questionnaire'), findsOneWidget);

    expect(find.text(questionnaireName1), findsOneWidget);
    expect(find.text(questionnaireName2), findsOneWidget);
  });

  group('Delete popup', () {
    longPressOnWidget(WidgetTester tester) async {
      await initQuestionBank(tester);

      await tester.longPress(find.text(questionnaireName1));
      await tester.pumpAndSettle();
    }

    testWidgets('Display popup on long tap', (WidgetTester tester) async {
      await longPressOnWidget(tester);

      expect(find.byType(DeletePopup), findsOneWidget);
    });

    testWidgets('Close popup message on cancel button',
        (WidgetTester tester) async {
      await longPressOnWidget(tester);

      await tester.tap(find.byKey(const Key('button-q-dlt-decl')));
      await tester.pumpAndSettle();

      expect(find.byType(DeletePopup), findsNothing);
    });

    testWidgets(
        'Delete selected questionniare when conf pressed -firebse exception',
        (WidgetTester tester) async {
      await longPressOnWidget(tester);

      when(mockHttpsCallable.call(any)).thenAnswer(
          (_) => Future.value(HttpsCallableResultMock.test({'status': 400})));

      await tester.tap(find.byKey(const Key('button-q-dlt-conf')));
      await tester.pumpAndSettle();

      expect(find.byType(DeletePopup), findsNothing);
      await tester.pump();

      expect(find.textContaining('Error'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('Delete selected questionniare when conf pressed -succeess',
        (WidgetTester tester) async {
      await longPressOnWidget(tester);

      when(mockHttpsCallable.call(any)).thenAnswer(
          (_) => Future.value(HttpsCallableResultMock.test({'status': 200})));

      await tester.tap(find.byKey(const Key('button-q-dlt-conf')));
      await tester.pumpAndSettle();

      expect(find.byType(DeletePopup), findsNothing);
      await tester.pump();

      expect(find.textContaining('Deleting'), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 3));
    });
  });

  group('Quiz start popup', () {
    tapOnWidget(WidgetTester tester) async {
      await initQuestionBank(tester);

      await tester.tap(find.text(questionnaireName1));
      await tester.pumpAndSettle();
    }

    testWidgets('Show questionniare details', (WidgetTester tester) async {
      await tapOnWidget(tester);

      expect(find.text(questionnaireName1), findsOneWidget);
      expect(find.textContaining('.5'), findsOneWidget);
    });
  });
}
