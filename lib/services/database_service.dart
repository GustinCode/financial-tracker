import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction_model.dart';
import '../models/category_model.dart';
import '../repositories/category_repository.dart';

class DatabaseService {
  static const String transactionsBoxName = 'transactions';
  static const String categoriesBoxName = 'categories';

  static Future<void> initialize() async {
    // Abrir boxes
    await Hive.openBox<Transaction>(transactionsBoxName);
    await Hive.openBox<Category>(categoriesBoxName);

    // Verificar se já existem categorias padrão
    final categoryBox = Hive.box<Category>(categoriesBoxName);
    if (categoryBox.isEmpty) {
      await _initializeDefaultCategories();
    }
  }

  static Future<void> _initializeDefaultCategories() async {
    final categoryRepository = CategoryRepository();

    // Categorias de Receita
    final incomeCategories = [
      Category(
        id: 'income_salary',
        name: 'Salário',
        type: TransactionType.income,
        colorValue: Colors.green.toARGB32(),
        icon: '💰',
        isDefault: true,
      ),
      Category(
        id: 'income_sales',
        name: 'Vendas',
        type: TransactionType.income,
        colorValue: Colors.lightGreen.toARGB32(),
        icon: '💵',
        isDefault: true,
      ),
      Category(
        id: 'income_investments',
        name: 'Investimentos',
        type: TransactionType.income,
        colorValue: Colors.teal.toARGB32(),
        icon: '📈',
        isDefault: true,
      ),
      Category(
        id: 'income_gifts',
        name: 'Presentes',
        type: TransactionType.income,
        colorValue: Colors.purple.toARGB32(),
        icon: '🎁',
        isDefault: true,
      ),
      Category(
        id: 'income_other',
        name: 'Outras Receitas',
        type: TransactionType.income,
        colorValue: Colors.blueGrey.toARGB32(),
        icon: '💳',
        isDefault: true,
      ),
    ];

    // Categorias de Despesa
    final expenseCategories = [
      Category(
        id: 'expense_food',
        name: 'Alimentação',
        type: TransactionType.expense,
        colorValue: Colors.orange.toARGB32(),
        icon: '🍔',
        isDefault: true,
      ),
      Category(
        id: 'expense_transport',
        name: 'Transporte',
        type: TransactionType.expense,
        colorValue: Colors.blue.toARGB32(),
        icon: '🚗',
        isDefault: true,
      ),
      Category(
        id: 'expense_housing',
        name: 'Moradia',
        type: TransactionType.expense,
        colorValue: Colors.brown.toARGB32(),
        icon: '🏠',
        isDefault: true,
      ),
      Category(
        id: 'expense_health',
        name: 'Saúde',
        type: TransactionType.expense,
        colorValue: Colors.red.toARGB32(),
        icon: '🏥',
        isDefault: true,
      ),
      Category(
        id: 'expense_education',
        name: 'Educação',
        type: TransactionType.expense,
        colorValue: Colors.indigo.toARGB32(),
        icon: '📚',
        isDefault: true,
      ),
      Category(
        id: 'expense_leisure',
        name: 'Lazer',
        type: TransactionType.expense,
        colorValue: Colors.pink.toARGB32(),
        icon: '🎮',
        isDefault: true,
      ),
      Category(
        id: 'expense_shopping',
        name: 'Compras',
        type: TransactionType.expense,
        colorValue: Colors.purple.toARGB32(),
        icon: '🛍️',
        isDefault: true,
      ),
      Category(
        id: 'expense_bills',
        name: 'Contas e Serviços',
        type: TransactionType.expense,
        colorValue: Colors.amber.toARGB32(),
        icon: '💡',
        isDefault: true,
      ),
      Category(
        id: 'expense_other',
        name: 'Outras Despesas',
        type: TransactionType.expense,
        colorValue: Colors.grey.toARGB32(),
        icon: '📦',
        isDefault: true,
      ),
    ];

    // Salvar todas as categorias
    for (var category in [...incomeCategories, ...expenseCategories]) {
      await categoryRepository.addCategory(category);
    }
  }
}
