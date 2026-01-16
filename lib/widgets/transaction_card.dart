import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';
import '../utils/formatters.dart';
import '../utils/constants.dart';
import '../services/category_translation_service.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final Category? category;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionCard({
    super.key,
    required this.transaction,
    this.category,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final categoryColor = category != null
        ? Color(category!.colorValue)
        : (isIncome ? AppConstants.incomeColor : AppConstants.expenseColor);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: categoryColor.withValues(alpha: 0.2),
          child: Text(
            category?.icon ?? (isIncome ? '💰' : '💸'),
            style: const TextStyle(fontSize: 20),
          ),
        ),
        title: Text(
          transaction.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            if (category != null)
              Text(
                CategoryTranslationService.translateCategoryName(category!, context),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            Text(
              Formatters.formatDate(transaction.date, Formatters.getLocaleFromContext(context)),
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isIncome ? '+' : '-'}${Formatters.formatCurrency(transaction.amount, Formatters.getLocaleFromContext(context))}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isIncome
                    ? AppConstants.incomeColor
                    : AppConstants.expenseColor,
              ),
            ),
          ],
        ),
        onTap: onTap,
        onLongPress: onDelete != null
            ? () {
                final l10n = AppLocalizations.of(context)!;
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(l10n.deleteTransaction),
                    content: Text(l10n.confirmDeleteTransaction),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l10n.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          onDelete!();
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: Text(l10n.delete),
                      ),
                    ],
                  ),
                );
              }
            : null,
      ),
    );
  }
}
