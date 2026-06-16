import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/budget_model.dart';
import '../models/category_model.dart';
import '../services/category_translation_service.dart';
import '../utils/formatters.dart';

class BudgetProgressCard extends StatelessWidget {
  final BudgetProgress progress;
  final Category? category;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const BudgetProgressCard({
    super.key,
    required this.progress,
    this.category,
    this.onTap,
    this.onDelete,
  });

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Formatters.getLocaleFromContext(context);
    final statusColor = _statusColor(progress.status);
    final clampedProgress =
        (progress.percentage / 100).clamp(0.0, 1.0).toDouble();
    final categoryName = category != null
        ? CategoryTranslationService.translateCategoryName(category!, context)
        : l10n.category;
    final categoryIcon = category?.icon ?? '📦';

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: category != null
                          ? Color(category!.colorValue)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        categoryIcon,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${Formatters.formatCurrency(progress.spent, locale)} / ${Formatters.formatCurrency(progress.budget.limitAmount, locale)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      color: Colors.grey,
                      onPressed: onDelete,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: clampedProgress,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${progress.percentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                  Text(
                    _statusLabel(l10n, progress.status),
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              if (progress.remaining >= 0 && progress.status != BudgetStatus.exceeded)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    l10n.budgetRemaining(
                      Formatters.formatCurrency(progress.remaining, locale),
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                )
              else if (progress.status == BudgetStatus.exceeded)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    l10n.budgetOverBy(
                      Formatters.formatCurrency(
                        progress.spent - progress.budget.limitAmount,
                        locale,
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(AppLocalizations l10n, BudgetStatus status) {
    switch (status) {
      case BudgetStatus.ok:
        return l10n.budgetStatusOk;
      case BudgetStatus.warning:
        return l10n.budgetStatusWarning;
      case BudgetStatus.exceeded:
        return l10n.budgetStatusExceeded;
    }
  }
}
