import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoloto/src/default_app_wrapper.dart';
import 'package:zoloto/src/zoloto.dart';
import 'package:zoloto/src/zoloto_config.dart';
import 'package:zoloto/src/test_environment.dart';

/// Captures a golden screenshot per [TestEnvironment], applying each case's
/// environment (size, pixel ratio, text scale, brightness, platform,
/// safe area, background colour).
///
/// The [widget] is wrapped with [wrapper] (or the config's
/// [ZolotoConfig.appWrapperFactory]) and pumped **inside** the loop for each
/// test case. This ensures `ThemeData` is recreated with the correct
/// [defaultTargetPlatform] set by each case's [TestEnvironment.platform].
///
/// Must be called inside [testGoldenWidgets].
Future<void> expectMatchTestEnvironments(
  String name, {
  required WidgetTester tester,
  required Widget widget,
  WidgetWrapper? wrapper,
  bool Function(TestEnvironment)? filter,
  CustomPump? customPump,
  List<TestEnvironment>? testEnvironments,
}) async {
  _guardContext('expectMatchTestEnvironments');
  final config = Zoloto.configuration;

  var cases = testEnvironments ?? config.testEnvironments;
  if (filter != null) {
    cases = cases.where(filter).toList();
  }
  if (cases.isEmpty) return;

  for (final tc in cases) {
    await _applyTestEnvironment(tester, tc);

    // Create the wrapper INSIDE the loop so that ThemeData() is constructed
    // AFTER debugDefaultTargetPlatformOverride is set for this test case.
    // If the wrapper is created before the loop, ThemeData captures the
    // wrong defaultTargetPlatform.
    final wrap = wrapper ?? config.appWrapperFactory();

    // Pump the widget after environment is applied so that ThemeData()
    // picks up the correct defaultTargetPlatform for this test case.
    Widget pumpedWidget = wrap(widget);
    if (tc.surfacePadding case final padding?) {
      pumpedWidget = Padding(padding: padding, child: pumpedWidget);
    }
    if (tc.surfaceDecoration case final decoration?) {
      pumpedWidget = DecoratedBox(
        decoration: decoration,
        child: pumpedWidget,
      );
    }
    await tester.pumpWidget(pumpedWidget);

    if (tc.autoHeight) {
      await _applyAutoHeight(tester, tc);
    }

    // Rebuild widgets with the new environment (size, pixel ratio, etc.)
    // BEFORE precaching so that Image.asset resolves the correct
    // resolution variant for the target device pixel ratio.
    //
    // When [customPump] is provided, use a single pump() to avoid
    // pumpAndSettle() timing out on infinite animations (e.g. spinners).
    if (customPump != null) {
      await tester.pump();
    } else {
      await tester.pumpAndSettle();
    }
    await config.precacheAssets(tester);
    await (customPump ?? (t) => t.pumpAndSettle())(tester);

    final finder = find.byWidgetPredicate((w) => true).first;
    final fileName = config.testPathFactory(name, tc);
    final path = '${config.goldenFolderName}/$fileName';

    if (!config.skipGoldenAssertion()) {
      await expectLater(finder, matchesGoldenFile(path));
    }

    await _restoreTestEnvironment(tester);
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

Future<void> _applyTestEnvironment(
  WidgetTester tester,
  TestEnvironment tc,
) async {
  final physicalSize = Size(
    tc.size.width * tc.pixelRatio,
    tc.size.height * tc.pixelRatio,
  );
  tester.view.physicalSize = physicalSize;
  tester.view.devicePixelRatio = tc.pixelRatio;
  tester.platformDispatcher.textScaleFactorTestValue = tc.textScale;
  tester.platformDispatcher.platformBrightnessTestValue = tc.brightness;
  debugDefaultTargetPlatformOverride = tc.platform;

  if (tc.safeArea != EdgeInsets.zero) {
    final fakePadding = FakeViewPadding(
      left: tc.safeArea.left * tc.pixelRatio,
      top: tc.safeArea.top * tc.pixelRatio,
      right: tc.safeArea.right * tc.pixelRatio,
      bottom: tc.safeArea.bottom * tc.pixelRatio,
    );
    tester.view.padding = fakePadding;
    tester.view.viewPadding = fakePadding;
  }
}

Future<void> _restoreTestEnvironment(WidgetTester tester) async {
  tester.view.resetPhysicalSize();
  tester.view.resetDevicePixelRatio();
  tester.view.resetPadding();
  tester.view.resetViewPadding();
  tester.platformDispatcher.clearTextScaleFactorTestValue();
  tester.platformDispatcher.clearPlatformBrightnessTestValue();
  debugDefaultTargetPlatformOverride = null;
}

Future<void> _applyAutoHeight(WidgetTester tester, TestEnvironment tc) async {
  await tester.pumpAndSettle();

  final scrollableFinder = find.byWidgetPredicate(
    (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
  );

  if (scrollableFinder.evaluate().isNotEmpty) {
    final element = scrollableFinder.evaluate().first;
    final scrollableState =
        (element as StatefulElement).state as ScrollableState;
    final position = scrollableState.position;
    final extentAfter = position.extentAfter;

    if (extentAfter.isFinite) {
      final currentHeight = tc.size.height * tc.pixelRatio;
      final newHeight = currentHeight + (extentAfter * tc.pixelRatio);
      tester.view.physicalSize = Size(
        tc.size.width * tc.pixelRatio,
        newHeight,
      );
    }
    // If extentAfter is infinite → do not modify surface (AC-12.3.1)
  } else {
    // No scrollable found — find the first RenderBox in the tree
    final elements = find.byWidgetPredicate((w) => true).evaluate();
    RenderBox? renderBox;
    for (final element in elements) {
      if (element.renderObject is RenderBox) {
        renderBox = element.renderObject as RenderBox;
        break;
      }
    }
    if (renderBox != null) {
      final renderHeight = renderBox.size.height;
      if (renderHeight < tc.size.height) {
        tester.view.physicalSize = Size(
          tc.size.width * tc.pixelRatio,
          renderHeight * tc.pixelRatio,
        );
      }
      // If render box fills surface exactly → no change (AC-3.4.3)
    }
  }

  await tester.pumpAndSettle();
}
