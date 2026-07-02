import 'package:hive_flutter/hive_flutter.dart';

import '../models/budget_model.dart';
import '../services/database_service.dart';

class BudgetRepository {
  Box<Budget> get _box => Hive.box<Budget>(DatabaseService.budgetsBoxName);

  Future<List<Budget>> getAllBudgets() async {
    final budgets = _box.values.toList();
    budgets.sort((a, b) {
      final monthComparison = b.monthKey.compareTo(a.monthKey);
      if (monthComparison != 0) return monthComparison;
      return a.categoryId.compareTo(b.categoryId);
    });
    return budgets;
  }

  Future<List<Budget>> getBudgetsByMonth(String monthKey) async {
    final allBudgets = await getAllBudgets();
    return allBudgets.where((budget) => budget.monthKey == monthKey).toList();
  }

  Future<Budget?> getBudgetByCategoryAndMonth(
    String categoryId,
    String monthKey,
  ) async {
    for (final budget in _box.values) {
      if (budget.categoryId == categoryId && budget.monthKey == monthKey) {
        return budget;
      }
    }
    return null;
  }

  Future<void> addBudget(Budget budget) async {
    await _box.put(budget.id, budget);
  }

  Future<void> updateBudget(Budget budget) async {
    await _box.put(budget.id, budget);
  }

  Future<void> deleteBudget(String id) async {
    await _box.delete(id);
  }

  Future<void> deleteAllBudgets() async {
    await _box.clear();
  }
}

