import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

class ZolotoFileComparator extends LocalFileComparator {
  final double toleranceThreshold;

  /// Creates a comparator whose [basedir] equals [testFile]'s directory.
  ///
  /// [testFile] can be either a file URI (e.g.
  /// `file:///project/test/screens/my_test.dart`) or a directory URI
  /// (`file:///project/test/screens/`). When a directory URI is passed,
  /// a sentinel filename is appended so that [LocalFileComparator]'s
  /// `dirname` logic produces the same directory as [basedir].
  ZolotoFileComparator(Uri testFile, {this.toleranceThreshold = 0})
      : super(
          testFile.path.endsWith('/')
              ? testFile.replace(path: '${testFile.path}_')
              : testFile,
        );

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    if (!result.passed) {
      log(
        '[ZOLOTO] WARNING: $golden differs by ${(result.diffPercent * 100).toStringAsFixed(2)}%, but threshold is currently ${(toleranceThreshold * 100).toStringAsFixed(2)}%',
      );
    }

    final passed = result.passed || result.diffPercent <= toleranceThreshold;
    if (passed) {
      result.dispose();
      return true;
    }

    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}
