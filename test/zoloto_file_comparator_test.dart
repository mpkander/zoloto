import 'package:flutter_test/flutter_test.dart';
import 'package:zoloto/zoloto.dart';

void main() {
  group('ZolotoFileComparator', () {
    test('AC-8.4.1: extends LocalFileComparator', () {
      final comparator = ZolotoFileComparator(Uri.parse('file:///test.dart'));
      expect(comparator, isA<LocalFileComparator>());
    });

    test('default toleranceThreshold is 0', () {
      final comparator = ZolotoFileComparator(Uri.parse('file:///test.dart'));
      expect(comparator.toleranceThreshold, 0);
    });

    test('custom toleranceThreshold', () {
      final comparator = ZolotoFileComparator(
        Uri.parse('file:///test.dart'),
        toleranceThreshold: 0.05,
      );
      expect(comparator.toleranceThreshold, 0.05);
    });
  });
}
