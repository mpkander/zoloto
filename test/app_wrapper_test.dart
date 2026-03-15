import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoloto/zoloto.dart';

void main() {
  group('defaultAppWrapper', () {
    testWidgets('AC-9.1.1: default wrapping — MaterialApp with no hardcoded platform',
        (tester) async {
      final wrapper = defaultAppWrapper();
      await tester.pumpWidget(wrapper(const Text('hello')));
      expect(find.byType(MaterialApp), findsOneWidget);
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      // Platform should not be explicitly overridden — ThemeData uses
      // defaultTargetPlatform which respects debugDefaultTargetPlatformOverride.
      expect(app.theme?.platform, defaultTargetPlatform);
    });

    testWidgets('AC-9.1.2: custom theme', (tester) async {
      final customTheme = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      );
      final wrapper = defaultAppWrapper(theme: customTheme);
      await tester.pumpWidget(wrapper(const Text('hello')));
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(
        app.theme?.colorScheme.primary,
        customTheme.colorScheme.primary,
      );
    });

    testWidgets('AC-9.1.3: custom localizations and locales', (tester) async {
      final wrapper = defaultAppWrapper(
        localeOverrides: [const Locale('en', 'US')],
      );
      await tester.pumpWidget(wrapper(const Text('hello')));
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.supportedLocales, contains(const Locale('en', 'US')));
    });

    testWidgets('AC-9.1.4: platform follows debugDefaultTargetPlatformOverride',
        (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      final wrapper = defaultAppWrapper();
      await tester.pumpWidget(wrapper(const Text('hello')));
      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.theme?.platform, TargetPlatform.iOS);
      debugDefaultTargetPlatformOverride = null;
    });

    test('AC-9.2.1: WidgetWrapper typedef compiles', () {
      // Verify typedef works — a function matching the signature compiles.
      WidgetWrapper fn(WidgetWrapper w) => w;
      expect(fn((child) => child)(const SizedBox()), isA<Widget>());
    });
  });
}
