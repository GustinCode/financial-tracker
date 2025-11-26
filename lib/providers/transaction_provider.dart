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

