import 'package:flutter_test/flutter_test.dart';
import 'package:financial_tracker/models/category_model.dart';
import 'package:financial_tracker/models/transaction_model.dart';

void main() {
  group('Category Model', () {
    test('should create category with all properties', () {
      final category = Category(
        id: 'cat-1',
        name: 'Food',
        type: TransactionType.expense,
        colorValue: 0xFF000000,
        icon: '🍔',
        isDefault: true,
      );

      expect(category.id, 'cat-1');
      expect(category.name, 'Food');
      expect(category.type, TransactionType.expense);
      expect(category.colorValue, 0xFF000000);
      expect(category.icon, '🍔');
      expect(category.isDefault, true);
    });

    test('copyWith should create new category with updated fields', () {
      final original = Category(
        id: 'cat-1',
        name: 'Food',
        type: TransactionType.expense,
        colorValue: 0xFF000000,
        icon: '🍔',
      );

      final updated = original.copyWith(
        name: 'Restaurant',
        icon: '🍕',
      );

      expect(updated.name, 'Restaurant');
      expect(updated.icon, '🍕');
      expect(updated.id, 'cat-1'); // Should remain unchanged
      expect(updated.type, TransactionType.expense); // Should remain unchanged
    });

    test('should handle income category type', () {
      final category = Category(
        id: 'cat-2',
        name: 'Salary',
        type: TransactionType.income,
        colorValue: 0xFF00FF00,
        icon: '💰',
      );

      expect(category.type, TransactionType.income);
    });
  });
}
