import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoloto/zoloto.dart';

void main() {
  group('expectMatchGolden', () {
    testWidgets('AC-4.1.1: file name from testPathFactory and goldenFolderName', (tester) async {
      String? capturedPath;
      final config = ZolotoConfig.defaultSetup(
        shouldLoadFonts: false,
        skipGoldenAssertion: () => true,
        goldenFolderName: 'goldens',
        testPathFactory: (name, testEnv) {
          capturedPath = '$name.png';
          return capturedPath!;
        },
      );
      await runZoned(
        () async {
          await runZoned(
            () async {
              await tester.pumpWidget(
                const MaterialApp(home: Text('hello')),
              );
              await expectMatchGolden(tester, 'login_screen');
              expect(capturedPath, 'login_screen.png');
            },
            zoneValues: {#zoloto.inGoldenTest: true},
          );
        },
        zoneValues: {#zoloto.config: config},
      );
    });

    testWidgets('AC-4.1.3: precacheAssets called before screenshot',
        (tester) async {
      var precacheCalled = false;
      final config = ZolotoConfig.defaultSetup(
        shouldLoadFonts: false,
        skipGoldenAssertion: () => true,
        precacheAssets: (_) async {
          precacheCalled = true;
        },
      );
      await runZoned(
        () async {
          await runZoned(
            () async {
              await tester.pumpWidget(
                const MaterialApp(home: Text('hello')),
              );
              await expectMatchGolden(tester, 'precache_test');
              expect(precacheCalled, isTrue);
            },
            zoneValues: {#zoloto.inGoldenTest: true},
          );
        },
        zoneValues: {#zoloto.config: config},
      );
    });

    testWidgets('AC-4.1.5: custom pump used when provided', (tester) async {
      var customPumpCalled = false;
      final config = ZolotoConfig.defaultSetup(
        shouldLoadFonts: false,
        skipGoldenAssertion: () => true,
      );
      await runZoned(
        () async {
          await runZoned(
            () async {
              await tester.pumpWidget(
                const MaterialApp(home: Text('hello')),
              );
              await expectMatchGolden(
                tester,
                'custom_pump',
                customPump: (t) async {
                  customPumpCalled = true;
                  await t.pump();
                },
              );
              expect(customPumpCalled, isTrue);
            },
            zoneValues: {#zoloto.inGoldenTest: true},
          );
        },
        zoneValues: {#zoloto.config: config},
      );
    });

    testWidgets(
        'AC-4.1.6: skip golden assertion when skipGoldenAssertion returns true',
        (tester) async {
      final config = ZolotoConfig.defaultSetup(
        shouldLoadFonts: false,
        skipGoldenAssertion: () => true,
      );
      await runZoned(
        () async {
          await runZoned(
            () async {
              await tester.pumpWidget(
                const MaterialApp(home: Text('hello')),
              );
              // Should complete without error — no golden file needed
              await expectMatchGolden(tester, 'skipped');
            },
            zoneValues: {#zoloto.inGoldenTest: true},
          );
        },
        zoneValues: {#zoloto.config: config},
      );
    });

    testWidgets('AC-4.1.7: throws outside testGoldenWidgets', (tester) async {
      final config = ZolotoConfig.defaultSetup(
        shouldLoadFonts: false,
        skipGoldenAssertion: () => true,
      );
      await runZoned(
        () async {
          // No #zoloto.inGoldenTest zone → guard should throw
          expect(
            () => expectMatchGolden(tester, 'test'),
            throwsA(
              isA<StateError>().having(
                (e) => e.message,
                'message',
                contains('testGoldenWidgets'),
              ),
            ),
          );
        },
        zoneValues: {#zoloto.config: config},
      );
    });
  });
}
