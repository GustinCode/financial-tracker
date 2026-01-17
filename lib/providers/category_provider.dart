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

  /// Get only parent categories (those without parentCategoryId)
  List<models.Category> getParentCategories(TransactionType type) {
    return _categories
        .where((c) => c.type == type && c.parentCategoryId == null)
        .toList();
  }

  /// Get subcategories for a given parent category
  List<models.Category> getSubcategories(String parentCategoryId) {
    return _categories
        .where((c) => c.parentCategoryId == parentCategoryId)
        .toList();
  }

  /// Get custom categories by type
  List<models.Category> getCustomCategories(TransactionType type) {
    return _categories
        .where((c) => c.type == type && c.isCustom)
        .toList();
  }

  /// Get default categories by type
  List<models.Category> getDefaultCategories(TransactionType type) {
    return _categories
        .where((c) => c.type == type && c.isDefault)
        .toList();
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
    // Also delete any subcategories of this category
    final subcategories = getSubcategories(id);
    for (var subcat in subcategories) {
      await _repository.deleteCategory(subcat.id);
    }
    
    await _repository.deleteCategory(id);
    await loadCategories();
  }

  /// Create a new custom category
  Future<void> createCustomCategory({
    required String name,
    required TransactionType type,
    required int colorValue,
    required String icon,
    String? parentCategoryId,
  }) async {
    final id = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    final category = models.Category(
      id: id,
      name: name,
      type: type,
      colorValue: colorValue,
      icon: icon,
      isDefault: false,
      isCustom: true,
      parentCategoryId: parentCategoryId,
    );
    await addCategory(category);
  }
}



