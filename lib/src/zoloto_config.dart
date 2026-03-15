import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zoloto/src/default_app_wrapper.dart';
import 'package:zoloto/src/precache_assets.dart';
import 'package:zoloto/src/test_environment.dart';
import 'package:zoloto/src/zoloto_file_comparator.dart';

typedef ComparatorFactory = LocalFileComparator Function(Uri testFile);

typedef WidgetWrapperFactory = WidgetWrapper Function();

typedef TestPathFactory = String Function(
  String name,
  TestEnvironment? testEnv,
);

typedef SkipGoldenAssertion = bool Function();

/// Called before each golden screenshot to ensure images are decoded.
typedef PrecacheAssets = Future<void> Function(WidgetTester tester);

typedef CustomPump = Future<void> Function(WidgetTester tester);

String defaultTestPathFactory(String name, TestEnvironment? testEnv) {
  if (testEnv == null) return '$name.png';
  return '$name.${testEnv.name}.png';
}

LocalFileComparator defaultComparator(Uri testFile) {
  return ZolotoFileComparator(testFile);
}

WidgetWrapper defaultAppWrapperFactory() {
  return defaultAppWrapper();
}

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
  /// Override to customise asset loading (e.g. load network images via mocks).
  final PrecacheAssets precacheAssets;

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
