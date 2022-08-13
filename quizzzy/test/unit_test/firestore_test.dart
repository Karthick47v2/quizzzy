import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quizzzy/service/firestore_db.dart';

import '../custom_mock/custom_mock.dart';
import 'firebase_stub.dart';

main() {
  setUp(() {
    initStubs();
  });

  group('Data binding', () {
    group("User info check", () {
      test("Field name - 'userType'", () async {
        expect(await FirestoreService().getUserType(), 'Student');
      });

      test("Field name exeption", () async {
        when(mockDocumentSnapshot.exists).thenAnswer((_) => false);
        expect(await FirestoreService().getUserType(), 'None');
      });
    });

    group("Generated info check", () {
      test("Initial generator status should be false", () async {
        expect(await FirestoreService().getGeneratorStatus(), false);
      });

      test("Check doc exists", () async {
        expect((await FirestoreService().getUserDoc(questionnaireName))!.exists,
            true);
      });
    });

    test("Check generated question", () async {
      expect(await FirestoreService().getQuizInfo(), quizInfo);
    });
  });

  group('Firebase query structure', () {
    test('Get questionnaire from current user account', () async {
      expect(await FirestoreService().getQuestionnaire(questionnaireName, ""),
          [queryDocumentSnapshotMock]);
    });
  });

  group('HttpsCallable function calls', () {
    group('user info', () {
      setUp(() {
        when(mockFirebaseFunctions.httpsCallable('storeUserInfo'))
            .thenAnswer((_) => mockHttpsCallable);
      });

      test('Save token to firestore', () async {
        when(mockHttpsCallable.call({'token': 'token'})).thenAnswer(
            (_) => Future.value(HttpsCallableResultMock.test({'status': 200})));

        expect(await FirestoreService().saveTokenToDatabase('token'), true);
      });

      test('Save user info to firestore', () async {
        when(mockHttpsCallable.call(any)).thenAnswer(
            (_) => Future.value(HttpsCallableResultMock.test({'status': 200})));

        expect(await FirestoreService().saveUser(true), true);
      });
    });

    test('Generate quiz instance in firestore', () async {
      when(mockFirebaseFunctions.httpsCallable('addQuiz'))
          .thenAnswer((_) => mockHttpsCallable);

      when(mockHttpsCallable.call(any)).thenAnswer(
          (_) => Future.value(HttpsCallableResultMock.test({'status': 200})));

      expect(await FirestoreService().generateQuiz('quizID'), true);
    });

    test('Send score to firestore', () async {
      when(mockFirebaseFunctions.httpsCallable('updateScore'))
          .thenAnswer((_) => mockHttpsCallable);

      when(mockHttpsCallable.call(any)).thenAnswer(
          (_) => Future.value(HttpsCallableResultMock.test({'status': 200})));

      expect(await FirestoreService().sendScore('quizID', 1, 'author'), true);
    });

    test('Delete questions from firestore', () async {
      when(mockFirebaseFunctions.httpsCallable('dltQuestions'))
          .thenAnswer((_) => mockHttpsCallable);

      when(mockHttpsCallable.call(any)).thenAnswer(
          (_) => Future.value(HttpsCallableResultMock.test({'status': 200})));

      expect(await FirestoreService().deleteQuestions('name', ['0']), true);
    });
  });
}
