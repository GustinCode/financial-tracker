import 'package:flutter_test/flutter_test.dart';
import 'package:financial_tracker/services/csv_export_service.dart';
import 'package:financial_tracker/models/transaction_model.dart';

void main() {
  group('CsvExportService', () {
    final t1 = Transaction(
      id: '1',
      title: 'Salary',
      amount: 1000.0,
      date: DateTime(2023, 10, 15),
      createdAt: DateTime(2023, 10, 15),
      updatedAt: DateTime(2023, 10, 15),
      categoryId: 'cat_salary',
      type: TransactionType.income,
      description: 'Monthly salary',
    );

    final t2 = Transaction(
      id: '2',
      title: 'Groceries',
      amount: 150.50,
      date: DateTime(2023, 11, 2),
      createdAt: DateTime(2023, 11, 2),
      updatedAt: DateTime(2023, 11, 2),
      categoryId: 'cat_food',
      type: TransactionType.expense,
      description: 'Supermarket',
    );

    final t3 = Transaction(
      id: '3',
      title: 'Internet',
      amount: 50.0,
      date: DateTime(2023, 11, 20),
      createdAt: DateTime(2023, 11, 20),
      updatedAt: DateTime(2023, 11, 20),
      categoryId: 'cat_bills',
      type: TransactionType.expense,
    );

    final List<Transaction> allTransactions = [t1, t2, t3];

    final categoryNames = {
      'cat_salary': 'Salary',
      'cat_food': 'Food',
      'cat_bills': 'Bills',
    };

    test('generateCsv formats transactions correctly', () {
      final csv = CsvExportService.generateCsv(
        transactions: allTransactions,
        categoryNames: categoryNames,
        incomeLabel: 'Income',
        expenseLabel: 'Expense',
      );

      final lines = csv.trim().split('\n');
      expect(lines.length, 4); // Header + 3 transactions

      // Check header
      expect(lines[0], 'ID,Title,Type,Amount,Category,Date,Description');

      // Check first sorted by date (t1)
      expect(lines[1], '1,Salary,Income,1000.00,Salary,2023-10-15,Monthly salary');

      // Check second (t2)
      expect(lines[2], '2,Groceries,Expense,150.50,Food,2023-11-02,Supermarket');

      // Check third (t3)
      expect(lines[3], '3,Internet,Expense,50.00,Bills,2023-11-20,');
    });

    test('generateCsv escapes fields with commas and quotes', () {
      final tSpecial = Transaction(
        id: '4',
        title: 'Title with, comma',
        amount: 200.0,
        date: DateTime(2023, 12, 1),
        createdAt: DateTime(2023, 12, 1),
        updatedAt: DateTime(2023, 12, 1),
        categoryId: 'cat_other',
        type: TransactionType.expense,
        description: 'He said "Hello"',
      );

      final csv = CsvExportService.generateCsv(
        transactions: [tSpecial],
        categoryNames: categoryNames,
        incomeLabel: 'Income',
        expenseLabel: 'Expense',
      );

      final lines = csv.trim().split('\n');
      expect(lines.length, 2);
      
      // "Title with, comma" and "He said ""Hello"""
      expect(lines[1], '4,"Title with, comma",Expense,200.00,cat_other,2023-12-01,"He said ""Hello"""');
    });

    test('filterByPeriod ALL returns all transactions', () {
      final filtered = CsvExportService.filterByPeriod(
        allTransactions, 
        CsvExportPeriod.all,
      );
      expect(filtered.length, 3);
    });

    test('filterByPeriod currentMonth returns only current month transactions', () {
      final referenceDate = DateTime(2023, 11, 15);
      final filtered = CsvExportService.filterByPeriod(
        allTransactions, 
        CsvExportPeriod.currentMonth,
        referenceDate: referenceDate,
      );
      
      expect(filtered.length, 2);
      expect(filtered.contains(t2), isTrue);
      expect(filtered.contains(t3), isTrue);
    });

    test('filterByPeriod lastMonth returns only last month transactions', () {
      final referenceDate = DateTime(2023, 11, 15);
      final filtered = CsvExportService.filterByPeriod(
        allTransactions, 
        CsvExportPeriod.lastMonth,
        referenceDate: referenceDate,
      );
      
      expect(filtered.length, 1);
      expect(filtered.first, t1);
    });

    test('buildFileName formats date correctly', () {
      final date = DateTime(2023, 5, 9);
      final filename = CsvExportService.buildFileName(timestamp: date);
      expect(filename, 'financial_tracker_export_2023-05-09.csv');
    });
  });
}
