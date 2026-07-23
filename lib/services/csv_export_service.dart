import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/transaction_model.dart';

enum CsvExportPeriod { all, currentMonth, lastMonth }

class CsvExportColumnLabels {
  final String id;
  final String title;
  final String type;
  final String amount;
  final String category;
  final String date;
  final String description;

  const CsvExportColumnLabels({
    required this.id,
    required this.title,
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
    required this.description,
  });
}

class CsvExportService {
  static const defaultColumnLabels = CsvExportColumnLabels(
    id: 'ID',
    title: 'Title',
    type: 'Type',
    amount: 'Amount',
    category: 'Category',
    date: 'Date',
    description: 'Description',
  );

  static List<Transaction> filterByPeriod(
    List<Transaction> transactions,
    CsvExportPeriod period, {
    DateTime? referenceDate,
  }) {
    if (period == CsvExportPeriod.all) {
      return List<Transaction>.from(transactions);
    }

    final now = referenceDate ?? DateTime.now();
    final DateTime start;
    final DateTime end;

    if (period == CsvExportPeriod.currentMonth) {
      start = DateTime(now.year, now.month, 1);
      end = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999);
    } else {
      final lastMonth = DateTime(now.year, now.month - 1);
      start = DateTime(lastMonth.year, lastMonth.month, 1);
      end = DateTime(lastMonth.year, lastMonth.month + 1, 0, 23, 59, 59, 999);
    }

    return transactions.where((transaction) {
      return !transaction.date.isBefore(start) &&
          !transaction.date.isAfter(end);
    }).toList();
  }

  static String generateCsv({
    required List<Transaction> transactions,
    required Map<String, String> categoryNames,
    CsvExportColumnLabels labels = defaultColumnLabels,
    String incomeLabel = 'income',
    String expenseLabel = 'expense',
  }) {
    final buffer = StringBuffer()
      ..writeln([
        labels.id,
        labels.title,
        labels.type,
        labels.amount,
        labels.category,
        labels.date,
        labels.description,
      ].map(_escapeCsvField).join(','));

    final sorted = List<Transaction>.from(transactions)
      ..sort((a, b) {
        final dateCompare = a.date.compareTo(b.date);
        if (dateCompare != 0) {
          return dateCompare;
        }
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      });

    for (final transaction in sorted) {
      final typeLabel = transaction.type == TransactionType.income
          ? incomeLabel
          : expenseLabel;
      final categoryName =
          categoryNames[transaction.categoryId] ?? transaction.categoryId;

      buffer.writeln([
        transaction.id,
        transaction.title,
        typeLabel,
        transaction.amount.toStringAsFixed(2),
        categoryName,
        _formatDate(transaction.date),
        transaction.description ?? '',
      ].map(_escapeCsvField).join(','));
    }

    return buffer.toString();
  }

  static String buildFileName({DateTime? timestamp}) {
    final now = timestamp ?? DateTime.now();
    final datePart =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return 'financial_tracker_export_$datePart.csv';
  }

  static Future<File> writeCsvToTempFile(String csvContent,
      {String? fileName}) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/${fileName ?? buildFileName()}');
    await file.writeAsString(csvContent);
    return file;
  }

  static Future<void> shareCsvFile(File file, {String? shareSubject}) async {
    await SharePlus.instance.share(ShareParams(
      files: [XFile(file.path, mimeType: 'text/csv')],
      subject: shareSubject,
    ));
  }

  static String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  static String _escapeCsvField(String value) {
    final needsQuotes = value.contains(',') ||
        value.contains('"') ||
        value.contains('\n') ||
        value.contains('\r');

    final escaped = value.replaceAll('"', '""');
    return needsQuotes ? '"$escaped"' : escaped;
  }
}
