import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../providers/category_provider.dart';

/// A reusable widget for picking a category with support for subcategories
class CategoryPicker extends StatefulWidget {
  final TransactionType transactionType;
  final Function(Category) onCategorySelected;
  final Category? initialCategory;
  final String? label;

  const CategoryPicker({
    super.key,
    required this.transactionType,
    required this.onCategorySelected,
    this.initialCategory,
    this.label = 'Categoria',
  });

  @override
  State<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends State<CategoryPicker> {
  late Category? _selectedCategory;
  String? _expandedParentId;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, _) {
        final parentCategories =
            categoryProvider.getParentCategories(widget.transactionType);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label ?? 'Categoria',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _selectedCategory != null
                  ? _buildSelectedCategoryTile(categoryProvider)
                  : _buildCategorySelector(parentCategories, categoryProvider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSelectedCategoryTile(CategoryProvider categoryProvider) {
    final category = _selectedCategory!;
    final subcategories = categoryProvider.getSubcategories(category.id);

    return Column(
      children: [
        ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(category.colorValue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                category.icon,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          title: Text(category.name),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                _selectedCategory = null;
                _expandedParentId = null;
              });
            },
          ),
        ),
        if (subcategories.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Subcategorias disponíveis:',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: subcategories
                      .map((subcat) => FilterChip(
                              label: Text('${subcat.icon} ${subcat.name}'),
                            onSelected: (_) {
                              setState(() {
                                _selectedCategory = subcat;
                              });
                              widget.onCategorySelected(subcat);
                            },
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCategorySelector(
    List<Category> parentCategories,
    CategoryProvider categoryProvider,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: parentCategories.length,
      itemBuilder: (context, index) {
        final parentCategory = parentCategories[index];
        final subcategories =
            categoryProvider.getSubcategories(parentCategory.id);
        final isExpanded = _expandedParentId == parentCategory.id;

        return Column(
          children: [
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(parentCategory.colorValue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    parentCategory.icon,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              title: Text(parentCategory.name),
              trailing: subcategories.isNotEmpty
                  ? Icon(
                      isExpanded
                          ? Icons.expand_less
                          : Icons.expand_more,
                    )
                  : null,
              onTap: () {
                if (subcategories.isEmpty) {
                  setState(() {
                    _selectedCategory = parentCategory;
                  });
                  widget.onCategorySelected(parentCategory);
                  Navigator.pop(context);
                } else {
                  setState(() {
                    _expandedParentId =
                        isExpanded ? null : parentCategory.id;
                  });
                }
              },
            ),
            if (isExpanded && subcategories.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 56.0, right: 16.0),
                child: Column(
                  children: subcategories
                      .map((subcat) => ListTile(
                            dense: true,
                            leading: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Color(subcat.colorValue),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  subcat.icon,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            title: Text('└─ ${subcat.name}'),
                            onTap: () {
                              setState(() {
                                _selectedCategory = subcat;
                              });
                              widget.onCategorySelected(subcat);
                              Navigator.pop(context);
                            },
                          ))
                      .toList(),
                ),
              ),
            if (index < parentCategories.length - 1 && !isExpanded)
              const Divider(height: 1),
          ],
        );
      },
    );
  }
}
