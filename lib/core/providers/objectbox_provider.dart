import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/core/config/objectbox.dart';
import 'package:food_tracker/shared/models/food_entry.dart';

final objectBoxProvider = Provider<ObjectBox>((ref) {
  throw UnimplementedError();
});

final objectBoxFutureProvider = FutureProvider<ObjectBox>((ref) async {
  final objectBox = await ObjectBox.create();
  ref.onDispose(() => objectBox.close());
  return objectBox;
});

final foodEntriesStreamProvider = StreamProvider((ref) {
  final objectBox = ref.watch(objectBoxFutureProvider).value;
  if (objectBox == null) return Stream.value(<FoodEntry>[]);
  return objectBox.watchAllFoodEntries();
});
