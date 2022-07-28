import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:quizzzy/src/service/fs_database.dart';

import 'firestore_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  FirebaseFunctions,
  CollectionReference,
  QuerySnapshot,
  DocumentReference,
  DocumentSnapshot,
  User
])
main() {
  late MockCollectionReference mockCollectionRef;
  late MockQuerySnapshot mockQuerySnapshot;
  late DocumentReference<Map<String, dynamic>> mockDocumentRef;
  late DocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockUser mockUser;
  late FirestoreService fs;
  late dynamic studentDict;

  setUp(() {
    mockFirebaseFirestore = MockFirebaseFirestore();
    mockCollectionRef = MockCollectionReference();
    mockDocumentRef = MockDocumentReference();
    mockQuerySnapshot = MockQuerySnapshot();
    mockDocumentSnapshot = MockDocumentSnapshot();
    mockUser = MockUser();

    when(mockFirebaseFirestore.collection('users'))
        .thenAnswer((_) => MockCollectionReference());

    fs = FirestoreService.test(
        mockUser, mockCollectionRef, MockFirebaseFunctions());
    studentDict = {
      'userType': 'Student',
      'isGenerated': false,
      'isWaiting': true
    };

    when(mockUser.uid).thenAnswer((_) => 'mock_user');
    when(mockCollectionRef.get())
        .thenAnswer((_) => Future.value(mockQuerySnapshot));
    when(mockDocumentSnapshot.exists).thenAnswer((_) => true);
    when(mockDocumentSnapshot.data()).thenAnswer((_) => studentDict);
    when(mockDocumentRef.get())
        .thenAnswer((_) => Future.value(mockDocumentSnapshot));
    when(mockCollectionRef.doc(any)).thenAnswer(((_) => (mockDocumentRef)));
  });

  group("User type check", () {
    test("Field name - 'userType'", () async {
      expect(await fs.getUserType(), 'Student');
    });

    test("Field name exeption", () async {
      when(mockDocumentSnapshot.exists).thenAnswer((_) => false);
      expect(await fs.getUserType(), 'None');
    });
  });

  group("Generated info check", () {
    test("Check question generated - 'isGenerated': True", () async {
      studentDict['isGenerated'] = true;
      expect(await fs.getGeneratorStatus(), 'Generated');
    });

    test("Check if still generating - 'isGenerated: False', 'isWaiting': True",
        () async {
      expect(await fs.getGeneratorStatus(), 'Waiting');
    });

    test("User didn't send req - 'isGenerated: False', 'isWaiting': False",
        () async {
      studentDict['isWaiting'] = false;
      expect(await fs.getGeneratorStatus(), 'None');
    });

    test("Generated status exeption", () async {
      when(mockDocumentSnapshot.exists).thenAnswer((_) => false);
      expect(await fs.getGeneratorStatus(), 'None');
    });
  });
}
