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
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              Formatters.formatCurrency(balance, locale),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: balance >= 0 ? AppConstants.incomeColor : AppConstants.expenseColor,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoCard(
                  context,
                  l10n.incomesLabel,
                  totalIncome,
                  AppConstants.incomeColor,
                  Icons.trending_up,
                  locale,
                ),
                _buildInfoCard(
                  context,
                  l10n.expensesLabel,
                  totalExpenses,
                  AppConstants.expenseColor,
                  Icons.trending_down,
                  locale,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context,
    String label,
    double value,
    Color color,
    IconData icon,
    Locale? locale,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          Formatters.formatCurrency(value, locale),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}







