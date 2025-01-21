import 'package:flutter/material.dart';
import 'package:food_tracker/core/models/food_category.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategorySelector extends StatefulWidget {
  final String? initialCategoryId;
  final String? initialSubcategoryId;
  final void Function(String categoryId, String subcategoryId) onSelect;

  const CategorySelector({
    super.key,
    this.initialCategoryId,
    this.initialSubcategoryId,
    required this.onSelect,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  String? _selectedCategoryId;
  String? _selectedSubcategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategoryId;
    _selectedSubcategoryId = widget.initialSubcategoryId;
  }

  void _selectCategory(String categoryId) {
    setState(() {
      if (_selectedCategoryId == categoryId) {
        _selectedCategoryId = null;
        _selectedSubcategoryId = null;
      } else {
        _selectedCategoryId = categoryId;
        _selectedSubcategoryId = null;
      }
    });
  }

  void _selectSubcategory(String subcategoryId) {
    setState(() {
      _selectedSubcategoryId = subcategoryId;
    });
    if (_selectedCategoryId != null) {
      widget.onSelect(_selectedCategoryId!, subcategoryId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.category,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: foodCategories.length,
          itemBuilder: (context, index) {
            final category = foodCategories[index];
            final isSelected = category.id == _selectedCategoryId;

            return InkWell(
              onTap: () => _selectCategory(category.id),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                    width: isSelected ? 2 : 1,
                  ),
                  color: isSelected
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surface,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (category.icon != null)
                      Text(
                        category.icon!,
                        style: const TextStyle(fontSize: 24),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      category.name,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        if (_selectedCategoryId != null) ...[
          const SizedBox(height: 16),
          Text(
            l10n.selectCategory,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: foodCategories
                .firstWhere((c) => c.id == _selectedCategoryId)
                .subcategories
                .map((subcategory) {
              final isSelected = subcategory.id == _selectedSubcategoryId;

              return FilterChip(
                label: Text(subcategory.name),
                selected: isSelected,
                onSelected: (_) => _selectSubcategory(subcategory.id),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
