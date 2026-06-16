import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/formatters.dart';
import '../utils/constants.dart';

class BalanceDisplay extends StatelessWidget {
  final double balance;
  final double totalIncome;
  final double totalExpenses;

  const BalanceDisplay({
    super.key,
    required this.balance,
    required this.totalIncome,
    required this.totalExpenses,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Formatters.getLocaleFromContext(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.currentBalance,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              Formatters.formatCurrency(balance, locale),
              style: TextStyle(
                fontSize: 30,
                height: 1.05,
                fontWeight: FontWeight.w700,
                color: balance >= 0
                    ? AppConstants.incomeColor
                    : AppConstants.expenseColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildInfoTile(
                    context,
                    l10n.incomesLabel,
                    totalIncome,
                    AppConstants.incomeColor,
                    Icons.trending_up,
                    locale,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoTile(
                    context,
                    l10n.expensesLabel,
                    totalExpenses,
                    AppConstants.expenseColor,
                    Icons.trending_down,
                    locale,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    String label,
    double value,
    Color color,
    IconData icon,
    Locale? locale,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
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
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            Formatters.formatCurrency(value, locale),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}







