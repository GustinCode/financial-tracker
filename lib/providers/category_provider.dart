import 'package:flutter/foundation.dart' hide Category;
import '../models/category_model.dart' as models;
import '../models/transaction_model.dart';
import '../repositories/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repository = CategoryRepository();
  List<models.Category> _categories = [];

  List<models.Category> get categories => _categories;

  Future<void> loadCategories() async {
    _categories = await _repository.getAllCategories();
    notifyListeners();
  }

  List<models.Category> getCategoriesByType(TransactionType type) {
    return _categories.where((c) => c.type == type).toList();
  }

  models.Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addCategory(models.Category category) async {
    await _repository.addCategory(category);
    await loadCategories();
  }

  Future<void> updateCategory(models.Category category) async {
    await _repository.updateCategory(category);
    await loadCategories();
  }

  Future<void> deleteCategory(String id) async {
    await _repository.deleteCategory(id);
    await loadCategories();
  }
}




