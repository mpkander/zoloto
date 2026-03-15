import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:zoloto/src/zoloto.dart';
import 'package:zoloto/src/zoloto_config.dart';

/// Captures a golden screenshot of the first widget in the tree.
///
/// Must be called inside [testGoldenWidgets]. Uses the config's
/// [ZolotoConfig.testPathFactory] and [ZolotoConfig.goldenFolderName]
/// to derive the golden file path and calls [ZolotoConfig.precacheAssets]
/// before the screenshot.
Future<void> expectMatchGolden(
  WidgetTester tester,
  String name, {
  CustomPump? customPump,
}) async {
  _guardContext('expectMatchGolden');
  final config = Zoloto.configuration;

  await config.precacheAssets(tester);
  await (customPump ?? (t) => t.pumpAndSettle())(tester);

  final finder = find.byWidgetPredicate((w) => true).first;
  final fileName = config.testPathFactory(name, null);
  final path = '${config.goldenFolderName}/$fileName';

  if (!config.skipGoldenAssertion()) {
    await expectLater(finder, matchesGoldenFile(path));
  }
}

void _guardContext(String functionName) {
  final inGoldenTest = Zone.current[#zoloto.inGoldenTest];
  if (inGoldenTest != true) {
    throw StateError(
      '$functionName must be called inside testGoldenWidgets.',
    );
  }
}
