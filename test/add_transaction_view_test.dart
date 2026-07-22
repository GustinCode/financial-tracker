import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:financial_tracker/models/category_model.dart' as models;
import 'package:financial_tracker/models/transaction_model.dart';
import 'package:financial_tracker/l10n/app_localizations.dart';
import 'package:financial_tracker/providers/category_provider.dart';
import 'package:financial_tracker/providers/transaction_provider.dart';
import 'package:financial_tracker/views/add_transaction_view.dart';

class FakeCategoryProvider extends CategoryProvider {
  final List<models.Category> _fakeCategories;

  FakeCategoryProvider(this._fakeCategories);

  @override
  List<models.Category> getCategoriesByType(TransactionType type) {
    return _fakeCategories.where((c) => c.type == type).toList();
  }

  @override
  models.Category? getCategoryById(String id) {
    try {
      return _fakeCategories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}

class FakeTransactionProvider extends TransactionProvider {
  Transaction? lastAdded;
  Transaction? lastUpdated;

  @override
  Future<void> addTransaction(Transaction transaction) async {
    lastAdded = transaction;
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    lastUpdated = transaction;
  }
}

void main() {
  group('AddTransactionView', () {
    late FakeCategoryProvider categoryProvider;
    late FakeTransactionProvider transactionProvider;
    late models.Category expenseCategory;

    Widget buildTestApp(Widget child) {
      return MaterialApp(
        locale: const Locale('pt', 'BR'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      );
    }

    setUp(() {
      expenseCategory = models.Category(
        id: 'cat-expense-1',
        name: 'Food',
        type: TransactionType.expense,
        colorValue: 0xFF000000,
        icon: '🍔',
      );

      categoryProvider = FakeCategoryProvider([expenseCategory]);
      transactionProvider = FakeTransactionProvider();
    });

    testWidgets('shows new transaction title when creating',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CategoryProvider>.value(
              value: categoryProvider,
            ),
            ChangeNotifierProvider<TransactionProvider>.value(
              value: transactionProvider,
            ),
          ],
          child: buildTestApp(const AddTransactionView()),
        ),
      );

      expect(find.text('Nova Transação'), findsNWidgets(2));
    });

    testWidgets(
        'shows edit transaction title and prefilled fields when editing',
        (WidgetTester tester) async {
      final now = DateTime.now();
      final existing = Transaction(
        id: 't1',
        title: 'Existing',
        amount: 50.0,
        categoryId: expenseCategory.id,
        date: now,
        type: TransactionType.expense,
        description: 'Existing description',
        createdAt: now,
        updatedAt: now,
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<CategoryProvider>.value(
              value: categoryProvider,
            ),
            ChangeNotifierProvider<TransactionProvider>.value(
              value: transactionProvider,
            ),
          ],
          child: buildTestApp(AddTransactionView(transaction: existing)),
        ),
      );

      expect(find.text('Editar Transação'), findsNWidgets(2));
      expect(find.widgetWithText(TextFormField, 'Título *'), findsOneWidget);
      expect(find.text('Existing'), findsOneWidget);
    });
  });
}

