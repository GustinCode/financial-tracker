import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../models/transaction_model.dart';
import '../providers/budget_provider.dart';
import '../providers/category_provider.dart';
import '../providers/transaction_provider.dart';
import '../utils/date_helpers.dart';
import '../utils/formatters.dart';
import 'budgets_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  DateTime _selectedMonth = monthStart(DateTime.now());

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final budgetProvider = context.watch<BudgetProvider>();
    final l10n = AppLocalizations.of(context)!;
    final locale = Formatters.getLocaleFromContext(context);

    final monthTransactions = transactionProvider.transactions
        .where((transaction) => isSameMonth(transaction.date, _selectedMonth))
        .toList();

    final income = monthTransactions
        .where((transaction) => transaction.type == TransactionType.income)
        .fold<double>(0, (sum, transaction) => sum + transaction.amount);
    final expenses = monthTransactions
        .where((transaction) => transaction.type == TransactionType.expense)
        .fold<double>(0, (sum, transaction) => sum + transaction.amount);
    final balance = income - expenses;

    final monthBudgets = budgetProvider.getBudgetsForMonth(monthKeyFromDate(_selectedMonth));
    final expenseByCategory = <String, double>{};
    for (final transaction in monthTransactions.where((transaction) => transaction.type == TransactionType.expense)) {
      expenseByCategory.update(
        transaction.categoryId,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }

    final topExpenseCategories = expenseByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => _changeMonth(-1),
                icon: const Icon(Icons.chevron_left),
              ),
              Text(
                DateFormat('MMMM yyyy', locale?.toString() ?? 'en_US').format(_selectedMonth),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => _changeMonth(1),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  label: l10n.incomesLabel,
                  value: income,
                  color: Colors.green,
                  icon: Icons.trending_up,
                  locale: locale,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  label: l10n.expensesLabel,
                  value: expenses,
                  color: Colors.red,
                  icon: Icons.trending_down,
                  locale: locale,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SummaryCard(
            label: l10n.currentBalance,
            value: balance,
            color: balance >= 0 ? Colors.green : Colors.red,
            icon: Icons.account_balance_wallet_outlined,
            locale: locale,
            fullWidth: true,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Budget overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BudgetsView()),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Manage budgets'),
              ),
            ],
          ),
          if (monthBudgets.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No budgets created for this month yet.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ...monthBudgets.map((budget) {
              final category = categoryProvider.getCategoryById(budget.categoryId);
              final spent = expenseByCategory[budget.categoryId] ?? 0;
              final progress = budget.limitAmount <= 0 ? 0.0 : (spent / budget.limitAmount).clamp(0.0, 1.0);
              final remaining = budget.limitAmount - spent;

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: category != null
                                ? Color(category.colorValue).withValues(alpha: 0.15)
                                : Colors.grey.shade200,
                            child: Text(category?.icon ?? '💰'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category?.name ?? 'Unknown category',
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${Formatters.formatCurrency(spent, locale)} spent of ${Formatters.formatCurrency(budget.limitAmount, locale)}',
                                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            remaining >= 0
                                ? '${Formatters.formatCurrency(remaining, locale)} left'
                                : '${Formatters.formatCurrency(remaining.abs(), locale)} over',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: remaining >= 0 ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade200,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(progress * 100).round()}% used',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              );
            }),
          const SizedBox(height: 16),
          const Text(
            'Top expense categories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (topExpenseCategories.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No spending recorded for this month yet.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            ...topExpenseCategories.take(5).map((entry) {
              final category = categoryProvider.getCategoryById(entry.key);
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: category != null
                      ? Color(category.colorValue).withValues(alpha: 0.15)
                      : Colors.grey.shade200,
                  child: Text(category?.icon ?? '•'),
                ),
                title: Text(category?.name ?? entry.key),
                trailing: Text(
                  Formatters.formatCurrency(entry.value, locale),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final IconData icon;
  final Locale? locale;
  final bool fullWidth;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
    required this.locale,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            Formatters.formatCurrency(value, locale),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}