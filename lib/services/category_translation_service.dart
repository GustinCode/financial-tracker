import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/category_model.dart';

class CategoryTranslationService {
  // Mapeamento de IDs de categorias para chaves de tradução
  static String getCategoryTranslationKey(String categoryId) {
    return categoryId;
  }

  // Traduz o nome da categoria baseado no locale atual
  static String translateCategoryName(Category category, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return category.name;

    // Mapeamento de IDs para traduções
    switch (category.id) {
      // Income categories
      case 'income_salary':
        return l10n.categorySalary;
      case 'income_sales':
        return l10n.categorySales;
      case 'income_investments':
        return l10n.categoryInvestments;
      case 'income_gifts':
        return l10n.categoryGifts;
      case 'income_other':
        return l10n.categoryOtherIncome;

      // Expense categories
      case 'expense_food':
        return l10n.categoryFood;
      case 'expense_transport':
        return l10n.categoryTransport;
      case 'expense_housing':
        return l10n.categoryHousing;
      case 'expense_health':
        return l10n.categoryHealth;
      case 'expense_education':
        return l10n.categoryEducation;
      case 'expense_leisure':
        return l10n.categoryLeisure;
      case 'expense_shopping':
        return l10n.categoryShopping;
      case 'expense_bills':
        return l10n.categoryBills;
      case 'expense_other':
        return l10n.categoryOtherExpense;

      default:
        // Se não for uma categoria padrão, retorna o nome original
        return category.name;
    }
  }
}
