import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:financial_tracker/l10n/app_localizations.dart';
import 'package:financial_tracker/models/budget_model.dart';
import 'package:financial_tracker/models/category_model.dart' as models;
import 'package:financial_tracker/models/transaction_model.dart';
import 'package:financial_tracker/providers/budget_provider.dart';
import 'package:financial_tracker/providers/category_provider.dart';
import 'package:financial_tracker/providers/transaction_provider.dart';
import 'package:financial_tracker/utils/date_helpers.dart';
import 'package:financial_tracker/views/home_view.dart';
import 'package:financial_tracker/views/settings_view.dart';

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

class FakeTransactionProvider extends TransactionProvider {
  final List<Transaction> _transactions;

  FakeTransactionProvider(this._transactions);

  @override
  List<Transaction> get transactions => _transactions;

  @override
  double get totalIncome => _transactions
      .where((transaction) => transaction.type == TransactionType.income)
      .fold(0.0, (sum, transaction) => sum + transaction.amount);

  @override
  double get totalExpenses => _transactions
      .where((transaction) => transaction.type == TransactionType.expense)
      .fold(0.0, (sum, transaction) => sum + transaction.amount);

  @override
  double get balance => totalIncome - totalExpenses;

  @override
  Future<void> loadTransactions() async {}

  @override
  Future<void> addTransaction(Transaction transaction) async {}

  @override
  Future<void> updateTransaction(Transaction transaction) async {}

  @override
  Future<void> deleteTransaction(String id) async {}
}

class FakeBudgetProvider extends BudgetProvider {
  final List<Budget> _budgets;
  String? lastSavedCategoryId;
  double? lastSavedLimitAmount;
  String? lastSavedMonthKey;

  FakeBudgetProvider(this._budgets);

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
  }

  @override
  Future<void> deleteBudget(String id) async {}

  @override
  Future<BudgetStatus?> checkBudgetAlertAfterTransaction(
    String categoryId,
    DateTime date,
  ) async {
    return null;
  }
}

void main() {
  late FakeCategoryProvider categoryProvider;
  late FakeTransactionProvider transactionProvider;
  late FakeBudgetProvider budgetProvider;
  late models.Category incomeCategory;
  late models.Category expenseCategory;
  late Transaction incomeTransaction;
  late Transaction expenseTransaction;
  late Budget budget;

  Widget buildTestApp() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CategoryProvider>.value(value: categoryProvider),
        ChangeNotifierProvider<TransactionProvider>.value(value: transactionProvider),
        ChangeNotifierProvider<BudgetProvider>.value(value: budgetProvider),
      ],
      child: const MaterialApp(
        locale: Locale('en', 'US'),
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: HomeView(),
      ),
    );
  }

  setUp(() {
    final now = DateTime.now();
    incomeCategory = models.Category(
      id: 'income_salary',
      name: 'Salary',
      type: TransactionType.income,
      colorValue: Colors.green.toARGB32(),
      icon: '💰',
      isDefault: true,
    );
    expenseCategory = models.Category(
      id: 'expense_food',
      name: 'Food',
      type: TransactionType.expense,
      colorValue: Colors.orange.toARGB32(),
      icon: '🍔',
      isDefault: true,
    );

    incomeTransaction = Transaction(
      id: 'tx-income-1',
      title: 'Salary',
      amount: 1000,
      categoryId: incomeCategory.id,
      date: now,
      type: TransactionType.income,
      description: 'Monthly salary',
      createdAt: now,
      updatedAt: now,
    );
    expenseTransaction = Transaction(
      id: 'tx-expense-1',
      title: 'Groceries',
      amount: 40,
      categoryId: expenseCategory.id,
      date: now,
      type: TransactionType.expense,
      description: 'Supermarket',
      createdAt: now,
      updatedAt: now,
    );
    budget = Budget(
      id: 'budget-food-1',
      categoryId: expenseCategory.id,
      limitAmount: 100,
      monthKey: monthKeyFromDate(now),
      createdAt: now,
      updatedAt: now,
    );

    categoryProvider = FakeCategoryProvider([incomeCategory, expenseCategory]);
    transactionProvider = FakeTransactionProvider([incomeTransaction, expenseTransaction]);
    budgetProvider = FakeBudgetProvider([budget]);
  });

  testWidgets('home tab shows balance and recent transactions', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    // Balance display is visible
    expect(find.text('Current Balance'), findsOneWidget);

    // Scroll down to find transactions in case they're off-screen
    await tester.dragUntilVisible(
      find.text('Salary'),
      find.byType(CustomScrollView),
      const Offset(0, -200),
    );
    expect(find.text('Salary'), findsWidgets);

    await tester.dragUntilVisible(
      find.text('Groceries'),
      find.byType(CustomScrollView),
      const Offset(0, -200),
    );
    expect(find.text('Groceries'), findsWidgets);
  });

  testWidgets('navigates to dashboard and shows budget overview', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.insights_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard'), findsNWidgets(2));
    expect(find.text('Current Balance'), findsOneWidget);
    expect(find.text('Budget overview'), findsOneWidget);
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('40% used'), findsOneWidget);
  });

  testWidgets('navigates to history and shows transactions', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();

    expect(find.text('History'), findsNWidgets(2));

    // Scroll to find transactions
    await tester.dragUntilVisible(
      find.text('Salary'),
      find.byType(Scrollable).first,
      const Offset(0, -200),
    );
    expect(find.text('Salary'), findsWidgets);
  });

  testWidgets('navigates to settings and shows main sections', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsNWidgets(2));

    final settingsListView = find.descendant(
      of: find.byType(SettingsView),
      matching: find.byType(ListView),
    );

    // Scroll to find items that may be below the fold
    await tester.dragUntilVisible(
      find.text('Language').first,
      settingsListView,
      const Offset(0, -100),
    );
    expect(find.text('Language'), findsWidgets);

    await tester.dragUntilVisible(
      find.text('Categories').first,
      settingsListView,
      const Offset(0, -100),
    );
    expect(find.text('Categories'), findsWidgets);

    await tester.dragUntilVisible(
      find.text('Export to CSV'),
      settingsListView,
      const Offset(0, -100),
    );
    expect(find.text('Export to CSV'), findsOneWidget);
  });

  testWidgets('navigates to BudgetsView from dashboard', (tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.insights_outlined));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Manage Budgets'));
    await tester.pumpAndSettle();

    expect(find.text('Budgets'), findsOneWidget);
    expect(find.text('Food'), findsWidgets);

    await tester.pageBack();
    await tester.pumpAndSettle();
  });
}