import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoloto/zoloto.dart';

/// Helper to run test body inside both zoloto config and golden test zones.
Future<void> _runInZolotoZone(
  WidgetTester tester,
  ZolotoConfig config,
  Future<void> Function() body,
) {
  return runZoned(
    () => runZoned(body, zoneValues: {#zoloto.inGoldenTest: true}),
    zoneValues: {#zoloto.config: config},
  );
}

void main() {
  group('expectMatchTestEnvironments', () {
    testWidgets('AC-4.2.1: generates golden per test case', (tester) async {
      final generatedPaths = <String>[];
      final config = ZolotoConfig.defaultSetup(
        shouldLoadFonts: false,
        skipGoldenAssertion: () => true,
        testEnvironments: const [TestEnvironments.iphone13Mini, TestEnvironments.pixel9Pro],
        goldenFolderName: 'goldens',
        testPathFactory: (name, tc) {
          final path = '$name.${tc!.name}.png';
          generatedPaths.add(path);
          return path;
        },
      );
      await _runInZolotoZone(tester, config, () async {
        await expectMatchTestEnvironments(
          'profile',
          tester: tester,
          widget: const Text('hello'),
        );
        expect(generatedPaths, [
          'profile.iphone_13_mini.png',
          'profile.pixel_9_pro.png',
        ]);
      });
    });

    testWidgets('AC-4.2.2: custom testCases parameter overrides config',
        (tester) async {
      final generatedPaths = <String>[];
      final config = ZolotoConfig.defaultSetup(
        shouldLoadFonts: false,
        skipGoldenAssertion: () => true,
        testEnvironments: const [TestEnvironments.iphone13Mini, TestEnvironments.pixel9Pro],
        goldenFolderName: 'goldens',
        testPathFactory: (name, tc) {
          final path = '$name.${tc!.name}.png';
          generatedPaths.add(path);
          return path;
        },
      );
      await _runInZolotoZone(tester, config, () async {
        await expectMatchTestEnvironments(
          'profile',
          tester: tester,
          widget: const Text('hello'),
          testEnvironments: const [TestEnvironments.iphone17ProMax],
        );
        expect(generatedPaths, ['profile.iphone_17_pro_max.png']);
      });
    });

    testWidgets('AC-4.2.3: filter predicate applied', (tester) async {
      final generatedPaths = <String>[];
      final config = ZolotoConfig.defaultSetup(
        shouldLoadFonts: false,
        skipGoldenAssertion: () => true,
        testEnvironments: const [TestEnvironments.iphone13Mini, TestEnvironments.pixel9Pro],
        goldenFolderName: 'goldens',
        testPathFactory: (name, tc) {
          final path = '$name.${tc!.name}.png';
          generatedPaths.add(path);
          return path;
        },
      );
      await _runInZolotoZone(tester, config, () async {
        await expectMatchTestEnvironments(
          'profile',
          tester: tester,
          widget: const Text('hello'),
          filter: (tc) => tc.name == 'iphone_13_mini',
        );
        expect(generatedPaths, ['profile.iphone_13_mini.png']);
      });
    });

    testWidgets('AC-4.2.4: environment parameters set per test case',
        (tester) async {
      TargetPlatform? capturedPlatform;
      final config = ZolotoConfig.defaultSetup(
        shouldLoadFonts: false,
        skipGoldenAssertion: () => true,
      );
      await _runInZolotoZone(tester, config, () async {
        final tc = TestEnvironments.pixel9Pro.copyWith(
          platform: TargetPlatform.iOS,
        );
        await expectMatchTestEnvironments(
          'env_test',
          tester: tester,
          widget: const Text('hello'),
          testEnvironments: [tc],
          customPump: (t) async {
            capturedPlatform = debugDefaultTargetPlatformOverride;
            await t.pump();
          },
        );
        expect(capturedPlatform, TargetPlatform.iOS);
      });
    });

    testWidgets('AC-4.2.5: environment restored after each test case',
        (tester) async {
      final config = ZolotoConfig.defaultSetup(
        shouldLoadFonts: false,
        skipGoldenAssertion: () => true,
      );
      await _runInZolotoZone(tester, config, () async {
        await expectMatchTestEnvironments(
          'restore_test',
          tester: tester,
          widget: const Text('hello'),
          testEnvironments: const [TestEnvironments.iphone13Mini],
        );
        expect(debugDefaultTargetPlatformOverride, isNull);
      });
    });

    testWidgets('AC-4.2.6: precacheAssets called per test case',
        (tester) async {
      var precacheCount = 0;
      final config = ZolotoConfig.defaultSetup(
        shouldLoadFonts: false,
        skipGoldenAssertion: () => true,
        testEnvironments: const [TestEnvironments.iphone13Mini, TestEnvironments.pixel9Pro],
        precacheAssets: (_) async {
          precacheCount++;
        },
      );
      await _runInZolotoZone(tester, config, () async {
        await expectMatchTestEnvironments(
          'precache_multi',
          tester: tester,
          widget: const Text('hello'),
        );
        expect(precacheCount, 2);
      });
    });

    testWidgets('AC-4.2.7: skip golden assertion', (tester) async {
      final config = ZolotoConfig.defaultSetup(
        shouldLoadFonts: false,
        skipGoldenAssertion: () => true,
        testEnvironments: const [TestEnvironments.iphone13Mini],
      );
      await _runInZolotoZone(tester, config, () async {
        await expectMatchTestEnvironments(
          'skipped',
          tester: tester,
          widget: const Text('hello'),
        );
      });
    });

    testWidgets('AC-4.2.8: throws outside testGoldenWidgets', (tester) async {
      final config = ZolotoConfig.defaultSetup(
        shouldLoadFonts: false,
        skipGoldenAssertion: () => true,
      );
      await runZoned(
        () async {
          // No #zoloto.inGoldenTest zone → guard should throw
          expect(
            () => expectMatchTestEnvironments(
              'test',
              tester: tester,
              widget: const Text('hello'),
            ),
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

    testWidgets('AC-4.2.10: empty test cases list → no error', (tester) async {
      final config = ZolotoConfig.defaultSetup(
        shouldLoadFonts: false,
        skipGoldenAssertion: () => true,
      );
      await _runInZolotoZone(tester, config, () async {
        await expectMatchTestEnvironments(
          'empty',
          tester: tester,
          widget: const Text('hello'),
          testEnvironments: const [],
        );
      });
    });

    testWidgets('AC-4.2.11: filter excludes all → no error', (tester) async {
      final config = ZolotoConfig.defaultSetup(
        shouldLoadFonts: false,
        skipGoldenAssertion: () => true,
        testEnvironments: const [TestEnvironments.iphone13Mini],
      );
      await _runInZolotoZone(tester, config, () async {
        await expectMatchTestEnvironments(
          'filtered',
          tester: tester,
          widget: const Text('hello'),
          filter: (_) => false,
        );
      });
    });
  });

  group('autoHeight edge cases', () {
    testWidgets(
        'AC-3.4.1: scrollable with finite extentAfter → surface expanded',
        (tester) async {
      final config = ZolotoConfig.defaultSetup(
        shouldLoadFonts: false,
        skipGoldenAssertion: () => true,
      );
      await _runInZolotoZone(tester, config, () async {
        final tc = TestEnvironments.iphone13Mini.copyWith(autoHeight: true);
        await expectMatchTestEnvironments(
          'scrollable_finite',
          tester: tester,
          widget: SizedBox(
            height: 640,
            width: 360,
            child: ListView(
              children: List.generate(
                50,
                (i) => SizedBox(height: 50, child: Text('Item $i')),
              ),
            ),
          ),
          testEnvironments: [tc],
        );
      });
    });

    testWidgets(
        'AC-3.4.2: no scrollable, render box < surface → surface shrinks',
        (tester) async {
      final config = ZolotoConfig.defaultSetup(
        shouldLoadFonts: false,
        skipGoldenAssertion: () => true,
      );
      await _runInZolotoZone(tester, config, () async {
        final tc = TestEnvironments.iphone13Mini.copyWith(autoHeight: true);
        await expectMatchTestEnvironments(
          'short_widget',
          tester: tester,
          widget: const SizedBox(height: 200, width: 360, child: Text('short')),
          testEnvironments: [tc],
        );
      });
    });

    testWidgets('AC-3.4.3: render box fills surface → no change',
        (tester) async {
      final config = ZolotoConfig.defaultSetup(
        shouldLoadFonts: false,
        skipGoldenAssertion: () => true,
      );
      await _runInZolotoZone(tester, config, () async {
        final tc = TestEnvironments.iphone13Mini.copyWith(autoHeight: true);
        await expectMatchTestEnvironments(
          'exact_fit',
          tester: tester,
          widget: const SizedBox(height: 640, width: 360, child: Text('exact')),
          testEnvironments: [tc],
        );
      });
    });

    testWidgets('AC-12.3.1: infinite extentAfter → no surface modification',
        (tester) async {
      final config = ZolotoConfig.defaultSetup(
        shouldLoadFonts: false,
        skipGoldenAssertion: () => true,
      );
      await _runInZolotoZone(tester, config, () async {
        final tc = TestEnvironments.iphone13Mini.copyWith(autoHeight: true);
        await expectMatchTestEnvironments(
          'infinite',
          tester: tester,
          widget: SizedBox(
            height: 640,
            width: 360,
            child: ListView.builder(
              itemBuilder: (_, i) =>
                  SizedBox(height: 50, child: Text('Item $i')),
            ),
          ),
          testEnvironments: [tc],
        );
      });
    });
  });
}
