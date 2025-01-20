import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/core/models/food_category.dart';

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

final foodCategoriesProvider = Provider<List<FoodCategory>>((ref) {
  return foodCategories;
});
