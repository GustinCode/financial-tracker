import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';
import '../providers/category_provider.dart';
import '../utils/formatters.dart';
import 'add_transaction_view.dart';

class InputDataView extends StatefulWidget {
  const InputDataView({super.key});

  @override
  State<InputDataView> createState() => _InputDataViewState();
}

class _InputDataViewState extends State<InputDataView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final categoryProvider = context.watch<CategoryProvider>();

    final transactions = transactionProvider.transactions;
    final totalIncome = transactionProvider.totalIncome;
    final totalExpenses = transactionProvider.totalExpenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lançamentos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: transactions.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum lançamento ainda.\nUse o botão abaixo para adicionar.',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      // Mostra o mais recente no topo
                      final transaction =
                          transactions[transactions.length - 1 - index];
                      final category = categoryProvider
                          .getCategoryById(transaction.categoryId);
                      final isIncome =
                          transaction.type == TransactionType.income;

                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isIncome
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            child: Text(
                              category?.icon ?? (isIncome ? '⬆️' : '⬇️'),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          title: Text(transaction.title),
                          subtitle: Text(
                            '${category?.name ?? ''} • ${Formatters.formatDate(transaction.date)}',
                          ),
                          trailing: Text(
                            '${isIncome ? '+' : '-'} ${transaction.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isIncome ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              12 + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Receitas:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      totalIncome.toStringAsFixed(2),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Despesas:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      totalExpenses.toStringAsFixed(2),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddTransactionView(),
                      ),
                    );
                    if (context.mounted) {
                      await context
                          .read<TransactionProvider>()
                          .loadTransactions();
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar Receita/Despesa'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

