import 'package:flutter_test/flutter_test.dart';
import 'package:financial_tracker/utils/formatters.dart';

void main() {
  group('Formatters', () {
    test('formatCurrency should format value correctly', () {
      final result1 = Formatters.formatCurrency(100.50);
      final result2 = Formatters.formatCurrency(0);
      final result3 = Formatters.formatCurrency(1234.56);
      
      expect(result1, contains('R\$'));
      expect(result1, contains('100'));
      expect(result2, contains('R\$'));
      expect(result2, contains('0'));
      expect(result3, contains('R\$'));
      expect(result3, contains('1')); // Check for at least the first digit
    });

    test('formatDate should format date correctly', () {
      final date = DateTime(2024, 1, 15);
      expect(Formatters.formatDate(date), '15/01/2024');
    });

    test('formatDateTime should format date and time correctly', () {
      final date = DateTime(2024, 1, 15, 14, 30);
      expect(Formatters.formatDateTime(date), '15/01/2024 14:30');
    });
  });
}
