import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/category_provider.dart';
import '../providers/transaction_provider.dart';
import '../services/category_translation_service.dart';
import '../widgets/balance_display.dart';
import '../widgets/transaction_card.dart';
import 'add_transaction_view.dart';
import 'dashboard_view.dart';
import 'history_view.dart';
import 'input_data_view.dart';
import 'settings_view.dart';

class HomeView extends StatefulWidget {
  final VoidCallback? onLocaleChanged;

  const HomeView({super.key, this.onLocaleChanged});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              title: Text(l10n.appTitle),
              elevation: 0,
              actions: [
                IconButton(
                  tooltip: l10n.newTransaction,
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const InputDataView()),
                    );
                    if (context.mounted) {
                      context.read<TransactionProvider>().loadTransactions();
                    }
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            )
          : null,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const _OverviewTab(),
          const DashboardView(),
          const HistoryView(),
          SettingsView(onLocaleChanged: widget.onLocaleChanged),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(icon: const Icon(Icons.home), label: l10n.home),
          BottomNavigationBarItem(icon: const Icon(Icons.insights_outlined), label: l10n.dashboard),
          BottomNavigationBarItem(icon: const Icon(Icons.history), label: l10n.history),
          BottomNavigationBarItem(icon: const Icon(Icons.settings), label: l10n.settings),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InputDataView()),
                );
                if (context.mounted) {
                  context.read<TransactionProvider>().loadTransactions();
                }
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.newTransaction),
            )
          : null,
    );
  }
}

class _OverviewTab extends StatefulWidget {
  const _OverviewTab();

  @override
  State<_OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<_OverviewTab> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final categoryProvider = context.watch<CategoryProvider>();
    final l10n = AppLocalizations.of(context)!;

    final categoriesWithTransactions = <String, int>{};
    for (final transaction in transactionProvider.transactions) {
      categoriesWithTransactions.update(
        transaction.categoryId,
        (value) => value + 1,
        ifAbsent: () => 1,
      );
    }

    final categoriesToDisplay = categoryProvider.categories
        .where((category) => categoriesWithTransactions.containsKey(category.id))
        .toList();

    final filteredTransactions = _selectedCategoryId == null
        ? transactionProvider.transactions
        : transactionProvider.transactions
            .where((transaction) => transaction.categoryId == _selectedCategoryId)
            .toList();

    return RefreshIndicator(
      onRefresh: () async {
        await transactionProvider.loadTransactions();
        setState(() {
          _selectedCategoryId = null;
        });
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BalanceDisplay(
                balance: transactionProvider.balance,
                totalIncome: transactionProvider.totalIncome,
                totalExpenses: transactionProvider.totalExpenses,
              ),
            ),
          ),
          if (transactionProvider.transactions.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      l10n.categories,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilterChip(
                          label: Text(l10n.all),
                          selected: _selectedCategoryId == null,
                          onSelected: (_) {
                            setState(() {
                              _selectedCategoryId = null;
                            });
                          },
                          showCheckmark: false,
                        ),
                        ...categoriesToDisplay.map((category) {
                          final isSelected = _selectedCategoryId == category.id;
                          final transactionCount = categoriesWithTransactions[category.id] ?? 0;
                          return FilterChip(
                            avatar: CircleAvatar(
                              backgroundColor: Color(category.colorValue).withValues(alpha: 0.14),
                              child: Text(category.icon, style: const TextStyle(fontSize: 12)),
                            ),
                            label: Text('${CategoryTranslationService.translateCategoryName(category, context)} ($transactionCount)'),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                _selectedCategoryId = isSelected ? null : category.id;
                              });
                            },
                            showCheckmark: false,
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          if (transactionProvider.transactions.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Icon(Icons.receipt_long, size: 44, color: Color(0xFF14B8A6)),
                        const SizedBox(height: 12),
                        Text(
                          l10n.noTransactionsRegistered,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.tapToAdd,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 14),
                        FilledButton.icon(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const InputDataView()),
                            );
                            if (context.mounted) {
                              context.read<TransactionProvider>().loadTransactions();
                            }
                          },
                          icon: const Icon(Icons.add),
                          label: Text(l10n.newTransaction),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.recentTransactions,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (_selectedCategoryId != null)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedCategoryId = null;
                        });
                      },
                      icon: const Icon(Icons.clear, size: 18),
                      label: Text(l10n.all),
                    ),
                ],
              ),
            ),
          ),
          if (filteredTransactions.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.receipt_long, size: 64, color: Color(0xFF14B8A6)),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noTransactionsRegistered,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.tapToAdd,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final transaction = filteredTransactions[index];
                  final category = categoryProvider.getCategoryById(transaction.categoryId);
                  return TransactionCard(
                    transaction: transaction,
                    category: category,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddTransactionView(transaction: transaction),
                        ),
                      );
                      if (context.mounted) {
                        transactionProvider.loadTransactions();
                        setState(() {
                          _selectedCategoryId = null;
                        });
                      }
                    },
                    onDelete: () {
                      transactionProvider.deleteTransaction(transaction.id);
                    },
                  );
                },
                childCount: filteredTransactions.length > 5 ? 5 : filteredTransactions.length,
              ),
            ),
        ],
      ),
    );
  }
}
