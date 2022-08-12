import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:quizzzy/screens/home/user_details.dart';
import 'package:quizzzy/service/firebase_auth.dart';
import 'package:quizzzy/service/firestore_db.dart';

import '../custom_mock/custom_mock.dart';
import '../unit_test/auth_test.mocks.dart';
import '../unit_test/firestore_test.mocks.dart';

main() {
  late Finder txtField;
  late Finder btnTeacher;
  late Finder btnStudent;
  setUp(() async {
    Get.testMode = true;

    txtField = find.byKey(const Key('text-input-name'));
    btnTeacher = find.byKey(const Key('button-teacher'));
    btnStudent = find.byKey(const Key('button-student'));
  });

  group('User experience', () {
    testWidgets('Display input details', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: UserDetails(),
      )));

      expect(txtField, findsOneWidget);
      expect(btnTeacher, findsOneWidget);
      expect(btnStudent, findsOneWidget);
    });
    testWidgets('Textbox interactivity', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
        body: UserDetails(),
      )));

      await tester.enterText(txtField, "test_user");

      expect(find.text('test_user'), findsOneWidget);
    });
  });

  group('Button interactivity', () {
    MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
    Auth.test(mockFirebaseAuth);

    MockCollectionReference mockCollectionRef = MockCollectionReference();
    MockFirebaseFunctions mockFirebaseFunctions = MockFirebaseFunctions();
    MockUser mockUser = MockUser();

    MockHttpsCallable mockHttpsCallable = MockHttpsCallable();
    FirestoreService.test(mockUser, mockCollectionRef, mockFirebaseFunctions);

    when(mockFirebaseAuth.currentUser).thenAnswer((_) => mockUser);
    when(mockFirebaseFunctions.httpsCallable(any))
        .thenAnswer((_) => mockHttpsCallable);
    testWidgets('Button interactivity - request failure',
        (WidgetTester tester) async {
      when(mockHttpsCallable.call(any)).thenAnswer(
          (_) => Future.value(HttpsCallableResultMock.test({'status': 400})));

      await tester.pumpWidget(const GetMaterialApp(
          home: Scaffold(
        body: UserDetails(),
      )));

      await tester.tap(btnStudent);
      await tester.pump();
      expect(find.text('Error'), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('Button interactivity - request successful',
        (WidgetTester tester) async {
      when(mockHttpsCallable.call(any)).thenAnswer(
          (_) => Future.value(HttpsCallableResultMock.test({'status': 200})));

      await tester.pumpWidget(const GetMaterialApp(
          home: Scaffold(
        body: UserDetails(),
      )));

      await tester.tap(btnStudent);
      await tester.pump();
      expect(find.text('Error'), findsNothing);
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });
  });
}
