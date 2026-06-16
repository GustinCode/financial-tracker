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