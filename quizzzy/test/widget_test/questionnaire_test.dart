// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:get/get.dart';

// import '../unit_test/firebase_stub.dart';
// import 'home_page_test.dart';

// main() {
//   setUp(() async {
//     Get.testMode = true;
//     initStubs();
//     initHomeStubs();
//     await initApp();
//   });

//   testWidgets('Display quiz page elements', (WidgetTester tester) async {
//     await tapOnWidget(tester);

//     await tester.tap(find.byKey(const Key('btn-quiz-start')));
//     await tester.pumpAndSettle();

//     expect(find.byType(StudentView), findsOneWidget);

//     expect(find.text(questionnaireSub['question']), findsOneWidget);
//   });

// }


