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
