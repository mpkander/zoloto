import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoloto/zoloto.dart';

void main() {
  group('ZolotoConfig', () {
    group('Default values (AC-1.1.1)', () {
      test('shouldLoadFonts defaults to true', () {
        const config = ZolotoConfig.defaultSetup();
        expect(config.shouldLoadFonts, isTrue);
      });

      test('enableRealShadows defaults to true', () {
        const config = ZolotoConfig.defaultSetup();
        expect(config.enableRealShadows, isTrue);
      });

      test('tags defaults to golden', () {
        const config = ZolotoConfig.defaultSetup();
        expect(config.tags, 'golden');
      });

      test('testEnvironments defaults to [TestEnvironments.iphone13Mini]', () {
        const config = ZolotoConfig.defaultSetup();
        expect(config.testEnvironments, [TestEnvironments.iphone13Mini]);
      });

      test('skipGoldenAssertion defaults to returning false', () {
        const config = ZolotoConfig.defaultSetup();
        expect(config.skipGoldenAssertion(), isFalse);
      });
    });

    test('AC-1.1.2: default goldenFolderName is _goldens', () {
      const config = ZolotoConfig.defaultSetup();
      expect(config.goldenFolderName, '_goldens');
    });

    test('AC-1.1.3: default testPathFactory produces name.png without env',
        () {
      const config = ZolotoConfig.defaultSetup();
      expect(config.testPathFactory('login_screen', null), 'login_screen.png');
    });

    test(
        'AC-1.1.3b: default testPathFactory produces name.env.png with env',
        () {
      const config = ZolotoConfig.defaultSetup();
      expect(
        config.testPathFactory('login_screen', TestEnvironments.iphone13Mini),
        'login_screen.iphone_13_mini.png',
      );
    });

    testWidgets('AC-1.1.4: default appWrapperFactory wraps in MaterialApp',
        (tester) async {
      const config = ZolotoConfig.defaultSetup();
      final wrapper = config.appWrapperFactory();
      await tester.pumpWidget(wrapper(const Text('hello')));
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('hello'), findsOneWidget);
    });

    test('AC-1.1.5: default comparatorFactory returns ZolotoFileComparator',
        () {
      const config = ZolotoConfig.defaultSetup();
      final comparator = config.comparatorFactory(Uri.parse('file:///test.dart'));
      expect(comparator, isA<ZolotoFileComparator>());
    });

    group('Custom overrides', () {
      test('AC-1.2.1: custom testPathFactory', () {
        final config = ZolotoConfig.defaultSetup(
          testPathFactory: (name, testEnv) => '$name.golden.png',
        );
        expect(
          config.testPathFactory('my_widget', null),
          'my_widget.golden.png',
        );
      });

      testWidgets('AC-1.2.2: custom appWrapperFactory', (tester) async {
        final customTheme = ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        );
        final config = ZolotoConfig.defaultSetup(
          appWrapperFactory: () => defaultAppWrapper(theme: customTheme),
        );
        final wrapper = config.appWrapperFactory();
        await tester.pumpWidget(wrapper(const Text('hello')));
        final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
        expect(app.theme?.colorScheme.primary, customTheme.colorScheme.primary);
      });

      test('AC-1.2.3: custom testCases', () {
        const config = ZolotoConfig.defaultSetup(
          testEnvironments: [TestEnvironments.iphone13Mini, TestEnvironments.pixel9Pro],
        );
        expect(config.testEnvironments, hasLength(2));
      });

      test('AC-1.2.4: custom skipGoldenAssertion', () {
        final config = ZolotoConfig.defaultSetup(
          skipGoldenAssertion: () => true,
        );
        expect(config.skipGoldenAssertion(), isTrue);
      });
    });

    group('Zone-scoped access', () {
      test('AC-1.3.1: config accessible inside Zoloto.setup zone', () async {
        const config = ZolotoConfig.defaultSetup();
        late ZolotoConfig captured;
        await Zoloto.setup(
          config: config,
          testMain: () {
            captured = Zoloto.configuration;
          },
        );
        expect(identical(captured, config), isTrue);
      });

      test('AC-1.3.2: config not accessible outside zone', () {
        expect(
          () => Zoloto.configuration,
          throwsA(isA<StateError>()),
        );
      });
    });
  });
}
