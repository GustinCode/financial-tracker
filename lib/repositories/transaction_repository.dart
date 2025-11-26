import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction_model.dart';
import '../services/database_service.dart';

class TransactionRepository {
  Box<Transaction> get _box =>
      Hive.box<Transaction>(DatabaseService.transactionsBoxName);

  Future<List<Transaction>> getAllTransactions() async {
    return _box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  Future<Transaction?> getTransactionById(String id) async {
    return _box.get(id);
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }

  Future<List<Transaction>> getTransactionsByType(TransactionType type) async {
    final allTransactions = await getAllTransactions();
    return allTransactions.where((t) => t.type == type).toList();
  }

  Future<List<Transaction>> getTransactionsByCategory(String categoryId) async {
    final allTransactions = await getAllTransactions();
    return allTransactions.where((t) => t.categoryId == categoryId).toList();
  }

  Future<List<Transaction>> getTransactionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final allTransactions = await getAllTransactions();
    return allTransactions.where((t) {
      return t.date.isAfter(start.subtract(const Duration(days: 1))) &&
          t.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }
}
