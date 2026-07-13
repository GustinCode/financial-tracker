import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../models/budget_model.dart';
import '../models/transaction_model.dart';
import '../repositories/budget_repository.dart';
import '../services/database_service.dart';
import '../utils/date_helpers.dart';

class BudgetProvider extends ChangeNotifier {
  final BudgetRepository _repository = BudgetRepository();
  final Uuid _uuid = const Uuid();

  List<Budget> _budgets = [];

  List<Budget> get budgets => _budgets;

  bool get isCurrentMonth {
    final currentMonthKey = monthKeyFromDate(DateTime.now());
    return _budgets.any((budget) => budget.monthKey == currentMonthKey);
  }

  Future<void> loadBudgets() async {
    _budgets = await _repository.getAllBudgets();
    notifyListeners();
  }

  List<Budget> getBudgetsForMonth(String monthKey) {
    return _budgets.where((budget) => budget.monthKey == monthKey).toList();
  }

  Future<void> saveBudget({
    String? id,
    required String categoryId,
    required double limitAmount,
    required String monthKey,
  }) async {
    final existing = await _repository.getBudgetByCategoryAndMonth(
      categoryId,
      monthKey,
    );

    final budget = Budget(
      id: existing?.id ?? id ?? _uuid.v4(),
      categoryId: categoryId,
      limitAmount: limitAmount,
      monthKey: monthKey,
      createdAt: existing?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (existing == null) {
      await _repository.addBudget(budget);
    } else {
      await _repository.updateBudget(budget);
    }

    await loadBudgets();
  }

  Future<void> addBudget({
    required String categoryId,
    required double limitAmount,
    String? monthKey,
  }) async {
    await saveBudget(
      categoryId: categoryId,
      limitAmount: limitAmount,
      monthKey: monthKey ?? monthKeyFromDate(DateTime.now()),
    );
  }

  Future<void> updateBudget(Budget budget, double limitAmount) async {
    final updated = budget.copyWith(
      limitAmount: limitAmount,
      updatedAt: DateTime.now(),
    );
    await _repository.updateBudget(updated);
    await loadBudgets();
  }

  Future<void> deleteBudget(String id) async {
    await _repository.deleteBudget(id);
    await loadBudgets();
  }

  Future<void> deleteAllBudgets() async {
    final allBudgets = await _repository.getAllBudgets();
    for (final budget in allBudgets) {
      await _repository.deleteBudget(budget.id);
    }
    await loadBudgets();
  }

  Future<BudgetStatus?> checkBudgetAlertAfterTransaction(
    String categoryId,
    DateTime date,
  ) async {
    final monthKey = monthKeyFromDate(date);
    final budget = _budgets.firstWhere(
      (item) => item.categoryId == categoryId && item.monthKey == monthKey,
      orElse: () => Budget(
        id: '',
        categoryId: '',
        limitAmount: 0,
        monthKey: monthKey,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );

    if (budget.id.isEmpty || budget.limitAmount <= 0) {
      return null;
    }

    final box = Hive.box<Transaction>(DatabaseService.transactionsBoxName);
    final monthTransactions = box.values.where((transaction) {
      return transaction.type == TransactionType.expense &&
          transaction.categoryId == categoryId &&
          monthKeyFromDate(transaction.date) == monthKey;
    }).toList();

    final spent = monthTransactions.fold<double>(0, (sum, transaction) => sum + transaction.amount);

    if (spent >= budget.limitAmount) {
      return BudgetStatus.exceeded;
    }
    if (spent >= budget.limitAmount * 0.8) {
      return BudgetStatus.warning;
    }
    return BudgetStatus.ok;
  }

  List<BudgetProgress> getAllProgress() {
    final currentMonthKey = monthKeyFromDate(DateTime.now());
    final box = Hive.box<Transaction>(DatabaseService.transactionsBoxName);
    final monthTransactions = box.values.where((transaction) {
      return transaction.type == TransactionType.expense &&
          monthKeyFromDate(transaction.date) == currentMonthKey;
    }).toList();

    final spentByCategory = <String, double>{};
    for (final transaction in monthTransactions) {
      spentByCategory.update(
        transaction.categoryId,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }

    return _budgets
        .where((budget) => budget.monthKey == currentMonthKey)
        .map((budget) {
          final spent = spentByCategory[budget.categoryId] ?? 0;
          final percentage = budget.limitAmount <= 0 ? 0.0 : (spent / budget.limitAmount) * 100;
          final remaining = budget.limitAmount - spent;
          final status = percentage >= 100
              ? BudgetStatus.exceeded
              : percentage >= 80
                  ? BudgetStatus.warning
                  : BudgetStatus.ok;
          return BudgetProgress(
            budget: budget,
            spent: spent,
            percentage: percentage,
            remaining: remaining,
            status: status,
          );
        })
        .toList();
  }
}