import 'package:flutter_test/flutter_test.dart';
import 'package:financial_tracker/models/transaction_model.dart';

void main() {
  group('Transaction Model', () {
    test('should create transaction with all properties', () {
      final date = DateTime.now();
      final transaction = Transaction(
        id: 'test-id',
        title: 'Test Transaction',
        amount: 100.50,
        categoryId: 'cat-1',
        date: date,
        type: TransactionType.expense,
        description: 'Test description',
        createdAt: date,
        updatedAt: date,
      );

      expect(transaction.id, 'test-id');
      expect(transaction.title, 'Test Transaction');
      expect(transaction.amount, 100.50);
      expect(transaction.categoryId, 'cat-1');
      expect(transaction.type, TransactionType.expense);
      expect(transaction.description, 'Test description');
    });

    test('copyWith should create new transaction with updated fields', () {
      final date = DateTime.now();
      final original = Transaction(
        id: 'test-id',
        title: 'Original',
        amount: 100.0,
        categoryId: 'cat-1',
        date: date,
        type: TransactionType.expense,
        createdAt: date,
        updatedAt: date,
      );

      final updated = original.copyWith(
        title: 'Updated',
        amount: 200.0,
      );

      expect(updated.title, 'Updated');
      expect(updated.amount, 200.0);
      expect(updated.id, 'test-id'); // Should remain unchanged
      expect(updated.type, TransactionType.expense); // Should remain unchanged
    });

    test('should handle income transaction type', () {
      final date = DateTime.now();
      final transaction = Transaction(
        id: 'test-id',
        title: 'Salary',
        amount: 5000.0,
        categoryId: 'cat-1',
        date: date,
        type: TransactionType.income,
        createdAt: date,
        updatedAt: date,
      );

      expect(transaction.type, TransactionType.income);
    });
  });
}
