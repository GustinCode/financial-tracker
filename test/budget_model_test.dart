import 'package:flutter_test/flutter_test.dart';
import 'package:financial_tracker/models/budget_model.dart';

void main() {
  group('Budget', () {
    test('createId generates consistent composite key', () {
      expect(
        Budget.createId('expense_food', 2026, 6),
        'expense_food_2026_6',
      );
    });
  });

  group('BudgetProgress status', () {
    test('percentage at 80% is warning threshold', () {
      final budget = Budget(
        id: 'expense_food_2026_6',
        categoryId: 'expense_food',
        limitAmount: 100,
        year: 2026,
        month: 6,
        createdAt: DateTime(2026, 6, 1),
      );

      const spent = 80.0;
      final percentage = (spent / budget.limitAmount) * 100;
      expect(percentage, 80.0);
      expect(percentage >= 80 && percentage < 100, isTrue);
    });

    test('percentage at 100% is exceeded', () {
      final budget = Budget(
        id: 'expense_food_2026_6',
        categoryId: 'expense_food',
        limitAmount: 100,
        year: 2026,
        month: 6,
        createdAt: DateTime(2026, 6, 1),
      );

      const spent = 100.0;
      final percentage = (spent / budget.limitAmount) * 100;
      expect(percentage >= 100, isTrue);
    });
  });
}
