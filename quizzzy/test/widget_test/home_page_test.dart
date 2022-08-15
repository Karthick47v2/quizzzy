import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:quizzzy/init_controllers.dart';
import 'package:quizzzy/screens/auth/login.dart';
import 'package:quizzzy/screens/home/exit_popup.dart';
import 'package:quizzzy/screens/home/home.dart';
import 'package:quizzzy/screens/home/home_page.dart';
import 'package:quizzzy/screens/home/logout_popup.dart';
import 'package:quizzzy/screens/import/import.dart';
import 'package:quizzzy/screens/question_bank/question_bank.dart';
import 'package:quizzzy/screens/review/teacher_review.dart';
import 'package:quizzzy/service/db_model/question_set.dart';
import 'package:quizzzy/service/local_notification_service.dart';

import '../custom_mock/custom_mock.dart';
import '../unit_test/firebase_stub.dart';
import '../unit_test/firebase_stub.mocks.dart';

initHomeStubs() {
  fm = MockFirebaseMessaging();

  when(fm.getToken()).thenAnswer((_) => Future.value(null));
  when(fm.onTokenRefresh).thenAnswer(
      (realInvocation) => Stream.fromFuture(Future.value('status')));

  when(mockFirebaseFunctions.httpsCallable(any))
      .thenAnswer((_) => mockHttpsCallable);

  when(mockHttpsCallable.call(any)).thenAnswer(
      (_) => Future.value(HttpsCallableResultMock.test({'status': 200})));
}

initApp() async {
  await Hive.initFlutter();
  await initControllers();
  await setBox();
}

pumpHomePage(WidgetTester tester) async {
  await tester.pumpWidget(const GetMaterialApp(home: HomePage()));
  await tester.pumpAndSettle();
}

tapOnScreen(WidgetTester tester, Key key) async {
  await pumpHomePage(tester);
  await tester.tap(find.byKey(key));
  await tester.pumpAndSettle();
}

main() {
  setUp(() async {
    Get.testMode = true;
    initStubs();
    initHomeStubs();

    await initApp();
  });

  openAndClose(WidgetTester tester, Type widgetType, Key key) async {
    expect(find.byType(widgetType), findsOneWidget);

    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle();

    expect(find.byType(widgetType), findsNothing);
  }

  commonTests() {
    testWidgets('Tap import', (WidgetTester tester) async {
      await tapOnScreen(tester, const Key('btn-import'));

      expect(find.byType(ImportFile), findsOneWidget);
    });

    group('Tap question bank', () {
      testWidgets('No questionnaire in storage', (WidgetTester tester) async {
        when(mockHttpsCallable.call()).thenAnswer(
            (_) => Future.value(HttpsCallableResultMock.test({'ids': []})));
        await tapOnScreen(tester, const Key('btn-q-bank'));
        await tester.pump();

        expect(find.text("No questionnaire found"), findsOneWidget);

        await tester.pumpAndSettle(const Duration(seconds: 3));
      });

      testWidgets('With questionnaire in storage', (WidgetTester tester) async {
        when(mockHttpsCallable.call())
            .thenAnswer((_) => Future.value(HttpsCallableResultMock.test({
                  'ids': ['q1']
                })));
        await tapOnScreen(tester, const Key('btn-q-bank'));
        await tester.pump();

        expect(find.byType(QuestionBank), findsOneWidget);
      });
    });
  }

  group('Display correct user interface', () {
    testWidgets('Display student interface', (WidgetTester tester) async {
      await pumpHomePage(tester);

      expect(find.byKey(const Key('btn-attempt-quiz')), findsOneWidget);
    });

    testWidgets('Display teacher interface', (WidgetTester tester) async {
      studentDict['userType'] = 'Teacher';
      when(mockDocumentSnapshot.data()).thenAnswer((_) => studentDict);
      await pumpHomePage(tester);

      expect(find.byKey(const Key('btn-attempt-quiz')), findsNothing);
    });
  });

  group('Teacher - button group functionality', () {
    commonTests();
    group('Tap review', () {
      testWidgets('With results in storage', (WidgetTester tester) async {
        await tapOnScreen(tester, const Key('btn-review'));
        await tester.pump();

        expect(find.byType(TeacherReview), findsOneWidget);
      });

      testWidgets('With questionnaire in storage', (WidgetTester tester) async {
        userResult = {};
        await tapOnScreen(tester, const Key('btn-review'));
        await tester.pump();

        expect(find.byType(TeacherReview), findsOneWidget);
      });
    });
  });

  group('Student - button group functionality', () {
    studentDict['userType'] = 'Student';
    commonTests();
  });

  group('Show popups', () {
    testWidgets('Show logout popup', (WidgetTester tester) async {
      await tapOnScreen(tester, const Key('btn-log-out'));

      expect(find.byType(LogoutPopup), findsOneWidget);
    });

    testWidgets('Show exit popup', (WidgetTester tester) async {
      await tapOnScreen(tester, const Key('btn-quit'));

      expect(find.byType(ExitPopup), findsOneWidget);
    });
  });

  group('Logout popup functionality', () {
    testWidgets('Decline logout', (WidgetTester tester) async {
      await tapOnScreen(tester, const Key('btn-log-out'));
      await openAndClose(tester, LogoutPopup, const Key('btn-logout-decl'));
      expect(find.byType(Home), findsOneWidget);
    });

    testWidgets('Confirm logout', (WidgetTester tester) async {
      await tapOnScreen(tester, const Key('btn-log-out'));
      await openAndClose(tester, LogoutPopup, const Key('btn-logout-conf'));
      expect(find.byType(Login), findsOneWidget);
    });
  });

  group('Popups functionality', () {
    testWidgets('Decline exit', (WidgetTester tester) async {
      await tapOnScreen(tester, const Key('btn-quit'));
      await openAndClose(tester, ExitPopup, const Key('btn-quit-decl'));
      expect(find.byType(Home), findsOneWidget);
    });
  });
}
