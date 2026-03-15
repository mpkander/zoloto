import 'package:flutter/material.dart';

/// A function that wraps a widget (typically in a [MaterialApp] shell)
/// before it is pumped in a golden test.
typedef WidgetWrapper = Widget Function(Widget);

/// Creates a [MaterialApp] shell for golden tests.
///
/// The wrapper intentionally does **not** set `ThemeData.platform`.
/// Instead, `ThemeData()` reads [defaultTargetPlatform], which respects
/// [debugDefaultTargetPlatformOverride] set by [expectMatchTestEnvironments] for
/// each [TestEnvironment].
///
/// If you supply a custom [theme], avoid setting [ThemeData.platform]
/// explicitly — otherwise [TestEnvironment.platform] overrides won't apply.
///
/// To enable automatic dark/light theme switching via
/// [TestEnvironment.brightness], supply a [darkTheme]. Without it
/// [MaterialApp] always renders [theme], matching the common real-app
/// setup where only a single theme is provided.
WidgetWrapper defaultAppWrapper({
  Iterable<LocalizationsDelegate<dynamic>>? localizations,
  Iterable<Locale>? localeOverrides,
  ThemeData? theme,
  ThemeData? darkTheme,
}) {
  return (child) {
    return MaterialApp(
      localizationsDelegates: localizations,
      supportedLocales: localeOverrides ?? const [Locale('en')],
      theme: theme ?? ThemeData(),
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      home: Material(
        color: Colors.transparent,
        child: child,
      ),
    );
  };
}
