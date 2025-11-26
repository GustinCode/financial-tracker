import 'package:hive_flutter/hive_flutter.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../services/database_service.dart';

class CategoryRepository {
  Box<Category> get _box => Hive.box<Category>(DatabaseService.categoriesBoxName);

  Future<List<Category>> getAllCategories() async {
    return _box.values.toList();
  }

  Future<List<Category>> getCategoriesByType(TransactionType type) async {
    final allCategories = await getAllCategories();
    return allCategories.where((c) => c.type == type).toList();
  }

  Future<Category?> getCategoryById(String id) async {
    return _box.get(id);
  }

  Future<void> addCategory(Category category) async {
    await _box.put(category.id, category);
  }

  Future<void> updateCategory(Category category) async {
    await _box.put(category.id, category);
  }

  Future<void> deleteCategory(String id) async {
    await _box.delete(id);
  }
}




