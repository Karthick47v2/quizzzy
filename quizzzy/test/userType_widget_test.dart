// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quizzzy/src/userType.dart';

main() {
  testWidgets("user name input functionality", (WidgetTester tester) async {
    await tester.pumpWidget(UserType(firstTime: true));
    var txtBox = find.byType(TextField);
    expect(txtBox, findsOneWidget);
    await tester.enterText(txtBox, "mockuser");
    expect(find.text('mockuser'), findsOneWidget);
  });

  testWidgets("user type selection buttons", (WidgetTester tester) async {
    await tester.pumpWidget(UserType(firstTime: true));

    expect(find.text("I'm a Teacher"), findsOneWidget);
    expect(find.text("I'm a Student"), findsOneWidget);
  });
}
