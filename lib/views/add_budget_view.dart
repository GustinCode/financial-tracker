import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/budget_model.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../providers/budget_provider.dart';
import '../providers/category_provider.dart';
import '../services/category_translation_service.dart';
import '../widgets/category_picker.dart';

class AddBudgetView extends StatefulWidget {
  final Budget? budget;

  const AddBudgetView({super.key, this.budget});

  @override
  State<AddBudgetView> createState() => _AddBudgetViewState();
}

class _AddBudgetViewState extends State<AddBudgetView> {
  final _formKey = GlobalKey<FormState>();
  final _limitController = TextEditingController();
  Category? _selectedCategory;
  bool _isSaving = false;

  bool get _isEditing => widget.budget != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _limitController.text = widget.budget!.limitAmount.toStringAsFixed(2);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final category = context
            .read<CategoryProvider>()
            .getCategoryById(widget.budget!.categoryId);
        if (category != null) {
          setState(() => _selectedCategory = category);
        }
      });
    }
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null && !_isEditing) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.pleaseSelectCategory),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    final budgetProvider = context.read<BudgetProvider>();
    final limit = double.parse(_limitController.text.replaceAll(',', '.'));

    try {
      if (_isEditing) {
        await budgetProvider.updateBudget(widget.budget!, limit);
      } else {
        await budgetProvider.addBudget(
          categoryId: _selectedCategory!.id,
          limitAmount: limit,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? AppLocalizations.of(context)!.budgetUpdated
                  : AppLocalizations.of(context)!.budgetCreated,
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.budgetAlreadyExists),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final budgetProvider = context.watch<BudgetProvider>();
    final existingCategoryIds = budgetProvider.budgets
        .where((b) => !_isEditing || b.id != widget.budget!.id)
        .map((b) => b.categoryId)
        .toSet();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editBudget : l10n.addBudget),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            if (!_isEditing)
              CategoryPicker(
                transactionType: TransactionType.expense,
                label: l10n.categoryRequired,
                initialCategory: _selectedCategory,
                onCategorySelected: (category) {
                  if (existingCategoryIds.contains(category.id)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.budgetAlreadyExists)),
                    );
                    return;
                  }
                  setState(() => _selectedCategory = category);
                },
              )
            else
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: _selectedCategory != null
                    ? Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(_selectedCategory!.colorValue),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            _selectedCategory!.icon,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      )
                    : null,
                title: Text(l10n.category),
                subtitle: Text(
                  _selectedCategory != null
                      ? CategoryTranslationService.translateCategoryName(
                          _selectedCategory!,
                          context,
                        )
                      : '',
                ),
              ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _limitController,
              decoration: InputDecoration(
                labelText: l10n.monthlyLimit,
                hintText: l10n.monthlyLimitHint,
                border: const OutlineInputBorder(),
                prefixText: 'R\$ ',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.pleaseEnterAmount;
                }
                final parsed = double.tryParse(value.replaceAll(',', '.'));
                if (parsed == null || parsed <= 0) {
                  return l10n.pleaseEnterValidAmount;
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isEditing ? l10n.updateBudget : l10n.saveBudget),
            ),
          ],
        ),
      ),
    );
  }
}
