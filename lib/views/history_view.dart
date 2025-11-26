import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../models/transaction_model.dart';
import '../widgets/transaction_card.dart';
import '../utils/formatters.dart';
import 'add_transaction_view.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  TransactionType? _filterType;

  List<Transaction> _getFilteredTransactions(List<Transaction> transactions) {
    if (_filterType == null) {
      return transactions;
    }
    return transactions.where((t) => t.type == _filterType).toList();
  }

  Map<DateTime, List<Transaction>> _groupTransactionsByDate(List<Transaction> transactions) {
    final Map<DateTime, List<Transaction>> grouped = {};
    for (var transaction in transactions) {
      final date = DateTime(
        transaction.date.year,
        transaction.date.month,
        transaction.date.day,
      );
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(transaction);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final categoryProvider = context.watch<CategoryProvider>();

    final filteredTransactions = _getFilteredTransactions(transactionProvider.transactions);
    final groupedTransactions = _groupTransactionsByDate(filteredTransactions);
    final sortedDates = groupedTransactions.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        actions: [
          PopupMenuButton<TransactionType?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _filterType = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: null,
                child: Text('Todas'),
              ),
              const PopupMenuItem(
                value: TransactionType.income,
                child: Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Receitas'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: TransactionType.expense,
                child: Row(
                  children: [
                    Icon(Icons.trending_down, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Despesas'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: filteredTransactions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _filterType == null
                        ? 'Nenhuma transação registrada'
                        : _filterType == TransactionType.income
                            ? 'Nenhuma receita registrada'
                            : 'Nenhuma despesa registrada',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await transactionProvider.loadTransactions();
              },
              child: ListView.builder(
                itemCount: sortedDates.length,
                itemBuilder: (context, index) {
                  final date = sortedDates[index];
                  final transactions = groupedTransactions[date]!;
                  final isToday = date.year == DateTime.now().year &&
                      date.month == DateTime.now().month &&
                      date.day == DateTime.now().day;
                  final isYesterday = date.year == DateTime.now().year &&
                      date.month == DateTime.now().month &&
                      date.day == DateTime.now().day - 1;

                  String dateLabel;
                  if (isToday) {
                    dateLabel = 'Hoje';
                  } else if (isYesterday) {
                    dateLabel = 'Ontem';
                  } else {
                    dateLabel = Formatters.formatDate(date);
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          dateLabel,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      ...transactions.map((transaction) {
                        final category =
                            categoryProvider.getCategoryById(transaction.categoryId);
                        return TransactionCard(
                          transaction: transaction,
                          category: category,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddTransactionView(
                                  transaction: transaction,
                                ),
                              ),
                            );
                            if (context.mounted) {
                              transactionProvider.loadTransactions();
                            }
                          },
                          onDelete: () {
                            transactionProvider.deleteTransaction(transaction.id);
                          },
                        );
                      }),
                    ],
                  );
                },
              ),
            ),
    );
  }
}




