import 'package:flutter/material.dart';

/// A profile used to configure the test environment for golden
/// screenshots.
///
/// Each test environment describes a viewport: its [size], [pixelRatio],
/// [textScale], [brightness], [platform], [safeArea], and optional
/// [surfaceDecoration], and [surfacePadding]. Use [TestEnvironments] for
/// common presets, or create custom cases.
///
/// ```dart
/// const tablet = TestEnvironment(
///   name: 'tablet',
///   size: Size(1024, 768),
///   pixelRatio: 2.0,
/// );
/// ```
class TestEnvironment {
  const TestEnvironment({
    required this.size,
    this.pixelRatio = 1.0,
    required this.name,
    this.textScale = 1.0,
    this.safeArea = EdgeInsets.zero,
    this.brightness = Brightness.light,
    this.platform = TargetPlatform.android,
    this.surfaceDecoration,
    this.surfacePadding,
    this.autoHeight = false,
  });

  /// Identifier used in golden file names (e.g. `'phone'` → `widget.phone.png`).
  final String name;

  /// Logical size of the virtual viewport.
  final Size size;

  /// Device pixel ratio (e.g. `2.0` for Retina).
  final double pixelRatio;

  /// Text scale factor applied during the test.
  final double textScale;

  /// Simulated safe-area insets (notch, home indicator, etc.).
  final EdgeInsets safeArea;

  /// Platform brightness (`light` / `dark`).
  final Brightness brightness;

  /// Target platform reported to the widget tree.
  final TargetPlatform platform;

  /// Optional decoration applied to the outermost container wrapping the
  /// widget under test. When non-null, a [DecoratedBox] with this decoration
  /// is placed outside the app wrapper.
  final BoxDecoration? surfaceDecoration;

  /// Optional padding applied between the surface decoration and the widget
  /// under test. When non-null, a [Padding] widget is inserted inside the
  /// decoration but outside the app wrapper.
  final EdgeInsets? surfacePadding;

  /// When `true`, the surface height is adjusted to fit the content
  /// (expands for scrollable content, shrinks for short content).
  final bool autoHeight;

  TestEnvironment copyWith({
    Size? size,
    double? pixelRatio,
    String? name,
    double? textScale,
    EdgeInsets? safeArea,
    Brightness? brightness,
    TargetPlatform? platform,
    BoxDecoration? surfaceDecoration,
    EdgeInsets? surfacePadding,
    bool? autoHeight,
  }) {
    return TestEnvironment(
      size: size ?? this.size,
      pixelRatio: pixelRatio ?? this.pixelRatio,
      name: name ?? this.name,
      textScale: textScale ?? this.textScale,
      safeArea: safeArea ?? this.safeArea,
      brightness: brightness ?? this.brightness,
      platform: platform ?? this.platform,
      surfaceDecoration: surfaceDecoration ?? this.surfaceDecoration,
      surfacePadding: surfacePadding ?? this.surfacePadding,
      autoHeight: autoHeight ?? this.autoHeight,
    );
  }

  @override
  String toString() {
    return 'TestEnvironment: $name, ${size.width}x${size.height} @ $pixelRatio, textScale: $textScale, safeArea: $safeArea, platform: $platform';
  }
}

/// Built-in [TestEnvironment] presets for common device profiles.
class TestEnvironments {
  /// iPhone 13 Mini — 5.4" notch display, @3x.
  static const TestEnvironment iphone13Mini = TestEnvironment(
    name: 'iphone_13_mini',
    size: Size(375, 812),
    pixelRatio: 3.0,
    platform: TargetPlatform.iOS,
    safeArea: EdgeInsets.only(top: 47, bottom: 34),
  );

  /// iPhone 13 Mini in dark mode.
  static const TestEnvironment iphone13MiniDark = TestEnvironment(
    name: 'iphone_13_mini_dark',
    size: Size(375, 812),
    pixelRatio: 3.0,
    platform: TargetPlatform.iOS,
    safeArea: EdgeInsets.only(top: 47, bottom: 34),
    brightness: Brightness.dark,
  );

  /// iPhone 17 Pro Max — 6.9" Dynamic Island display, @3x.
  static const TestEnvironment iphone17ProMax = TestEnvironment(
    name: 'iphone_17_pro_max',
    size: Size(440, 956),
    pixelRatio: 3.0,
    platform: TargetPlatform.iOS,
    safeArea: EdgeInsets.only(top: 59, bottom: 34),
  );

  /// iPhone SE (3rd gen) — 4.7" LCD, Touch ID, @2x.
  static const TestEnvironment iphoneSE3 = TestEnvironment(
    name: 'iphone_se_3',
    size: Size(375, 667),
    pixelRatio: 2.0,
    platform: TargetPlatform.iOS,
    safeArea: EdgeInsets.only(top: 20),
  );

  /// Pixel 9 Pro — 6.3" punch-hole display, gesture navigation.
  static const TestEnvironment pixel9Pro = TestEnvironment(
    name: 'pixel_9_pro',
    size: Size(412, 919),
    pixelRatio: 3.0,
    safeArea: EdgeInsets.only(top: 24, bottom: 16),
  );
}
