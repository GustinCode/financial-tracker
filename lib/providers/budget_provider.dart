import 'package:flutter/foundation.dart';

import '../models/budget_model.dart';
import '../repositories/budget_repository.dart';
import '../providers/transaction_provider.dart';
import '../utils/date_helpers.dart';

class BudgetProvider extends ChangeNotifier {
  final BudgetRepository _repository = BudgetRepository();

  List<Budget> _budgets = [];
  TransactionProvider? _transactionProvider;

  List<Budget> get budgets => _budgets;

  set transactionProvider(TransactionProvider provider) {
    _transactionProvider = provider;
  }

  Future<void> loadBudgets() async {
    _budgets = await _repository.getAllBudgets();
    notifyListeners();
  }

  List<Budget> getBudgetsForMonth(String monthKey) {
    return _budgets.where((budget) => budget.monthKey == monthKey).toList();
  }

  Future<void> addBudget({
    required String categoryId,
    required double limitAmount,
  }) async {
    final monthKey = monthKeyFromDate(DateTime.now());
    final existing = await _repository.getBudgetByCategoryAndMonth(
      categoryId,
      monthKey,
    );
    if (existing != null) {
      throw StateError('Budget already exists for this category and month');
    }

    final budget = Budget(
      id: Budget.createId(categoryId, monthKey),
      categoryId: categoryId,
      limitAmount: limitAmount,
      monthKey: monthKey,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _repository.addBudget(budget);
    await loadBudgets();
  }

  Future<void> updateBudget(Budget budget, double limitAmount) async {
    final updated = budget.copyWith(
      limitAmount: limitAmount,
      updatedAt: DateTime.now(),
    );
    await _repository.updateBudget(updated);
    await loadBudgets();
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
      id: existing?.id ?? id ?? Budget.createId(categoryId, monthKey),
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

  Future<void> deleteBudget(String id) async {
    await _repository.deleteBudget(id);
    await loadBudgets();
  }

  Future<void> deleteAllBudgets() async {
    await _repository.deleteAllBudgets();
    await loadBudgets();
  }

  double getSpentForCategory(String categoryId, DateTime date) {
    return _transactionProvider
            ?.getMonthlyExpensesForCategory(categoryId, date.year, date.month) ??
        0.0;
  }

  BudgetProgress getProgress(Budget budget) {
    final spent = getSpentForCategory(
      budget.categoryId,
      DateTime.parse('${budget.monthKey}-01'),
    );
    return _buildProgress(budget, spent);
  }

  List<BudgetProgress> getAllProgress() {
    final currentMonthKey = monthKeyFromDate(DateTime.now());
    return _budgets
        .where((budget) => budget.monthKey == currentMonthKey)
        .map(getProgress)
        .toList()
      ..sort((a, b) => b.percentage.compareTo(a.percentage));
  }

  BudgetProgress _buildProgress(Budget budget, double spent) {
    final percentage = budget.limitAmount > 0
        ? (spent / budget.limitAmount) * 100
        : (spent > 0 ? 100.0 : 0.0);
    final remaining = budget.limitAmount - spent;

    BudgetStatus status;
    if (percentage >= 100) {
      status = BudgetStatus.exceeded;
    } else if (percentage >= 80) {
      status = BudgetStatus.warning;
    } else {
      status = BudgetStatus.ok;
    }

    return BudgetProgress(
      budget: budget,
      spent: spent,
      percentage: percentage,
      status: status,
      remaining: remaining,
    );
  }

  Future<BudgetStatus?> checkBudgetAlertAfterTransaction(
    String categoryId,
    DateTime date,
  ) async {
    final budget = await _repository.getBudgetByCategoryAndMonth(
      categoryId,
      monthKeyFromDate(date),
    );
    if (budget == null) return null;

    final spent = getSpentForCategory(categoryId, date);
    final progress = _buildProgress(budget, spent);
    if (progress.status == BudgetStatus.exceeded ||
        progress.status == BudgetStatus.warning) {
      return progress.status;
    }
    return null;
  }

  bool get isCurrentMonth {
    final now = DateTime.now();
    final currentKey = monthKeyFromDate(now);
    return _budgets.any((budget) => budget.monthKey == currentKey);
  }

  Budget? getBudgetForCategory(String categoryId) {
    try {
      final currentMonthKey = monthKeyFromDate(DateTime.now());
      return _budgets.firstWhere(
        (b) => b.categoryId == categoryId && b.monthKey == currentMonthKey,
      );
    } catch (_) {
      return null;
    }
  }
}
