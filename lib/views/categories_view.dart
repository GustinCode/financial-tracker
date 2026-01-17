import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../providers/category_provider.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  late TransactionType _selectedType;
  bool _showCustomOnly = false;

  @override
  void initState() {
    super.initState();
    _selectedType = TransactionType.expense;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        elevation: 0,
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, categoryProvider, _) {
          final categories = _showCustomOnly
              ? categoryProvider.getCustomCategories(_selectedType)
              : categoryProvider.getCategoriesByType(_selectedType);

          return Column(
            children: [
              // Type and filter tabs
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Type selector
                    Row(
                      children: [
                        Expanded(
                          child: SegmentedButton<TransactionType>(
                            segments: const [
                              ButtonSegment(
                                value: TransactionType.income,
                                label: Text('Receita'),
                                icon: Icon(Icons.trending_up),
                              ),
                              ButtonSegment(
                                value: TransactionType.expense,
                                label: Text('Despesa'),
                                icon: Icon(Icons.trending_down),
                              ),
                            ],
                            selected: {_selectedType},
                            onSelectionChanged: (newSelection) {
                              setState(() {
                                _selectedType = newSelection.first;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Filter toggle
                    Row(
                      children: [
                        FilterChip(
                          label: const Text('Apenas Personalizadas'),
                          selected: _showCustomOnly,
                          onSelected: (selected) {
                            setState(() {
                              _showCustomOnly = selected;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Categories list
              Expanded(
                child: categories.isEmpty
                    ? Center(
                        child: Text(
                          _showCustomOnly
                              ? 'Nenhuma categoria personalizada'
                              : 'Nenhuma categoria encontrada',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return _buildCategoryTile(
                            context,
                            category,
                            categoryProvider,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context),
        tooltip: 'Adicionar categoria',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryTile(
    BuildContext context,
    Category category,
    CategoryProvider categoryProvider,
  ) {
    final subcategories =
        categoryProvider.getSubcategories(category.id);

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
          subtitle: Row(
            children: [
              if (category.isCustom)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Personalizada',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              if (category.isDefault)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Padrão',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                ),
              if (subcategories.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    '${subcategories.length} subcategorias',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
            ],
          ),
          trailing: PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Adicionar subcategoria'),
                onTap: () => _showAddSubcategoryDialog(context, category),
              ),
              if (category.isCustom)
                PopupMenuItem(
                  child: const Text('Editar'),
                  onTap: () => _showEditCategoryDialog(context, category),
                ),
              if (category.isCustom)
                PopupMenuItem(
                  child: const Text('Deletar'),
                  onTap: () => _showDeleteConfirmation(
                    context,
                    category,
                    categoryProvider,
                  ),
                ),
            ],
          ),
        ),
        // Subcategories list
        if (subcategories.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
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
                        title: Text(
                          '└─ ${subcat.name}',
                          style: const TextStyle(fontSize: 13),
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            if (subcat.isCustom)
                              PopupMenuItem(
                                child: const Text('Editar'),
                                onTap: () =>
                                    _showEditCategoryDialog(context, subcat),
                              ),
                            if (subcat.isCustom)
                              PopupMenuItem(
                                child: const Text('Deletar'),
                                onTap: () => _showDeleteConfirmation(
                                  context,
                                  subcat,
                                  categoryProvider,
                                ),
                              ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        const Divider(height: 1),
      ],
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _AddCategoryDialog(
        type: _selectedType,
        onAdd: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showAddSubcategoryDialog(
    BuildContext context,
    Category parentCategory,
  ) {
    showDialog(
      context: context,
      builder: (context) => _AddCategoryDialog(
        type: _selectedType,
        parentCategory: parentCategory,
        onAdd: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showEditCategoryDialog(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (context) => _EditCategoryDialog(
        category: category,
        onEdit: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Category category,
    CategoryProvider categoryProvider,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar categoria?'),
        content: Text(
          'Tem certeza que deseja deletar "${category.name}"?'
          '\nEsta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              categoryProvider.deleteCategory(category.id);
              Navigator.pop(context);
            },
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
  }
}

class _AddCategoryDialog extends StatefulWidget {
  final TransactionType type;
  final Category? parentCategory;
  final VoidCallback onAdd;

  const _AddCategoryDialog({
    required this.type,
    this.parentCategory,
    required this.onAdd,
  });

  @override
  State<_AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<_AddCategoryDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emojiController;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emojiController = TextEditingController(text: '📁');
    _selectedColor = Colors.blue;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.parentCategory != null
            ? 'Adicionar subcategoria a "${widget.parentCategory!.name}"'
            : 'Adicionar nova categoria',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome da categoria',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _emojiController,
                    maxLength: 2,
                    decoration: const InputDecoration(
                      labelText: 'Ícone (emoji)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Cor'),
                      const SizedBox(height: 8),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: _selectedColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _showColorPicker,
                            child: const Center(
                              child: Text('Alterar'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (_nameController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Informe o nome da categoria')),
              );
              return;
            }

            final categoryProvider =
                context.read<CategoryProvider>();
            categoryProvider.createCustomCategory(
              name: _nameController.text,
              type: widget.type,
              colorValue: _selectedColor.toARGB32(),
              icon: _emojiController.text.isEmpty
                  ? '📁'
                  : _emojiController.text,
              parentCategoryId: widget.parentCategory?.id,
            );

            widget.onAdd();
          },
          child: const Text('Adicionar'),
        ),
      ],
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escolher cor'),
        content: GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          children: [
            Colors.red,
            Colors.pink,
            Colors.purple,
            Colors.deepPurple,
            Colors.indigo,
            Colors.blue,
            Colors.cyan,
            Colors.teal,
            Colors.green,
            Colors.lightGreen,
            Colors.lime,
            Colors.yellow,
            Colors.amber,
            Colors.orange,
            Colors.deepOrange,
            Colors.brown,
          ]
              .map((color) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border: _selectedColor == color
                            ? Border.all(
                                color: Colors.white,
                                width: 3,
                              )
                            : null,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class _EditCategoryDialog extends StatefulWidget {
  final Category category;
  final VoidCallback onEdit;

  const _EditCategoryDialog({
    required this.category,
    required this.onEdit,
  });

  @override
  State<_EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<_EditCategoryDialog> {
  late TextEditingController _nameController;
  late TextEditingController _emojiController;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category.name);
    _emojiController = TextEditingController(text: widget.category.icon);
    _selectedColor = Color(widget.category.colorValue);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Editar categoria'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome da categoria',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _emojiController,
                    maxLength: 2,
                    decoration: const InputDecoration(
                      labelText: 'Ícone (emoji)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Cor'),
                      const SizedBox(height: 8),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: _selectedColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _showColorPicker,
                            child: const Center(
                              child: Text('Alterar'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            if (_nameController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Informe o nome da categoria')),
              );
              return;
            }

            final categoryProvider =
                context.read<CategoryProvider>();
            final updatedCategory = widget.category.copyWith(
              name: _nameController.text,
              colorValue: _selectedColor.toARGB32(),
              icon: _emojiController.text.isEmpty
                  ? '📁'
                  : _emojiController.text,
            );
            categoryProvider.updateCategory(updatedCategory);

            widget.onEdit();
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escolher cor'),
        content: GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          children: [
            Colors.red,
            Colors.pink,
            Colors.purple,
            Colors.deepPurple,
            Colors.indigo,
            Colors.blue,
            Colors.cyan,
            Colors.teal,
            Colors.green,
            Colors.lightGreen,
            Colors.lime,
            Colors.yellow,
            Colors.amber,
            Colors.orange,
            Colors.deepOrange,
            Colors.brown,
          ]
              .map((color) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border: _selectedColor == color
                            ? Border.all(
                                color: Colors.white,
                                width: 3,
                              )
                            : null,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
