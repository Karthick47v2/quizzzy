import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quizzzy/service/firestore_db.dart';

import 'auth_test.mocks.dart';
import 'firestore_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  FirebaseFunctions,
  CollectionReference,
  QuerySnapshot,
  DocumentReference,
  DocumentSnapshot,
])
main() {
  late MockCollectionReference mockCollectionRef;
  late MockCollectionReference<Map<String, dynamic>> mockSubCollectionRef;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockQuerySnapshot<Map<String, dynamic>> mocksubQuerySnapshot;
  late MockFirebaseFunctions mockFirebaseFunctions;
  late DocumentReference<Map<String, dynamic>> mockDocumentRef;
  late DocumentReference<Map<String, dynamic>> mockSubDocumentRef;
  late DocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;
  late DocumentSnapshot<Map<String, dynamic>> mockSubDocumentSnapshot;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockUser mockUser;
  late FirestoreService fs;
  late Map<String, dynamic> studentDict;
  late Map<String, dynamic> quizInfo;
  late Map<String, dynamic> questionnaireSub;
  late String questionnaireName;

  setUp(() {
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockCollectionRef = MockCollectionReference();
    mockSubCollectionRef = MockCollectionReference();
    mockFirebaseFunctions = MockFirebaseFunctions();
    mockDocumentRef = MockDocumentReference();
    mockSubDocumentRef = MockDocumentReference();
    mockQuerySnapshot = MockQuerySnapshot();
    mocksubQuerySnapshot = MockQuerySnapshot();
    mockDocumentSnapshot = MockDocumentSnapshot();
    mockSubDocumentSnapshot = MockDocumentSnapshot();
    mockUser = MockUser();

    when(mockFirebaseFirestore.collection('users'))
        .thenAnswer((_) => MockCollectionReference());

    fs = FirestoreService.test(
        mockUser, mockCollectionRef, mockFirebaseFunctions);

    questionnaireName = 'test_doc';

    quizInfo = {
      'test_user': 0.5,
    };

    questionnaireSub = {
      '0': null,
    };

    studentDict = {
      'userType': 'Student',
      'GeneratorWorking': false,
      questionnaireName: null,
      'quizID': quizInfo,
    };

    when(mockUser.uid).thenAnswer((_) => 'mock_user');

    when(mockCollectionRef.get())
        .thenAnswer((_) => Future.value(mockQuerySnapshot));
    when(mockDocumentSnapshot.exists).thenAnswer((_) => true);
    when(mockDocumentSnapshot.data()).thenAnswer((_) => studentDict);
    when(mockDocumentRef.get())
        .thenAnswer((_) => Future.value(mockDocumentSnapshot));
    when(mockCollectionRef.doc(any)).thenAnswer((_) => mockDocumentRef);

    when(mockDocumentRef.collection(questionnaireName))
        .thenAnswer((_) => (mockSubCollectionRef));
    when(mockSubCollectionRef.get())
        .thenAnswer((_) => Future.value(mocksubQuerySnapshot));

    when(mockSubDocumentSnapshot.exists).thenAnswer((_) => true);
    when(mockSubDocumentSnapshot.data()).thenAnswer((_) => questionnaireSub);
    when(mockSubDocumentRef.get())
        .thenAnswer((_) => Future.value(mockSubDocumentSnapshot));

    when(mockSubCollectionRef.doc(any)).thenAnswer((_) => mockSubDocumentRef);
  });

  group("User info check", () {
    test("Field name - 'userType'", () async {
      expect(await fs.getUserType(), 'Student');
    });

    test("Field name exeption", () async {
      when(mockDocumentSnapshot.exists).thenAnswer((_) => false);
      expect(await fs.getUserType(), 'None');
    });
  });

  group("Generated info check", () {
    test("Check initial Generator status", () async {
      expect(await fs.getGeneratorStatus(), false);
    });

    test("Check doc exists", () async {
      expect((await fs.getUserDoc(questionnaireName))!.exists, true);
    });
  });

  group("Chekc quiz info", () {
    test("Check generated question", () async {
      expect(await fs.getQuizInfo(), quizInfo);
    });
  });
}
