<<<<<<< HEAD
import 'package:flutter/foundation.dart';
import '../models/budget_model.dart';
import '../repositories/budget_repository.dart';
import 'category_provider.dart';
import 'transaction_provider.dart';

class BudgetProvider extends ChangeNotifier {
  final BudgetRepository _repository = BudgetRepository();
  List<Budget> _budgets = [];
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  CategoryProvider? categoryProvider;
  TransactionProvider? transactionProvider;

  List<Budget> get budgets => _budgets;
  DateTime get selectedMonth => _selectedMonth;
  int get selectedYear => _selectedMonth.year;
  int get selectedMonthNumber => _selectedMonth.month;

  Future<void> loadBudgets() async {
    _budgets = await _repository.getBudgetsByMonth(
      selectedYear,
      selectedMonthNumber,
    );
    notifyListeners();
  }

  Future<void> setSelectedMonth(DateTime month) async {
    _selectedMonth = DateTime(month.year, month.month);
    await loadBudgets();
  }

  Future<void> goToPreviousMonth() async {
    await setSelectedMonth(
      DateTime(selectedYear, selectedMonthNumber - 1),
    );
  }

  Future<void> goToNextMonth() async {
    await setSelectedMonth(
      DateTime(selectedYear, selectedMonthNumber + 1),
    );
  }

  Future<void> goToCurrentMonth() async {
    final now = DateTime.now();
    await setSelectedMonth(DateTime(now.year, now.month));
  }

  bool get isCurrentMonth {
    final now = DateTime.now();
    return selectedYear == now.year && selectedMonthNumber == now.month;
  }

  Future<void> addBudget({
    required String categoryId,
    required double limitAmount,
  }) async {
    final existing = await _repository.getBudgetByCategoryAndMonth(
      categoryId,
      selectedYear,
      selectedMonthNumber,
    );
    if (existing != null) {
      throw StateError('Budget already exists for this category and month');
    }

    final budget = Budget(
      id: Budget.createId(categoryId, selectedYear, selectedMonthNumber),
      categoryId: categoryId,
      limitAmount: limitAmount,
      year: selectedYear,
      month: selectedMonthNumber,
      createdAt: DateTime.now(),
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

  Future<void> deleteBudget(String id) async {
    await _repository.deleteBudget(id);
    await loadBudgets();
  }

  Future<void> deleteAllBudgets() async {
    await _repository.deleteAllBudgets();
    await loadBudgets();
  }

  Budget? getBudgetForCategory(String categoryId) {
    try {
      return _budgets.firstWhere((b) => b.categoryId == categoryId);
    } catch (_) {
      return null;
    }
  }

  double getSpentForCategory(String categoryId, {int? year, int? month}) {
    final y = year ?? selectedYear;
    final m = month ?? selectedMonthNumber;
    return transactionProvider?.getMonthlyExpensesForCategory(categoryId, y, m) ??
        0.0;
  }

  BudgetProgress getProgress(Budget budget) {
    final spent = getSpentForCategory(budget.categoryId);
    return _buildProgress(budget, spent);
  }

  List<BudgetProgress> getAllProgress() {
    return _budgets.map(getProgress).toList()
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
      date.year,
      date.month,
    );
    if (budget == null) return null;

    final spent = transactionProvider?.getMonthlyExpensesForCategory(
          categoryId,
          date.year,
          date.month,
        ) ??
        0.0;

    final progress = _buildProgress(budget, spent);
    if (progress.status == BudgetStatus.exceeded ||
        progress.status == BudgetStatus.warning) {
      return progress.status;
    }
    return null;
  }

  List<BudgetProgress> getCurrentMonthProgress() {
    if (!isCurrentMonth) return [];
    return getAllProgress();
  }

  List<String> getCategoriesWithBudgetForMonth(int year, int month) {
    return _budgets
        .where((b) => b.year == year && b.month == month)
        .map((b) => b.categoryId)
        .toList();
  }

  Future<List<Budget>> loadBudgetsForMonth(int year, int month) async {
    return _repository.getBudgetsByMonth(year, month);
  }
}
=======
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/budget_model.dart';
import '../repositories/budget_repository.dart';

class BudgetProvider extends ChangeNotifier {
  final BudgetRepository _repository = BudgetRepository();
  final Uuid _uuid = const Uuid();

  List<Budget> _budgets = [];

  List<Budget> get budgets => _budgets;

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

  Future<void> deleteBudget(String id) async {
    await _repository.deleteBudget(id);
    await loadBudgets();
  }
}
>>>>>>> 0341b2aace011fd5299e50e2816cd34a66c588a9
