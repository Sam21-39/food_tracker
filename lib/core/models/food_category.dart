class FoodCategory {
  final String id;
  final String name;
  final String? icon;
  final List<FoodSubcategory> subcategories;

  const FoodCategory({
    required this.id,
    required this.name,
    this.icon,
    required this.subcategories,
  });
}

class FoodSubcategory {
  final String id;
  final String name;

  const FoodSubcategory({
    required this.id,
    required this.name,
  });
}

final foodCategories = [
  FoodCategory(
    id: 'meals',
    name: 'Meals',
    icon: '🍽️',
    subcategories: [
      FoodSubcategory(id: 'breakfast', name: 'Breakfast'),
      FoodSubcategory(id: 'lunch', name: 'Lunch'),
      FoodSubcategory(id: 'dinner', name: 'Dinner'),
      FoodSubcategory(id: 'snacks', name: 'Snacks'),
    ],
  ),
  FoodCategory(
    id: 'medicine',
    name: 'Medicine',
    icon: '💊',
    subcategories: [
      FoodSubcategory(id: 'prescription', name: 'Prescription'),
      FoodSubcategory(id: 'supplements', name: 'Supplements'),
      FoodSubcategory(id: 'vitamins', name: 'Vitamins'),
      FoodSubcategory(id: 'otc', name: 'Over-the-counter'),
    ],
  ),
  FoodCategory(
    id: 'misc',
    name: 'Miscellaneous',
    icon: '📦',
    subcategories: [
      FoodSubcategory(id: 'beverages', name: 'Beverages'),
      FoodSubcategory(id: 'desserts', name: 'Desserts'),
      FoodSubcategory(id: 'other', name: 'Other'),
    ],
  ),
];
