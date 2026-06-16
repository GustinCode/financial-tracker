import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/budget_model.dart';
import '../providers/budget_provider.dart';
import '../providers/category_provider.dart';
import '../services/category_translation_service.dart';
import '../views/budgets_view.dart';

class BudgetSummarySection extends StatelessWidget {
  const BudgetSummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    final budgetProvider = context.watch<BudgetProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final l10n = AppLocalizations.of(context)!;

    if (!budgetProvider.isCurrentMonth || budgetProvider.budgets.isEmpty) {
      return const SizedBox.shrink();
    }

    final progressList = budgetProvider.getAllProgress();
    final alertItems = progressList
        .where((p) => p.status != BudgetStatus.ok)
        .take(3)
        .toList();
    final previewItems = alertItems.isNotEmpty
        ? alertItems
        : progressList.take(2).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.monthlyBudgets,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BudgetsView(),
                        ),
                      );
                    },
                    child: Text(l10n.viewAll),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...previewItems.map((progress) {
                final category =
                    categoryProvider.getCategoryById(progress.budget.categoryId);
                final color = _statusColor(progress.status);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (category != null) ...[
                            Text(category.icon),
                            const SizedBox(width: 6),
                          ],
                          Expanded(
                            child: Text(
                              category != null
                                  ? CategoryTranslationService
                                      .translateCategoryName(category, context)
                                  : progress.budget.categoryId,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          Text(
                            '${progress.percentage.toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: color,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (progress.percentage / 100).clamp(0.0, 1.0),
                          minHeight: 6,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(BudgetStatus status) {
    switch (status) {
      case BudgetStatus.ok:
        return Colors.green;
      case BudgetStatus.warning:
        return Colors.orange;
      case BudgetStatus.exceeded:
        return Colors.red;
    }
  }
}
