import 'dart:async';

import 'package:zoloto/src/font_loader.dart';
import 'package:zoloto/src/zoloto_config.dart';

class Zoloto {
  Zoloto._();

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
