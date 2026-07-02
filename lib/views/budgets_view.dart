<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/budget_model.dart';
import '../providers/budget_provider.dart';
import '../providers/category_provider.dart';
import '../providers/transaction_provider.dart';
import '../utils/formatters.dart';
import '../widgets/budget_progress_card.dart';
import 'add_budget_view.dart';

class BudgetsView extends StatefulWidget {
  const BudgetsView({super.key});

  @override
  State<BudgetsView> createState() => _BudgetsViewState();
}

class _BudgetsViewState extends State<BudgetsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BudgetProvider>().loadBudgets();
    });
  }

  String _formatMonthYear(BuildContext context, DateTime date) {
    final locale = Formatters.getLocaleFromContext(context);
    return Formatters.formatMonthYear(date, locale);
  }

  @override
  Widget build(BuildContext context) {
    final budgetProvider = context.watch<BudgetProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final l10n = AppLocalizations.of(context)!;
    final progressList = budgetProvider.getAllProgress();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<TransactionProvider>().loadTransactions();
          await budgetProvider.loadBudgets();
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _MonthSelector(
                label: _formatMonthYear(context, budgetProvider.selectedMonth),
                isCurrentMonth: budgetProvider.isCurrentMonth,
                onPrevious: () => budgetProvider.goToPreviousMonth(),
                onNext: () => budgetProvider.goToNextMonth(),
                onToday: () => budgetProvider.goToCurrentMonth(),
              ),
            ),
            if (progressList.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.pie_chart_outline,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noBudgetsForMonth,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.noBudgetsHint,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final progress = progressList[index];
                      final category = categoryProvider
                          .getCategoryById(progress.budget.categoryId);

                      return BudgetProgressCard(
                        progress: progress,
                        category: category,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddBudgetView(
                                budget: progress.budget,
                              ),
                            ),
                          );
                          if (context.mounted) {
                            budgetProvider.loadBudgets();
                          }
                        },
                        onDelete: () => _confirmDeleteBudget(
                          context,
                          progress.budget,
                        ),
                      );
                    },
                    childCount: progressList.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddBudgetView(),
            ),
          );
          if (context.mounted) {
            budgetProvider.loadBudgets();
          }
        },
        icon: const Icon(Icons.add),
        label: Text(l10n.addBudget),
      ),
    );
  }

  void _confirmDeleteBudget(BuildContext context, Budget budget) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteBudget),
        content: Text(l10n.confirmDeleteBudget),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              await context.read<BudgetProvider>().deleteBudget(budget.id);
              if (dialogContext.mounted) {
                Navigator.pop(dialogContext);
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  final String label;
  final bool isCurrentMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;

  const _MonthSelector({
    required this.label,
    required this.isCurrentMonth,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            onPressed: onPrevious,
            icon: const Icon(Icons.chevron_left),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!isCurrentMonth)
                  TextButton(
                    onPressed: onToday,
                    child: Text(l10n.currentMonth),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
=======
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/budget_model.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../providers/budget_provider.dart';
import '../providers/category_provider.dart';
import '../utils/date_helpers.dart';
import '../utils/formatters.dart';

class BudgetsView extends StatefulWidget {
  const BudgetsView({super.key});

  @override
  State<BudgetsView> createState() => _BudgetsViewState();
}

class _BudgetsViewState extends State<BudgetsView> {
  DateTime _selectedMonth = monthStart(DateTime.now());

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final budgetProvider = context.watch<BudgetProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final locale = Formatters.getLocaleFromContext(context);

    final monthBudgets = budgetProvider.getBudgetsForMonth(monthKeyFromDate(_selectedMonth));
    final expenseCategories = categoryProvider.getCategoriesByType(TransactionType.expense);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: expenseCategories.isEmpty
            ? null
            : () async {
                await _showBudgetDialog(
                  context,
                  expenseCategories: expenseCategories,
                  monthKey: monthKeyFromDate(_selectedMonth),
                );
              },
        icon: const Icon(Icons.add),
        label: const Text('Add Budget'),
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
                formatMonthLabel(_selectedMonth, locale),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => _changeMonth(1),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (monthBudgets.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.savings_outlined, size: 48, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'No budgets for this month yet',
                      style: TextStyle(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Create a budget to track spending by category.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ...monthBudgets.map((budget) {
              final category = categoryProvider.getCategoryById(budget.categoryId);
              return _BudgetCard(
                budget: budget,
                category: category,
                onEdit: () async {
                  await _showBudgetDialog(
                    context,
                    expenseCategories: expenseCategories,
                    monthKey: budget.monthKey,
                    existingBudget: budget,
                  );
                },
                onDelete: () => budgetProvider.deleteBudget(budget.id),
              );
            }),
        ],
      ),
    );
  }

  Future<void> _showBudgetDialog(
    BuildContext context, {
    required List<Category> expenseCategories,
    required String monthKey,
    Budget? existingBudget,
  }) async {
    final budgetProvider = context.read<BudgetProvider>();
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController(
      text: existingBudget?.limitAmount.toStringAsFixed(2) ?? '',
    );
    Category? selectedCategory = existingBudget == null
        ? (expenseCategories.isNotEmpty ? expenseCategories.first : null)
        : expenseCategories.firstWhere((category) => category.id == existingBudget.categoryId);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(existingBudget == null ? 'Add Budget' : 'Edit Budget'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<Category>(
                  initialValue: selectedCategory,
                  items: expenseCategories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    selectedCategory = value;
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextFormField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Limit amount'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    final amount = double.tryParse((value ?? '').replaceAll(',', '.'));
                    if (amount == null || amount <= 0) {
                      return 'Enter a valid amount';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Month: $monthKey'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate() || selectedCategory == null) {
                  return;
                }

                await budgetProvider.saveBudget(
                  id: existingBudget?.id,
                  categoryId: selectedCategory!.id,
                  limitAmount: double.parse(amountController.text.replaceAll(',', '.')),
                  monthKey: monthKey,
                );

                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final Budget budget;
  final Category? category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BudgetCard({
    required this.budget,
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(category?.icon ?? '💰'),
        ),
        title: Text(category?.name ?? 'Unknown category'),
        subtitle: Text('Budget limit: ${budget.limitAmount.toStringAsFixed(2)}'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}
>>>>>>> 0341b2aace011fd5299e50e2816cd34a66c588a9
