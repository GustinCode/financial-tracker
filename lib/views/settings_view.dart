import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/transaction_provider.dart';
import '../services/localization_service.dart';
import 'categories_view.dart';

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

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.read<TransactionProvider>();
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
            subtitle: const Text('0.0.4'),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: LocalizationService.supportedLocales.map((locale) {
            return RadioListTile<Locale>(
              title: Text(LocalizationService.getDisplayName(locale, context)),
              value: locale,
              groupValue: _selectedLocale,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLocale = value;
                  });
                  widget.onLocaleSelected(value);
                }
              },
            );
          }).toList(),
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
