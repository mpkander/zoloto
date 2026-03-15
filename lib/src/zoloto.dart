import 'dart:async';

import 'package:zoloto/src/font_loader.dart';
import 'package:zoloto/src/zoloto_config.dart';

/// Entry point for the Zoloto golden-test framework.
///
/// Call [setup] from `flutter_test_config.dart` to configure the framework
/// globally. Access the active config anywhere via [configuration].
class Zoloto {
  Zoloto._();

  /// The [ZolotoConfig] for the current test zone.
  ///
  /// Throws [StateError] if accessed outside [setup].
  static ZolotoConfig get configuration {
    final config = Zone.current[#zoloto.config];
    if (config == null) {
      throw StateError(
        'Zoloto.configuration accessed outside Zoloto.setup(). '
        'Ensure your flutter_test_config.dart calls Zoloto.setup().',
      );
    }
    return config as ZolotoConfig;
  }

  /// Initializes Zoloto and runs [testMain] inside a zone that
  /// carries [config].
  ///
  /// Loads fonts automatically unless [ZolotoConfig.shouldLoadFonts]
  /// is `false`. Use [onSetup] for additional one-time initialization
  /// (e.g. registering image mocks).
  static Future<void> setup({
    required FutureOr<void> Function() testMain,
    required ZolotoConfig config,
    FutureOr<void> Function()? onSetup,
  }) {
    return runZoned(
      () async {
        if (config.shouldLoadFonts) {
          await loadFonts();
        }

        await onSetup?.call();
        await testMain();
      },
      zoneValues: {#zoloto.config: config},
    );
  }
}
