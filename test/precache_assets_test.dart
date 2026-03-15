import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoloto/zoloto.dart';

void main() {
  group('defaultPrecacheAssets', () {
    testWidgets('AC-7.1.3: completes without error when no images present',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Text('no images')),
      );
      await defaultPrecacheAssets(tester);
    });

    testWidgets('AC-7.2.1: custom precacheAssets function used via config',
        (tester) async {
      var customCalled = false;
      final config = ZolotoConfig.defaultSetup(
        precacheAssets: (_) async {
          customCalled = true;
        },
      );
      expect(customCalled, isFalse);
      await config.precacheAssets(tester);
      expect(customCalled, isTrue);
    });
  });
}
