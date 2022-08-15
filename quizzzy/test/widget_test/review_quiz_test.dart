import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:quizzzy/controllers/user_type_controller.dart';
import 'package:quizzzy/screens/home/home_page.dart';
import 'package:quizzzy/screens/review/student_review.dart';
import 'package:quizzzy/service/db_model/question_set.dart';

import '../unit_test/firebase_stub.dart';
import 'home_page_test.dart';

main() {
  setUp(() async {
    Get.testMode = true;
    initStubs();
    initHomeStubs();
    await initApp();

    localStorage.put('completedList', [questionnaireName1]);
    Get.find<UserTypeController>().setUserType('Student');
  });

  testWidgets('Display review  page elements', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: HomePage()));
    await tester.pump();
    await tester.tap(find.byKey(const Key('btn-review')));
    await tester.pumpAndSettle();

    await tester.tap(find.text(questionnaireName1));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('btn-quiz-start')));
    await tester.pumpAndSettle();

    expect(find.byType(StudentReview), findsOneWidget);

    expect(find.text('Review'), findsOneWidget);

    expect(find.text(questionnaireSub['crct_ans']), findsOneWidget);
  });
}
