import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/shared/models/food_entry.dart';
import 'package:food_tracker/core/providers/objectbox_provider.dart';
import 'package:food_tracker/core/providers/sync_provider.dart';
import 'package:food_tracker/core/providers/auth_provider.dart';

final foodEntriesProvider = StreamProvider<List<FoodEntry>>((ref) async* {
  final objectBox = await ref.watch(objectBoxFutureProvider.future);
  yield* objectBox.watchAllFoodEntries();
});

final foodEntryServiceProvider = Provider<FoodEntryService>((ref) {
  return FoodEntryService(ref);
});

class FoodEntryService {
  final Ref _ref;

  FoodEntryService(this._ref);

  Future<void> addFoodEntry(FoodEntry entry) async {
    final objectBox = await _ref.read(objectBoxFutureProvider.future);
    final autoSync = _ref.read(autoSyncProvider);
    final authState = _ref.read(authStateProvider);

    // Save to local storage
    objectBox.addFoodEntry(entry);

    // Sync with cloud if auto-sync is enabled and user is signed in
    if (autoSync && authState.isSignedIn) {
      final syncService = _ref.read(syncServiceProvider);
      await syncService.syncFoodEntry(entry);

      // Update sync state in local storage
      entry.isSynced = true;
      objectBox.addFoodEntry(entry);
    }
  }

  Future<void> deleteFoodEntry(int id) async {
    final objectBox = await _ref.read(objectBoxFutureProvider.future);
    objectBox.deleteFoodEntry(id);
  }
}
