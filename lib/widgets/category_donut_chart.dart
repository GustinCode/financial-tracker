import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/category_model.dart';

class CategoryDonutChart extends StatelessWidget {
  final Map<String, double> expenseByCategory;
  final Category? Function(String categoryId) getCategory;

  const CategoryDonutChart({
    super.key,
    required this.expenseByCategory,
    required this.getCategory,
  });

  @override
  Widget build(BuildContext context) {
    if (expenseByCategory.isEmpty) {
      return const SizedBox.shrink();
    }
    final totalExpenses =
        expenseByCategory.values.fold(0.0, (sum, val) => sum + val);

    final sections = expenseByCategory.entries.map((entry) {
      final category = getCategory(entry.key);
      final Color color = category?.color ?? Colors.grey;

      return PieChartSectionData(
        value: entry.value,
        color: color,
        showTitle: false,
        radius: 16,
      );
    }).toList();

    return SizedBox(
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 50,
              sectionsSpace: 3,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${expenseByCategory.length}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Categorias',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${totalExpenses.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
