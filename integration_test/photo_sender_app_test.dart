import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:photo_sender/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Photo Sender application end-to-end test', () {
    testWidgets(
        '\n\nTap shutter button to make photo '
        '\nTap Cancel button'
        '\nFinish test\n\n', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // print('Tap camera shutter button in 3 seconds');
      await Future.delayed(const Duration(seconds: 3));
      await tester.tap(find.byIcon(Icons.photo_camera));
      await tester.pumpAndSettle();

      // print('Wait image processing for 10 seconds');
      await Future.delayed(const Duration(seconds: 10));
      // render report detail
      await tester.pumpAndSettle();
      // render image
      await tester.pumpAndSettle();

      // print('Tap Cancel button in 3 seconds');
      await Future.delayed(const Duration(seconds: 3));
      expect(find.text('This is note to photo'), findsNothing);
      await tester.enterText(
        find.byKey(const ValueKey<String>('ReportDetailsTextFieldKey')),
        'This is note to photo',
      );
      await tester.pumpAndSettle();
      expect(find.text('This is note to photo'), findsOneWidget);
      await Future.delayed(const Duration(seconds: 3));
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // print('Finish test in 3 seconds');
      await Future.delayed(const Duration(seconds: 3));
    });
  });
}
