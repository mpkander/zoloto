import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zoloto/zoloto.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  const manrope = TextTheme(
    displayLarge: TextStyle(fontFamily: 'Manrope'),
    displayMedium: TextStyle(fontFamily: 'Manrope'),
    displaySmall: TextStyle(fontFamily: 'Manrope'),
    headlineLarge: TextStyle(fontFamily: 'Manrope'),
    headlineMedium: TextStyle(fontFamily: 'Manrope'),
    headlineSmall: TextStyle(fontFamily: 'Manrope'),
    titleLarge: TextStyle(fontFamily: 'Manrope'),
    titleMedium: TextStyle(fontFamily: 'Manrope'),
    titleSmall: TextStyle(fontFamily: 'Manrope'),
    bodyLarge: TextStyle(fontFamily: 'Manrope'),
    bodyMedium: TextStyle(fontFamily: 'Manrope'),
    bodySmall: TextStyle(fontFamily: 'Manrope'),
    labelLarge: TextStyle(fontFamily: 'Manrope'),
    labelMedium: TextStyle(fontFamily: 'Manrope'),
    labelSmall: TextStyle(fontFamily: 'Manrope'),
  );

  return Zoloto.setup(
    testMain: testMain,
    config: ZolotoConfig.defaultSetup(
      appWrapperFactory: () => defaultAppWrapper(
        theme: ThemeData(textTheme: manrope),
        darkTheme: ThemeData.dark().copyWith(textTheme: manrope),
      ),
    ),
  );
}
