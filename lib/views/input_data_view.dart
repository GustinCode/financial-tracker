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
  final List<Transaction> _pendingTransactions = [];

  void _addPendingTransaction(Transaction transaction) {
    setState(() {
      _pendingTransactions.insert(0, transaction);
    });
  }

  void _removePendingTransaction(int index) {
    setState(() {
      _pendingTransactions.removeAt(index);
    });
  }

  double get _pendingTotalIncome {
    return _pendingTransactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double get _pendingTotalExpenses {
    return _pendingTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  Future<void> _confirmTransactions() async {
    if (_pendingTransactions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhuma transação para confirmar'),
        ),
      );
      return;
    }

    final transactionProvider = context.read<TransactionProvider>();
    final count = _pendingTransactions.length;

    for (final transaction in _pendingTransactions) {
      await transactionProvider.addTransaction(transaction);
    }

    setState(() {
      _pendingTransactions.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$count transação(ões) confirmada(s) com sucesso!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lançamentos'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _pendingTransactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt_long,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum lançamento ainda.\nUse o botão abaixo para adicionar.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _pendingTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _pendingTransactions[index];
                      final category = categoryProvider
                          .getCategoryById(transaction.categoryId);
                      final isIncome =
                          transaction.type == TransactionType.income;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${isIncome ? '+' : '-'} ${transaction.amount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isIncome ? Colors.green : Colors.red,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                color: Colors.red,
                                onPressed: () {
                                  _removePendingTransaction(index);
                                },
                              ),
                            ],
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
              16,
              16,
              16 + MediaQuery.of(context).padding.bottom,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.trending_up,
                                color: Colors.green[700],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Total Receitas:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _pendingTotalIncome.toStringAsFixed(2),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Divider(
                        height: 1,
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.trending_down,
                                color: Colors.red[700],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Total Despesas:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _pendingTotalExpenses.toStringAsFixed(2),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.red[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Divider(
                        height: 1,
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Saldo:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            (_pendingTotalIncome - _pendingTotalExpenses)
                                .toStringAsFixed(2),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: (_pendingTotalIncome - _pendingTotalExpenses) >= 0
                                  ? Colors.green[700]
                                  : Colors.red[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final transaction = await Navigator.push<Transaction>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddTransactionView(
                                returnTransactionOnly: true,
                              ),
                            ),
                          );
                          if (transaction != null && mounted) {
                            _addPendingTransaction(transaction);
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar Receita/Despesa'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: _pendingTransactions.isEmpty
                          ? null
                          : _confirmTransactions,
                      icon: const Icon(Icons.check),
                      label: Text(
                        'Confirmar (${_pendingTransactions.length})',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
