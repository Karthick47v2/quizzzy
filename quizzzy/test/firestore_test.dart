// ignore_for_file: subtype_of_sealed_class, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:quizzzy/src/service/fs_database.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionRef extends Mock implements CollectionReference {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

class MockDocumentRef extends Mock implements DocumentReference {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

class MockUser extends Mock implements User {}

// TODO: ADD MORE UNIT TESTS

main() {
  late MockCollectionRef mockCollectionRef;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockDocumentRef mockDocumentRef;
  late MockDocumentSnapshot mockDocumentSnapshot;
  late MockUser mockUser;
  late FirestoreService fs;
  late dynamic studentDict;

  setUp(() {
    mockCollectionRef = MockCollectionRef();
    mockDocumentRef = MockDocumentRef();
    mockQuerySnapshot = MockQuerySnapshot();
    mockDocumentSnapshot = MockDocumentSnapshot();
    mockUser = MockUser();
    fs = FirestoreService(users: mockCollectionRef, user: mockUser);
    studentDict = {
      'userType': 'Student',
      'isGenerated': false,
      'isWaiting': true
    };

    when(mockCollectionRef.get())
        .thenAnswer((_) => Future.value(mockQuerySnapshot));
    when(mockDocumentSnapshot.exists).thenAnswer((_) => true);
    when(mockDocumentSnapshot.data()).thenAnswer((_) => studentDict);
    when(mockDocumentRef.get())
        .thenAnswer((_) => Future.value(mockDocumentSnapshot));
    when(fs.users.doc(any)).thenAnswer(((_) => (mockDocumentRef)));
  });

  group("User type check", () {
    test("Field name - 'userType'", () async {
      expect(await fs.getUserType(), 'Student');
    });

    test("Field name exeption", () async {
      when(mockDocumentSnapshot.exists).thenAnswer((_) => false);
      expect(await fs.getUserType(), null);
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
      expect(await fs.getGeneratorStatus(), null);
    });
  });
}
