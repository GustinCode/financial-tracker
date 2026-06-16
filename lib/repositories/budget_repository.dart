import 'package:hive_flutter/hive_flutter.dart';
import '../models/budget_model.dart';
import '../services/database_service.dart';

class BudgetRepository {
  Box<Budget> get _box => Hive.box<Budget>(DatabaseService.budgetsBoxName);

  Future<List<Budget>> getAllBudgets() async {
    return _box.values.toList();
  }

  Future<List<Budget>> getBudgetsByMonth(int year, int month) async {
    return _box.values
        .where((b) => b.year == year && b.month == month)
        .toList();
  }

  Future<Budget?> getBudgetByCategoryAndMonth(
    String categoryId,
    int year,
    int month,
  ) async {
    final id = Budget.createId(categoryId, year, month);
    return _box.get(id);
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
