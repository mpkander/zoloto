import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoloto/zoloto.dart';

void main() {
  group('TestEnvironment', () {
    group('Construction and defaults', () {
      test('AC-3.1.1: required params only — defaults applied', () {
        const tc = TestEnvironment(name: 'custom', size: Size(300, 500));
        expect(tc.pixelRatio, 1.0);
        expect(tc.textScale, 1.0);
        expect(tc.safeArea, EdgeInsets.zero);
        expect(tc.brightness, Brightness.light);
        expect(tc.platform, TargetPlatform.android);
        expect(tc.surfaceDecoration, isNull);
        expect(tc.surfacePadding, isNull);
        expect(tc.autoHeight, isFalse);
      });

      test('AC-3.1.2: all params specified — reflect exactly', () {
        const tc = TestEnvironment(
          name: 'full',
          size: Size(400, 800),
          pixelRatio: 2.0,
          textScale: 1.5,
          safeArea: EdgeInsets.only(top: 44),
          brightness: Brightness.dark,
          platform: TargetPlatform.iOS,
          surfaceDecoration: BoxDecoration(color: Colors.white),
          surfacePadding: EdgeInsets.all(16),
          autoHeight: true,
        );
        expect(tc.name, 'full');
        expect(tc.size, const Size(400, 800));
        expect(tc.pixelRatio, 2.0);
        expect(tc.textScale, 1.5);
        expect(tc.safeArea, const EdgeInsets.only(top: 44));
        expect(tc.brightness, Brightness.dark);
        expect(tc.platform, TargetPlatform.iOS);
        expect(
          tc.surfaceDecoration,
          const BoxDecoration(color: Colors.white),
        );
        expect(tc.surfacePadding, const EdgeInsets.all(16));
        expect(tc.autoHeight, isTrue);
      });
    });

    group('Preset test cases', () {
      test('TestEnvironments.iphone13Mini', () {
        const tc = TestEnvironments.iphone13Mini;
        expect(tc.name, 'iphone_13_mini');
        expect(tc.size, const Size(375, 812));
        expect(tc.pixelRatio, 3.0);
        expect(tc.platform, TargetPlatform.iOS);
        expect(tc.safeArea, const EdgeInsets.only(top: 47, bottom: 34));
        expect(tc.brightness, Brightness.light);
      });

      test('TestEnvironments.iphone13MiniDark', () {
        const tc = TestEnvironments.iphone13MiniDark;
        expect(tc.name, 'iphone_13_mini_dark');
        expect(tc.size, const Size(375, 812));
        expect(tc.pixelRatio, 3.0);
        expect(tc.platform, TargetPlatform.iOS);
        expect(tc.safeArea, const EdgeInsets.only(top: 47, bottom: 34));
        expect(tc.brightness, Brightness.dark);
      });

      test('TestEnvironments.iphone17ProMax', () {
        const tc = TestEnvironments.iphone17ProMax;
        expect(tc.name, 'iphone_17_pro_max');
        expect(tc.size, const Size(440, 956));
        expect(tc.pixelRatio, 3.0);
        expect(tc.platform, TargetPlatform.iOS);
        expect(tc.safeArea, const EdgeInsets.only(top: 59, bottom: 34));
        expect(tc.brightness, Brightness.light);
      });

      test('TestEnvironments.iphoneSE3', () {
        const tc = TestEnvironments.iphoneSE3;
        expect(tc.name, 'iphone_se_3');
        expect(tc.size, const Size(375, 667));
        expect(tc.pixelRatio, 2.0);
        expect(tc.platform, TargetPlatform.iOS);
        expect(tc.safeArea, const EdgeInsets.only(top: 20));
        expect(tc.brightness, Brightness.light);
      });

      test('TestEnvironments.pixel9Pro', () {
        const tc = TestEnvironments.pixel9Pro;
        expect(tc.name, 'pixel_9_pro');
        expect(tc.size, const Size(412, 919));
        expect(tc.pixelRatio, 3.0);
        expect(tc.platform, TargetPlatform.android);
        expect(tc.safeArea, const EdgeInsets.only(top: 24, bottom: 16));
      });
    });

    group('copyWith', () {
      test('AC-3.3.1: partial override preserves other properties', () {
        final result =
            TestEnvironments.iphone13Mini.copyWith(brightness: Brightness.dark);
        expect(result.brightness, Brightness.dark);
        expect(result.name, 'iphone_13_mini');
        expect(result.size, const Size(375, 812));
        expect(result.pixelRatio, 3.0);
        expect(result.textScale, 1.0);
        expect(result.safeArea, const EdgeInsets.only(top: 47, bottom: 34));
        expect(result.platform, TargetPlatform.iOS);
        expect(result.surfaceDecoration, isNull);
        expect(result.surfacePadding, isNull);
        expect(result.autoHeight, isFalse);
      });

      test('AC-3.3.2: name override', () {
        final result = TestEnvironments.iphone13Mini.copyWith(name: 'custom');
        expect(result.name, 'custom');
      });

      test('copyWith supports autoHeight', () {
        final result = TestEnvironments.iphone13Mini.copyWith(autoHeight: true);
        expect(result.autoHeight, isTrue);
      });
    });

    group('toString', () {
      test('AC-3.5.1: contains name and size', () {
        final str = TestEnvironments.iphone13Mini.toString();
        expect(str, contains('iphone_13_mini'));
        expect(str, contains('375'));
        expect(str, contains('812'));
      });
    });
  });
}
