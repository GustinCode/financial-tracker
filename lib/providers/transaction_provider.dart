import 'package:flutter/foundation.dart';
import '../models/transaction_model.dart';
import '../repositories/transaction_repository.dart';
import 'category_provider.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _repository = TransactionRepository();
  List<Transaction> _transactions = [];
  CategoryProvider? categoryProvider;

  double _totalIncome = 0.0;
  double _totalExpenses = 0.0;
  double _balance = 0.0;

  List<Transaction> get transactions => _transactions;

  double get totalIncome => _totalIncome;
  double get totalExpenses => _totalExpenses;
  double get balance => _balance;

  Future<void> loadTransactions() async {
    _transactions = await _repository.getAllTransactions();
    _recalculateTotals();
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _repository.addTransaction(transaction);
    await loadTransactions();
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final updatedTransaction = transaction.copyWith(
      updatedAt: DateTime.now(),
    );
    await _repository.updateTransaction(updatedTransaction);
    await loadTransactions();
  }

  Future<void> deleteTransaction(String id) async {
    await _repository.deleteTransaction(id);
    await loadTransactions();
  }

  List<Transaction> getTransactionsByType(TransactionType type) {
    return _transactions.where((t) => t.type == type).toList();
  }

  List<Transaction> getTransactionsByCategory(String categoryId) {
    return _transactions.where((t) => t.categoryId == categoryId).toList();
  }

  List<Transaction> getTransactionsForMonth(int year, int month) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0, 23, 59, 59, 999);
    return _transactions.where((t) {
      return !t.date.isBefore(start) && !t.date.isAfter(end);
    }).toList();
  }

  double getMonthlyExpensesForCategory(
    String categoryId,
    int year,
    int month,
  ) {
    return getTransactionsForMonth(year, month)
        .where(
          (t) =>
              t.type == TransactionType.expense && t.categoryId == categoryId,
        )
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getMonthlyTotalIncome(int year, int month) {
    return getTransactionsForMonth(year, month)
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getMonthlyTotalExpenses(int year, int month) {
    return getTransactionsForMonth(year, month)
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getMonthlyBalance(int year, int month) {
    return getMonthlyTotalIncome(year, month) -
        getMonthlyTotalExpenses(year, month);
  }

  void _recalculateTotals() {
    _totalIncome = _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    _totalExpenses = _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    _balance = _totalIncome - _totalExpenses;
  }
}

