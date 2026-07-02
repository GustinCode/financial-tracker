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