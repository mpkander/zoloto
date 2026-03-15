import 'package:flutter_test/flutter_test.dart';
import 'package:zoloto/zoloto.dart';

void main() {
  group('Zoloto.setup()', () {
    test('AC-2.1.3: onSetup called before testMain', () async {
      var onSetupCalled = false;
      await Zoloto.setup(
        config: const ZolotoConfig.defaultSetup(shouldLoadFonts: false),
        onSetup: () {
          onSetupCalled = true;
        },
        testMain: () {
          expect(onSetupCalled, isTrue);
        },
      );
    });

    test('AC-2.1.4: full operation order', () async {
      final order = <String>[];

      await Zoloto.setup(
        config: ZolotoConfig.defaultSetup(
          shouldLoadFonts: false,
          comparatorFactory: (uri) {
            order.add('comparator');
            return ZolotoFileComparator(uri);
          },
        ),
        onSetup: () {
          order.add('onSetup');
        },
        testMain: () {
          order.add('testMain');
        },
      );

      expect(order, ['onSetup', 'testMain']);
    });

    test('AC-2.2.1: fonts not loaded when shouldLoadFonts: false', () async {
      // Should complete without error even when no FontManifest.json
      await Zoloto.setup(
        config: const ZolotoConfig.defaultSetup(shouldLoadFonts: false),
        testMain: () {},
      );
    });

    test('AC-12.2.1: Zoloto.configuration outside zone throws', () {
      expect(
        () => Zoloto.configuration,
        throwsA(isA<StateError>()),
      );
    });
  });
}
