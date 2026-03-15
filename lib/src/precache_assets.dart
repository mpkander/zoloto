import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Walks the widget tree and precaches all images before a golden screenshot.
///
/// Finds [Image] widgets and [DecoratedBox] with [BoxDecoration.image],
/// then calls [precacheImage] for each inside [WidgetTester.runAsync]
/// (required because the test binding's fake async zone won't resolve
/// real image futures during `pump`/`pumpAndSettle`).
Future<void> defaultPrecacheAssets(WidgetTester tester) async {
  final imageElements = find.byType(Image, skipOffstage: false).evaluate();
  final containerElements =
      find.byType(DecoratedBox, skipOffstage: false).evaluate();
  await tester.runAsync(() async {
    for (final imageElement in imageElements) {
      final widget = imageElement.widget;
      if (widget is Image) {
        await precacheImage(widget.image, imageElement);
      }
    }
    for (final container in containerElements) {
      final widget = container.widget as DecoratedBox;
      final decoration = widget.decoration;
      if (decoration is BoxDecoration) {
        if (decoration.image != null) {
          await precacheImage(decoration.image!.image, container);
        }
      }
    }
  });
}
