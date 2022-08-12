import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:quizzzy/screens/home/user_details.dart';

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

  testWidgets('Display input details', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
      body: UserDetails(),
    )));

    expect(txtField, findsOneWidget);
    expect(btnTeacher, findsOneWidget);
    expect(btnStudent, findsOneWidget);
  });

  testWidgets('User input functionality', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
      body: UserDetails(),
    )));

    await tester.enterText(txtField, "test_user");

    expect(find.text('test_user'), findsOneWidget);
  });
}
///////////