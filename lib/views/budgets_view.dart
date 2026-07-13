import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/budget_model.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../l10n/app_localizations.dart';
import '../providers/budget_provider.dart';
import '../providers/category_provider.dart';
import '../services/category_translation_service.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final locale = Formatters.getLocaleFromContext(context);

    final monthBudgets = budgetProvider.getBudgetsForMonth(monthKeyFromDate(_selectedMonth));
    final expenseCategories = categoryProvider.getCategoriesByType(TransactionType.expense);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.budgets),
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
        label: Text(l10n.addBudget),
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.savings_outlined, size: 48, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text(
                      l10n.noBudgetsForMonth,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.noBudgetsHint,
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
                l10n: l10n,
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
    final l10n = AppLocalizations.of(context)!;
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
          title: Text(existingBudget == null ? l10n.addBudget : l10n.editBudget),
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
                  decoration: InputDecoration(labelText: l10n.category),
                ),
                TextFormField(
                  controller: amountController,
                  decoration: InputDecoration(labelText: l10n.monthlyLimit),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    final amount = double.tryParse((value ?? '').replaceAll(',', '.'));
                    if (amount == null || amount <= 0) {
                      return l10n.pleaseEnterValidAmount;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(l10n.monthLabel(monthKey)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancel),
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
              child: Text(l10n.saveBudget),
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
  final AppLocalizations l10n;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BudgetCard({
    required this.budget,
    required this.category,
    required this.l10n,
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
        title: Text(category != null ? CategoryTranslationService.translateCategoryName(category!, context) : l10n.unknownCategory),
        subtitle: Text(l10n.budgetLimit(budget.limitAmount.toStringAsFixed(2))),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') onEdit();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: 'edit', child: Text(l10n.editTransaction)),
            PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
          ],
        ),
      ),
    );
  }
}