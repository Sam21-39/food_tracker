import 'package:food_tracker/shared/models/food_entry.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:food_tracker/objectbox.g.dart';

class ObjectBox {
  late final Store store;
  late final Box<FoodEntry> foodEntryBox;

  ObjectBox._create(this.store) {
    foodEntryBox = Box<FoodEntry>(store);
  }

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(
      directory: p.join(docsDir.path, "food-tracker"),
    );
    return ObjectBox._create(store);
  }

  Stream<List<FoodEntry>> watchAllFoodEntries() {
    final query = foodEntryBox.query()
      ..order(FoodEntry_.timestamp, flags: Order.descending);
    return query.watch(triggerImmediately: true).map((query) => query.find());
  }

  int addFoodEntry(FoodEntry entry) => foodEntryBox.put(entry);

  List<FoodEntry> getAllFoodEntries() {
    return foodEntryBox.getAll();
  }

  Future<void> storeFoodEntry(FoodEntry entry) async {
    foodEntryBox.put(entry);
  }

  bool deleteFoodEntry(int id) => foodEntryBox.remove(id);

  void close() => store.close();
}
