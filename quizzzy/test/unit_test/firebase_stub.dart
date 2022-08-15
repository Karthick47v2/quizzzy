import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quizzzy/service/firebase_auth.dart';
import 'package:quizzzy/service/firestore_db.dart';

import '../custom_mock/custom_mock.dart';
import 'firebase_stub.mocks.dart';

@GenerateMocks([
  User,
  UserCredential,
  FirebaseAuth,
  FirebaseFirestore,
  FirebaseFunctions,
  FirebaseMessaging,
  CollectionReference,
  QuerySnapshot,
  DocumentReference,
  DocumentSnapshot,
  HttpsCallable
])
const String questionnaireName1 = 'test_doc';
const String questionnaireName2 = 'test_doc2';

Map<String, dynamic> userResult = {'test_user': 0.5};

final Map<String, dynamic> quizInfo = {'quiz_1': userResult};

final Map<String, dynamic> questionnaireSub = {
  'all_ans': ['s', 'q', 'e', 't'],
  'crct_ans': 's',
  'question': 'q'
};

final Map<String, dynamic> studentDict = {
  'userType': 'Student',
  'GeneratorWorking': false,
  questionnaireName1: questionnaireSub,
  questionnaireName2: questionnaireSub,
  'quizID': quizInfo,
};

MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
MockUser mockUser = MockUser();
MockCollectionReference mockCollectionRef = MockCollectionReference();
MockCollectionReference<Map<String, dynamic>> mockSubCollectionRef =
    MockCollectionReference();
MockQuerySnapshot mockQuerySnapshot = MockQuerySnapshot();
MockQuerySnapshot<Map<String, dynamic>> mockSubQuerySnapshot =
    MockQuerySnapshot();
MockFirebaseFunctions mockFirebaseFunctions = MockFirebaseFunctions();
MockDocumentReference<Map<String, dynamic>> mockDocumentRef =
    MockDocumentReference();
MockDocumentReference<Map<String, dynamic>> mockSubDocumentRef =
    MockDocumentReference();
MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot =
    MockDocumentSnapshot();
MockDocumentSnapshot<Map<String, dynamic>> mockSubDocumentSnapshot =
    MockDocumentSnapshot();
QueryDocumentSnapshotMock<Map<String, dynamic>> queryDocumentSnapshotMock =
    QueryDocumentSnapshotMock.test(questionnaireSub, '0');
MockHttpsCallable mockHttpsCallable = MockHttpsCallable();

void initStubs() {
  when(mockFirebaseAuth.currentUser).thenAnswer((_) => mockUser);

  when(mockUser.uid).thenAnswer((_) => 'mock_uid');

  when(mockUser.displayName).thenAnswer((_) => 'mock_user');

  // first level
  when(mockDocumentSnapshot.exists).thenAnswer((_) => true);
  when(mockDocumentSnapshot.data()).thenAnswer((_) => studentDict);

  when(mockDocumentRef.get())
      .thenAnswer((_) => Future.value(mockDocumentSnapshot));

  when(mockCollectionRef.get())
      .thenAnswer((_) => Future.value(mockQuerySnapshot));

  when(mockCollectionRef.doc(any)).thenAnswer((_) => mockDocumentRef);

  // second level
  when(mockDocumentRef.collection(any))
      .thenAnswer((_) => (mockSubCollectionRef));

  when(mockSubDocumentSnapshot.exists).thenAnswer((_) => true);
  when(mockSubDocumentSnapshot.data()).thenAnswer((_) => questionnaireSub);

  when(mockSubDocumentRef.get())
      .thenAnswer((_) => Future.value(mockSubDocumentSnapshot));

  // when(queryDocumentSnapshotMock.)

  when(mockSubQuerySnapshot.docs)
      .thenAnswer((_) => [queryDocumentSnapshotMock]);

  when(mockSubCollectionRef.get())
      .thenAnswer((_) => Future.value(mockSubQuerySnapshot));

  when(mockSubCollectionRef.doc(any)).thenAnswer((_) => mockSubDocumentRef);

  ///
  Auth.test(mockFirebaseAuth);
  FirestoreService.test(mockUser, mockCollectionRef, mockFirebaseFunctions);
}
