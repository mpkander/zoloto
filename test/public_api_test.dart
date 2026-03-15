import 'package:flutter_test/flutter_test.dart';
import 'package:zoloto/zoloto.dart';

/// Verifies all public symbols are exported via the barrel file.
void main() {
  group('Public API barrel file', () {
    test('AC-11.1.1: all required symbols are exported', () {
      // Classes
      expect(Zoloto, isNotNull);
      expect(ZolotoConfig, isNotNull);
      expect(TestEnvironment, isNotNull);
      expect(TestEnvironments, isNotNull);
      expect(ZolotoFileComparator, isNotNull);

      // Top-level functions
      expect(testGoldenWidgets, isA<Function>());
      expect(expectMatchGolden, isA<Function>());
      expect(expectMatchTestEnvironments, isA<Function>());
      expect(pumpGoldenWidget, isA<Function>());
      expect(defaultAppWrapper, isA<Function>());
      expect(loadFonts, isA<Function>());
      expect(defaultPrecacheAssets, isA<Function>());

      // Typedefs compile — verified by using them.
      T id<T>(T v) => v;
      expect(id<WidgetWrapper>((child) => child), isNotNull);
      expect(id<CustomPump>((tester) async {}), isNotNull);
      expect(id<ComparatorFactory>(defaultComparator), isNotNull);
      expect(id<WidgetWrapperFactory>(defaultAppWrapperFactory), isNotNull);
      expect(id<TestPathFactory>(defaultTestPathFactory), isNotNull);
      expect(id<SkipGoldenAssertion>(defaultSkipGoldenAssertion), isNotNull);
      expect(id<PrecacheAssets>(defaultPrecacheAssets), isNotNull);
    });
  });
}
