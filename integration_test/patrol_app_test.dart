import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'counter state is the same after going to home and switching apps',
    nativeAutomation: true,
    nativeAutomatorConfig: const NativeAutomatorConfig(
      packageName: 'com.example.photo_sender',
      bundleId: 'com.example.photo_sender',
    ),
    ($) async {
      // Replace later with your app's main widget
      await $.pumpWidgetAndSettle(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('app')),
            backgroundColor: Colors.blue,
          ),
        ),
        // const PhotoSender()
      );

      expect($('app'), findsOneWidget);
      await $.native.pressHome();
    },
  );
}
