import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quizzzy/service/firestore_db.dart';

import '../custom_mock/custom_mock.dart';
import 'auth_test.mocks.dart';
import 'firestore_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  FirebaseFunctions,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  HttpsCallable,
  HiveInterface,
  Box,
])
main() {
  late MockCollectionReference mockCollectionRef;
  late MockCollectionReference<Map<String, dynamic>> mockSubCollectionRef;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockQuerySnapshot<Map<String, dynamic>> mockSubQuerySnapshot;
  late MockFirebaseFunctions mockFirebaseFunctions;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentRef;
  late MockDocumentReference<Map<String, dynamic>> mockSubDocumentRef;
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;
  late MockDocumentSnapshot<Map<String, dynamic>> mockSubDocumentSnapshot;
  late QueryDocumentSnapshotMock<Map<String, dynamic>>
      queryDocumentSnapshotMock;
  late MockHttpsCallable mockHttpsCallable;
  late MockUser mockUser;

  const String questionnaireName = 'test_doc';

  final Map<String, dynamic> quizInfo = {
    'test_user': 0.5,
  };

  final Map<String, dynamic> studentDict = {
    'userType': 'Student',
    'GeneratorWorking': false,
    questionnaireName: null,
    'quizID': quizInfo,
  };

  final Map<String, dynamic> questionnaireSub = {
    '0': null,
  };

  setUp(() {
    mockCollectionRef = MockCollectionReference();
    mockSubCollectionRef = MockCollectionReference();
    mockFirebaseFunctions = MockFirebaseFunctions();
    mockDocumentRef = MockDocumentReference();
    mockSubDocumentRef = MockDocumentReference();
    mockQuerySnapshot = MockQuerySnapshot();
    mockSubQuerySnapshot = MockQuerySnapshot();
    mockDocumentSnapshot = MockDocumentSnapshot();
    mockSubDocumentSnapshot = MockDocumentSnapshot();
    queryDocumentSnapshotMock =
        QueryDocumentSnapshotMock.test(questionnaireSub);
    mockUser = MockUser();

    when(mockUser.uid).thenAnswer((_) => 'mock_uid');

    // first level
    when(mockDocumentSnapshot.exists).thenAnswer((_) => true);
    when(mockDocumentSnapshot.data()).thenAnswer((_) => studentDict);

    when(mockDocumentRef.get())
        .thenAnswer((_) => Future.value(mockDocumentSnapshot));

    when(mockCollectionRef.get())
        .thenAnswer((_) => Future.value(mockQuerySnapshot));

    when(mockCollectionRef.doc(any)).thenAnswer((_) => mockDocumentRef);

    // second level
    when(mockDocumentRef.collection(questionnaireName))
        .thenAnswer((_) => (mockSubCollectionRef));

    when(mockSubDocumentSnapshot.exists).thenAnswer((_) => true);
    when(mockSubDocumentSnapshot.data()).thenAnswer((_) => questionnaireSub);

    when(mockSubDocumentRef.get())
        .thenAnswer((_) => Future.value(mockSubDocumentSnapshot));

    when(mockSubQuerySnapshot.docs)
        .thenAnswer((_) => [queryDocumentSnapshotMock]);

    when(mockSubCollectionRef.get())
        .thenAnswer((_) => Future.value(mockSubQuerySnapshot));

    when(mockSubCollectionRef.doc(any)).thenAnswer((_) => mockSubDocumentRef);

    ///

    FirestoreService.test(mockUser, mockCollectionRef, mockFirebaseFunctions);

    mockHttpsCallable = MockHttpsCallable();
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
