import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:financial_tracker/models/budget_model.dart';
import 'package:financial_tracker/models/category_model.dart' as models;
import 'package:financial_tracker/models/transaction_model.dart';
import 'package:financial_tracker/l10n/app_localizations.dart';
import 'package:financial_tracker/providers/budget_provider.dart';
import 'package:financial_tracker/providers/category_provider.dart';
import 'package:financial_tracker/utils/date_helpers.dart';
import 'package:financial_tracker/views/budgets_view.dart';

class FakeCategoryProvider extends CategoryProvider {
  final List<models.Category> _categories;

  FakeCategoryProvider(this._categories);

  @override
  List<models.Category> get categories => _categories;

  @override
  List<models.Category> getCategoriesByType(TransactionType type) {
    return _categories.where((category) => category.type == type).toList();
  }

  @override
  models.Category? getCategoryById(String id) {
    for (final category in _categories) {
      if (category.id == id) {
        return category;
      }
    }
    return null;
  }
}

class FakeBudgetProvider extends BudgetProvider {
  final List<Budget> _budgets = [];
  String? lastSavedCategoryId;
  double? lastSavedLimitAmount;
  String? lastSavedMonthKey;
  String? lastDeletedBudgetId;

  FakeBudgetProvider(List<Budget> initialBudgets) {
    _budgets.addAll(initialBudgets);
  }

  @override
  List<Budget> get budgets => _budgets;

  @override
  Future<void> loadBudgets() async {}

  @override
  List<Budget> getBudgetsForMonth(String monthKey) {
    return _budgets.where((budget) => budget.monthKey == monthKey).toList();
  }

