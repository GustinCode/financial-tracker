import 'package:flutter/material.dart';
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saldo Atual',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              Formatters.formatCurrency(balance),
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
                  'Receitas',
                  totalIncome,
                  AppConstants.incomeColor,
                  Icons.trending_up,
                ),
                _buildInfoCard(
                  context,
                  'Despesas',
                  totalExpenses,
                  AppConstants.expenseColor,
                  Icons.trending_down,
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
          Formatters.formatCurrency(value),
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




