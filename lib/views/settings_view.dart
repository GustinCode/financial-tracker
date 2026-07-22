import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/transaction_provider.dart';
import '../providers/budget_provider.dart';
import '../services/localization_service.dart';
import 'categories_view.dart';
import 'budgets_view.dart';
import '../providers/category_provider.dart';
import '../services/csv_export_service.dart';

class SettingsView extends StatefulWidget {
  final VoidCallback? onLocaleChanged;

  const SettingsView({super.key, this.onLocaleChanged});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  void _showLanguageSelector(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);

    showDialog(
      context: context,
      builder: (dialogContext) => _LanguageSelectorDialog(
        currentLocale: currentLocale,
        onLocaleSelected: (selectedLocale) async {
          await LocalizationService.saveLocale(selectedLocale);
          if (dialogContext.mounted) {
            Navigator.pop(dialogContext);
            // Notify parent to rebuild
            widget.onLocaleChanged?.call();
            // Force rebuild this widget
            if (mounted) {
              setState(() {});
            }
          }
        },
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final transactionProvider = context.read<TransactionProvider>();
    final categoryProvider = context.read<CategoryProvider>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.exportCsvTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.exportCsvPeriodAll),
              onTap: () => _exportCsv(dialogContext, CsvExportPeriod.all, transactionProvider, categoryProvider, l10n),
            ),
            ListTile(
              title: Text(l10n.exportCsvPeriodCurrentMonth),
              onTap: () => _exportCsv(dialogContext, CsvExportPeriod.currentMonth, transactionProvider, categoryProvider, l10n),
            ),
            ListTile(
              title: Text(l10n.exportCsvPeriodLastMonth),
              onTap: () => _exportCsv(dialogContext, CsvExportPeriod.lastMonth, transactionProvider, categoryProvider, l10n),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  Future<void> _exportCsv(
    BuildContext dialogContext, 
    CsvExportPeriod period, 
    TransactionProvider transactionProvider,
    CategoryProvider categoryProvider,
    AppLocalizations l10n,
  ) async {
    Navigator.pop(dialogContext); // Close dialog

    try {
      final filteredTransactions = CsvExportService.filterByPeriod(
        transactionProvider.transactions,
        period,
      );

      if (filteredTransactions.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.exportCsvNoTransactions)),
          );
        }
        return;
      }

      final categoryNames = {
        for (var cat in categoryProvider.categories) cat.id: cat.name,
      };

      final csvContent = CsvExportService.generateCsv(
        transactions: filteredTransactions,
        categoryNames: categoryNames,
        labels: CsvExportColumnLabels(
          id: 'ID',
          title: l10n.title,
          type: 'Type',
          amount: l10n.amount,
          category: l10n.category,
          date: l10n.date,
          description: l10n.description,
        ),
        incomeLabel: l10n.exportCsvIncomeType,
        expenseLabel: l10n.exportCsvExpenseType,
      );

      final file = await CsvExportService.writeCsvToTempFile(csvContent);
      await CsvExportService.shareCsvFile(
        file,
        shareSubject: l10n.exportCsvTitle,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.exportCsvSuccess)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.exportCsvFailed)),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.read<TransactionProvider>();
    final budgetProvider = context.read<BudgetProvider>();
    final l10n = AppLocalizations.of(context)!;
    // Force rebuild when locale changes
    final currentLocale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.aboutApp,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.version),
            subtitle: const Text('0.0.7'),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.language,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(LocalizationService.getDisplayName(
              currentLocale,
              context,
            )),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showLanguageSelector(context);
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.categories,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: Text(l10n.manageCategories),
            subtitle: Text(l10n.createAndEditCategories),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CategoriesView(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.pie_chart_outline),
            title: Text(l10n.manageBudgets),
            subtitle: Text(l10n.manageBudgetsDescription),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BudgetsView(),
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.download_outlined),
            title: Text(l10n.exportToCsv),
            subtitle: Text(l10n.exportToCsvDescription),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showExportDialog(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: Text(l10n.clearAllData),
            subtitle: Text(l10n.clearAllDataDescription),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.clearAllData),
                  content: Text(l10n.confirmClearData),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.cancel),
                    ),
                    TextButton(
                      onPressed: () async {
                        final transactions = transactionProvider.transactions;
                        for (var transaction in transactions) {
                          await transactionProvider
                              .deleteTransaction(transaction.id);
                        }
                        await budgetProvider.deleteAllBudgets();
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.allDataDeleted),
                            ),
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: Text(l10n.deleteAll),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              l10n.information,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.privacyPolicy),
            subtitle: Text(l10n.privacyPolicyDescription),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.privacyPolicy),
                  content: Text(l10n.privacyPolicyContent),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(l10n.help),
            subtitle: Text(l10n.helpDescription),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(l10n.help),
                  content: SingleChildScrollView(
                    child: Text(l10n.helpContent),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _LanguageSelectorDialog extends StatefulWidget {
  final Locale currentLocale;
  final ValueChanged<Locale> onLocaleSelected;

  const _LanguageSelectorDialog({
    required this.currentLocale,
    required this.onLocaleSelected,
  });

  @override
  State<_LanguageSelectorDialog> createState() =>
      _LanguageSelectorDialogState();
}

class _LanguageSelectorDialogState extends State<_LanguageSelectorDialog> {
  late Locale _selectedLocale;

  @override
  void initState() {
    super.initState();
    _selectedLocale = widget.currentLocale;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.selectLanguage),
      content: SingleChildScrollView(
        child: RadioGroup<Locale>(
          groupValue: _selectedLocale,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedLocale = value;
              });
              widget.onLocaleSelected(value);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: LocalizationService.supportedLocales.map((locale) {
              return RadioListTile<Locale>(
                title:
                    Text(LocalizationService.getDisplayName(locale, context)),
                value: locale,
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ],
    );
  }
}
