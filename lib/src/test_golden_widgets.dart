import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart' show isTest;
import 'package:zoloto/src/zoloto.dart';

/// Registers a golden test that wraps Flutter's [testWidgets].
///
/// Sets [debugDisableShadows] based on [ZolotoConfig.enableRealShadows] and
/// restores it after the test body. Tags default to [ZolotoConfig.tags].
@isTest
void testGoldenWidgets(
  String description,
  Future<void> Function(WidgetTester) test, {
  bool? skip,
  Object? tags,
}) {
  final config = Zoloto.configuration;
  testWidgets(
    description,
    (tester) async {
      final previousDisableShadows = debugDisableShadows;
      debugDisableShadows = !config.enableRealShadows;

      // Set up comparator per-test so basedir matches the test file's
      // directory. This ensures golden files are resolved relative to
      // the test file, not the root test/ folder.
      final previousComparator = goldenFileComparator;
      if (previousComparator is LocalFileComparator) {
        goldenFileComparator = config.comparatorFactory(previousComparator.basedir);
      }

      try {
        await runZoned(
          () => test(tester),
          zoneValues: {
            #zoloto.config: config,
            #zoloto.inGoldenTest: true,
          },
        );
      } finally {
        debugDisableShadows = previousDisableShadows;
        goldenFileComparator = previousComparator;
      }
    },
    skip: skip,
    tags: tags ?? config.tags,
  );
}
