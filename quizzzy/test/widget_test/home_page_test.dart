import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:quizzzy/service/db_model/question_set.dart';
import 'package:quizzzy/service/firestore_db.dart';

import '../unit_test/auth_test.mocks.dart';
import '../unit_test/firestore_test.mocks.dart';

main() {
  late MockCollectionReference mockCollectionRef;
  late MockQuerySnapshot mockQuerySnapshot;
  late MockFirebaseFunctions mockFirebaseFunctions;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentRef;
  late MockDocumentSnapshot<Map<String, dynamic>> mockDocumentSnapshot;
  late MockFirebaseFirestore mockFirebaseFirestore;
  late MockUser mockUser;
  late Map<String, dynamic> studentDict;

  setUp(() {
    Get.testMode = true;

    // IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    mockFirebaseFirestore = MockFirebaseFirestore();
    mockCollectionRef = MockCollectionReference();
    mockDocumentRef = MockDocumentReference();
    mockQuerySnapshot = MockQuerySnapshot();
    mockDocumentSnapshot = MockDocumentSnapshot();
    mockFirebaseFunctions = MockFirebaseFunctions();
    mockUser = MockUser();

    studentDict = {
      'userType': 'Student',
      'GeneratorWorking': false,
    };

    when(mockFirebaseFirestore.collection('users'))
        .thenAnswer((_) => MockCollectionReference());

    when(mockUser.uid).thenAnswer((_) => 'mock_uid');
    when(mockUser.displayName).thenAnswer((_) => 'mock_user');

    FirestoreService.test(mockUser, mockCollectionRef, mockFirebaseFunctions);

    when(mockCollectionRef.get())
        .thenAnswer((_) => Future.value(mockQuerySnapshot));
    when(mockDocumentSnapshot.exists).thenAnswer((_) => true);
    when(mockDocumentSnapshot.data()).thenAnswer((_) => studentDict);
    when(mockDocumentRef.get())
        .thenAnswer((_) => Future.value(mockDocumentSnapshot));
    when(mockCollectionRef.doc(any)).thenAnswer((_) => mockDocumentRef);

    when(setBox()).thenAnswer((_) => Future.value(MockBox()));
  });
  // testWidgets('Display teacher interface', (WidgetTester tester) async {
  //   await tester.pumpWidget(const GetMaterialApp(home: HomePage()));

  //   await tester.pump();

  //   // expect(find.byKey(const Key('button-attempt-quiz')), findsOneWidget);

  //   await tester.pumpAndSettle(const Duration(seconds: 1));
  // });
}
