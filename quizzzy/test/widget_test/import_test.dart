import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:quizzzy/screens/import/file_browser_popup.dart';
import 'package:quizzzy/screens/import/import.dart';

import '../unit_test/firebase_stub.dart';

main() {
  setUp(() async {
    Get.testMode = true;
    initStubs();
  });
  testWidgets('Show upload instructions', (WidgetTester tester) async {
    await tester.pumpWidget(const GetMaterialApp(home: ImportFile()));

    expect(find.textContaining("(PDF) to generate"), findsOneWidget);
  });

  group('upload popup', () {
    tapInkWell(WidgetTester tester) async {
      await tester.pumpWidget(const GetMaterialApp(home: ImportFile()));

      final btn = find.byKey(const Key('btn-upload'));

      await tester.ensureVisible(btn);
      await tester.tap(btn);
      await tester.pumpAndSettle();
    }

    fillName(WidgetTester tester) async {
      await tapInkWell(tester);
      await tester.enterText(find.byKey(const Key('input-q-name')), 'qname');

      expect(find.text('qname'), findsOneWidget);

      await tester.tap(find.byKey(const Key('btn-q-name-conf')));
      await tester.pump();
    }

    testWidgets('Display popup when upload image pressed',
        (WidgetTester tester) async {
      await tapInkWell(tester);
      expect(find.byType(FileBrowserPopup), findsOneWidget);
    });

    testWidgets('Throw warning if generator is already working',
        (WidgetTester tester) async {
      studentDict['GeneratorWorking'] = true;
      await fillName(tester);

      expect(find.textContaining('wait for previous document'), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });
  });
}
