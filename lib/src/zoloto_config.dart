import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoloto/src/default_app_wrapper.dart';
import 'package:zoloto/src/precache_assets.dart';
import 'package:zoloto/src/test_environment.dart';
import 'package:zoloto/src/zoloto_file_comparator.dart';

/// Factory that creates a [LocalFileComparator] for the given [testFile] URI.
typedef ComparatorFactory = LocalFileComparator Function(Uri testFile);

/// Factory that produces a [WidgetWrapper] (e.g. a [MaterialApp] shell)
/// used to wrap every widget under test.
typedef WidgetWrapperFactory = WidgetWrapper Function();

/// Converts a golden name and an optional [TestEnvironment] into a
/// relative file path (e.g. `'button.iphone_13_mini.png'`).
typedef TestPathFactory = String Function(
  String name,
  TestEnvironment? testEnv,
);

/// Returns `true` when golden assertions should be skipped
/// (e.g. on a CI host where rendering is non-deterministic).
typedef SkipGoldenAssertion = bool Function();

/// Called before each golden screenshot to ensure images are decoded.
typedef PrecacheAssets = Future<void> Function(WidgetTester tester);

/// Custom pump strategy passed to [expectMatchGolden] /
/// [expectMatchTestEnvironments] to replace the default `pumpAndSettle`.
typedef CustomPump = Future<void> Function(WidgetTester tester);

/// Default [TestPathFactory]: `'name.png'` or `'name.env.png'`.
String defaultTestPathFactory(String name, TestEnvironment? testEnv) {
  if (testEnv == null) return '$name.png';
  return '$name.${testEnv.name}.png';
}

/// Default [ComparatorFactory]: creates a [ZolotoFileComparator]
/// with zero tolerance.
LocalFileComparator defaultComparator(Uri testFile) {
  return ZolotoFileComparator(testFile);
}

/// Default [WidgetWrapperFactory]: calls [defaultAppWrapper]
/// with no customization.
WidgetWrapper defaultAppWrapperFactory() {
  return defaultAppWrapper();
}

/// Default [SkipGoldenAssertion]: always returns `false`
/// (assertions are never skipped).
bool defaultSkipGoldenAssertion() {
  return false;
}

/// Immutable configuration for the Zoloto golden-test framework.
///
/// Create via [ZolotoConfig.defaultSetup] — every parameter has a sensible
/// default, so you only override what you need:
///
/// ```dart
/// ZolotoConfig.defaultSetup(
///   enableRealShadows: false,
///   testEnvironments: [TestEnvironments.iphone13Mini, TestEnvironments.pixel9Pro],
/// )
/// ```
///
/// The config is zone-scoped: access it inside [Zoloto.setup] via
/// [Zoloto.configuration].
@immutable
class ZolotoConfig {
  /// Creates a [LocalFileComparator] used for golden-file diffing.
  final ComparatorFactory comparatorFactory;

  /// Produces the [WidgetWrapper] that wraps every widget under test
  /// (typically a [MaterialApp] shell).
  final WidgetWrapperFactory appWrapperFactory;

  /// Maps a human-readable name to a golden file path.
  ///
  /// Default: `'login_screen'` → `'login_screen.png'`.
  /// With test env: `('login_screen', iphone13Mini)` → `'login_screen.iphone_13_mini.png'`.
  final TestPathFactory testPathFactory;

  /// The folder name where golden files are stored, resolved relative to
  /// the test file's directory.
  ///
  /// Default: `'_goldens'`.
  final String goldenFolderName;

  /// Whether to load fonts from `FontManifest.json` during [Zoloto.setup].
  final bool shouldLoadFonts;

  /// Device profiles used by [expectMatchTestEnvironments].
  final List<TestEnvironment> testEnvironments;

  /// When `true`, shadows render realistically in golden images;
  /// when `false`, they are replaced with solid fills (faster, deterministic).
  final bool enableRealShadows;

  /// Return `true` to skip all golden assertions (useful on CI
  /// where host-specific rendering makes comparisons unreliable).
  final SkipGoldenAssertion skipGoldenAssertion;

  /// Tags applied to every [testGoldenWidgets] test.
  final Object? tags;

  /// Called before each golden screenshot to precache images.
  ///
  /// Override to customize asset loading (e.g. load network images via mocks).
  final PrecacheAssets precacheAssets;

  /// Creates a config where every parameter has a sensible default.
  ///
  /// Override only the parts you need:
  ///
  /// ```dart
  /// ZolotoConfig.defaultSetup(
  ///   enableRealShadows: false,
  ///   goldenFolderName: 'snapshots',
  /// )
  /// ```
  const ZolotoConfig.defaultSetup({
    this.comparatorFactory = defaultComparator,
    this.appWrapperFactory = defaultAppWrapperFactory,
    this.testPathFactory = defaultTestPathFactory,
    this.goldenFolderName = '_goldens',
    this.shouldLoadFonts = true,
    this.testEnvironments = const [TestEnvironments.iphone13Mini],
    this.enableRealShadows = true,
    this.skipGoldenAssertion = defaultSkipGoldenAssertion,
    this.tags = 'golden',
    this.precacheAssets = defaultPrecacheAssets,
  });

  /// Creates a config with all parameters required.
  ///
  /// Prefer [ZolotoConfig.defaultSetup] unless you need
  /// full control over every option.
  const ZolotoConfig({
    required this.comparatorFactory,
    required this.appWrapperFactory,
    required this.testPathFactory,
    required this.goldenFolderName,
    required this.shouldLoadFonts,
    required this.testEnvironments,
    required this.enableRealShadows,
    required this.skipGoldenAssertion,
    required this.tags,
    required this.precacheAssets,
  });
}
