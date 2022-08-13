import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:quizzzy/screens/landing/greeting.dart';
import 'package:mockito/mockito.dart';
import 'package:quizzzy/service/local_notification_service.dart';

import '../unit_test/firebase_stub.mocks.dart';


main() {
  setUp(() {
    Get.testMode = true;
  });
  testWidgets('Display nav', (WidgetTester tester) async {
    fm = MockFirebaseMessaging();
    when(fm.getInitialMessage())
        .thenAnswer((realInvocation) => Future.value(const RemoteMessage()));
    await tester.pumpWidget(const MaterialApp(home: Greetings()));

    expect(find.textContaining('Scroll up'), findsOneWidget);
  });
}
