import 'package:flutter_test/flutter_test.dart';
import 'package:dart_flutter/sample/calculate_member_points.dart';

void main() {
  group('CalculateMemberPoints', () {
    test('should return 100 when calculate is called', () {
      final calculator = CalculateMemberPoints();
      final result = calculator.calculate();
      expect(result, 100);
    });
  });
}
