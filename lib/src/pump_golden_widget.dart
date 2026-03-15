import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoloto/src/default_app_wrapper.dart';
import 'package:zoloto/src/zoloto.dart';

/// Wraps [widget] with [ZolotoConfig.appWrapperFactory] and pumps it.
///
/// This is the recommended way to set up a widget inside [testGoldenWidgets].
/// The wrapper (typically a [MaterialApp] shell) is taken from the config
/// automatically, so you don't need to manage it manually:
///
/// ```dart
/// testGoldenWidgets('login screen', (tester) async {
///   await pumpGoldenWidget(tester, const LoginScreen());
///   await expectMatchGolden(tester, 'login_screen');
/// });
/// ```
///
/// Pass a custom [wrapper] to override the config's factory for this call.
Future<void> pumpGoldenWidget(
  WidgetTester tester,
  Widget widget, {
  WidgetWrapper? wrapper,
}) async {
  final wrap = wrapper ?? Zoloto.configuration.appWrapperFactory();
  await tester.pumpWidget(wrap(widget));
}