  @override
  Future<void> saveBudget({
    String? id,
    required String categoryId,
    required double limitAmount,
    required String monthKey,
  }) async {
    lastSavedCategoryId = categoryId;
    lastSavedLimitAmount = limitAmount;
    lastSavedMonthKey = monthKey;

    if (id == null) {
      _budgets.add(Budget(
        id: 'new-budget-id',
        categoryId: categoryId,
        limitAmount: limitAmount,
        monthKey: monthKey,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
    } else {
      final index = _budgets.indexWhere((budget) => budget.id == id);
      if (index != -1) {
        _budgets[index] = _budgets[index].copyWith(
          categoryId: categoryId,
          limitAmount: limitAmount,
          monthKey: monthKey,
          updatedAt: DateTime.now(),
        );
      }
    }
    notifyListeners();
  }

  @override
  Future<void> deleteBudget(String id) async {
    lastDeletedBudgetId = id;
    _budgets.removeWhere((budget) => budget.id == id);
    notifyListeners();
  }
}

void main() {
  group('BudgetsView', () {
    late FakeCategoryProvider categoryProvider;
    late FakeBudgetProvider budgetProvider;
    late models.Category expenseCategory1;
    late models.Category expenseCategory2;
    late Budget existingBudget;

    Widget buildTestApp(Widget child) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<CategoryProvider>.value(
            value: categoryProvider,
          ),
          ChangeNotifierProvider<BudgetProvider>.value(
            value: budgetProvider,
          ),
        ],
        child: MaterialApp(
          locale: const Locale('en', 'US'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: child,
        ),
      );
    }

    setUp(() {
      final now = DateTime.now();
      expenseCategory1 = models.Category(
        id: 'cat-expense-1',
        name: 'Food',
        type: TransactionType.expense,
        colorValue: 0xFF000000,
        icon: '🍔',
        isDefault: true,
      );
      expenseCategory2 = models.Category(
        id: 'cat-expense-2',
        name: 'Transport',
        type: TransactionType.expense,
        colorValue: 0xFF000000,
        icon: '🚗',
        isDefault: true,
      );

      existingBudget = Budget(
        id: 'budget-1',
        categoryId: expenseCategory1.id,
        limitAmount: 200.0,
        monthKey: monthKeyFromDate(now),
        createdAt: now,
        updatedAt: now,
      );

      categoryProvider = FakeCategoryProvider([expenseCategory1, expenseCategory2]);
      budgetProvider = FakeBudgetProvider([existingBudget]);
    });

    testWidgets('shows budgets for the selected month', (tester) async {
      await tester.pumpWidget(buildTestApp(const BudgetsView()));
      await tester.pumpAndSettle();

      expect(find.text('Budgets'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('Budget limit: 200.00'), findsOneWidget);
    });

    testWidgets('allows adding a new budget', (tester) async {
      await tester.pumpWidget(buildTestApp(const BudgetsView()));
      await tester.pumpAndSettle();

      // Tap the FAB to open dialog
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Dialog opened with 'Add Budget' title
      expect(find.descendant(of: find.byType(AlertDialog), matching: find.text('Add Budget')), findsOneWidget);
      expect(find.text('Monthly Limit'), findsOneWidget);

      // Enter amount (category is pre-selected as Food by default)
      await tester.enterText(find.widgetWithText(TextFormField, 'Monthly Limit'), '150.00');
      await tester.pumpAndSettle();

      // Tap Save Budget button
      await tester.tap(find.text('Save Budget'));
      await tester.pumpAndSettle();

      expect(budgetProvider.lastSavedCategoryId, expenseCategory1.id);
      expect(budgetProvider.lastSavedLimitAmount, 150.0);
      expect(budgetProvider.lastSavedMonthKey, monthKeyFromDate(DateTime.now()));
    });

    testWidgets('allows editing an existing budget', (tester) async {
      await tester.pumpWidget(buildTestApp(const BudgetsView()));
      await tester.pumpAndSettle();

      expect(find.text('Food'), findsOneWidget);

      // Open popup menu
      await tester.tap(find.byIcon(Icons.more_vert).first);
      await tester.pumpAndSettle();

      // Tap Edit Budget
      await tester.tap(find.text('Edit Budget'));
      await tester.pumpAndSettle();

      // Dialog opens with Edit Budget title
      expect(find.descendant(of: find.byType(AlertDialog), matching: find.text('Edit Budget')), findsOneWidget);

      // Change the amount
      await tester.enterText(find.widgetWithText(TextFormField, 'Monthly Limit'), '250.00');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save Budget'));
      await tester.pumpAndSettle();

      expect(budgetProvider.lastSavedCategoryId, existingBudget.categoryId);
      expect(budgetProvider.lastSavedLimitAmount, 250.0);
      expect(budgetProvider.lastSavedMonthKey, existingBudget.monthKey);
    });

    testWidgets('allows deleting an existing budget', (tester) async {
      await tester.pumpWidget(buildTestApp(const BudgetsView()));
      await tester.pumpAndSettle();

      expect(find.text('Food'), findsOneWidget);

      // Open popup menu
      await tester.tap(find.byIcon(Icons.more_vert).first);
      await tester.pumpAndSettle();

      // Tap Delete
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Confirm dialog appears
      expect(find.text('Are you sure you want to delete this budget?'), findsOneWidget);

      // Confirm deletion - tap the second Delete button inside the dialog
      await tester.tap(find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Delete'),
      ));
      await tester.pumpAndSettle();

      expect(budgetProvider.lastDeletedBudgetId, existingBudget.id);
      // Budget should be removed from the list
      expect(find.text('Budget limit: 200.00'), findsNothing);
    });

    testWidgets('navigates through months', (tester) async {
      await tester.pumpWidget(buildTestApp(const BudgetsView()));
      await tester.pumpAndSettle();

      final now = DateTime.now();
      expect(find.text(formatMonthLabel(now, const Locale('en', 'US'))), findsOneWidget);

      // Go to previous month
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();
      expect(find.text(formatMonthLabel(DateTime(now.year, now.month - 1), const Locale('en', 'US'))), findsOneWidget);

      // Go to next month (back to current)
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();
      expect(find.text(formatMonthLabel(now, const Locale('en', 'US'))), findsOneWidget);
    });
  });
}