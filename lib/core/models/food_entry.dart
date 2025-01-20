import 'package:objectbox/objectbox.dart';

@Entity()
class FoodEntry {
  @Id()
  int id;

  String name;
  String categoryId;
  String subcategoryId;
  bool isVegetarian;
  DateTime dateTime;
  bool isSynced;

  FoodEntry({
    this.id = 0,
    required this.name,
    required this.categoryId,
    required this.subcategoryId,
    required this.isVegetarian,
    required this.dateTime,
    this.isSynced = false,
  });
}
