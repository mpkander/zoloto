import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Platform system fonts that must be registered under their canonical name
/// regardless of any `packages/` prefix in the manifest.
///
/// When a dependency bundles one of these fonts (e.g. `packages/my_pkg/Roboto`),
/// Flutter still renders text using the bare family name (`Roboto`). If we
/// registered it with the prefixed name, text using the default Material theme
/// would fall back to the Ahem font in tests (all squares). Stripping the
/// prefix ensures the font is found at render time.
const List<String> _overridableFonts = [
  'Roboto',
  '.SF UI Display',
  '.SF UI Text',
  '.SF Pro Text',
  '.SF Pro Display',
];

/// Returns all family names under which a font entry should be registered.
///
/// For overridable fonts from packages (e.g. `packages/rhino_ui/SF Pro Display`)
/// this returns both the bare name and the original manifest name, so the font
/// is found regardless of how it's referenced.
List<String> _derivedFontFamilies(Map<String, dynamic> fontDefinition) {
  final String fontFamily = fontDefinition['family'] as String;

  if (_overridableFonts.contains(fontFamily)) {
    return [fontFamily];
  }

  if (fontFamily.startsWith('packages/')) {
    final fontFamilyName = fontFamily.split('/').last;
    if (_overridableFonts.any((font) => font == fontFamilyName)) {
      // Register under both bare name and original manifest name.
      return [fontFamilyName, fontFamily];
    }
    return [fontFamily];
  }

  final fonts = fontDefinition['fonts'] as List<dynamic>;
  for (final Map<String, dynamic> fontType in fonts) {
    final String? asset = fontType['asset'] as String?;
    if (asset != null && asset.startsWith('packages')) {
      final packageName = asset.split('/')[1];
      return ['packages/$packageName/$fontFamily'];
    }
  }

  return [fontFamily];
}

/// Loads all fonts declared in FontManifest.json.
///
/// Handles packages/ prefix for bundled fonts (Roboto, SF, Cupertino).
/// Call this manually if you set `shouldLoadFonts: false` and want to
/// load fonts at a different time.
Future<void> loadFonts() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final fontManifest = await rootBundle.loadStructuredData<Iterable<dynamic>>(
    'FontManifest.json',
    (string) async => json.decode(string) as Iterable<dynamic>,
  );

  for (final dynamic entry in fontManifest) {
    final font = entry as Map<String, dynamic>;
    final familyNames = _derivedFontFamilies(font);
    final fonts = font['fonts'] as List<dynamic>;

    for (final familyName in familyNames) {
      final fontLoader = FontLoader(familyName);
      for (final dynamic fontTypeEntry in fonts) {
        final fontType = fontTypeEntry as Map<String, dynamic>;
        fontLoader.addFont(rootBundle.load(fontType['asset'] as String));
      }
      await fontLoader.load();
    }
  }
}
