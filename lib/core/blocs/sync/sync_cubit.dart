import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_tracker/core/blocs/sync/sync_state.dart';
import 'package:food_tracker/core/config/objectbox.dart';
import 'package:food_tracker/shared/models/food_entry.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncCubit extends Cubit<SyncState> {
  final SupabaseClient _supabase;
  final ObjectBox _objectBox;
  final SharedPreferences _prefs;
  static const String _autoSyncKey = 'autoSync';

  SyncCubit(this._supabase, this._objectBox, this._prefs)
      : super(SyncInitial());

  bool get autoSync => _prefs.getBool(_autoSyncKey) ?? true;

  void setAutoSync(bool value) {
    _prefs.setBool(_autoSyncKey, value);
  }

  Future<void> syncEntry(FoodEntry entry) async {
    if (!entry.isSynced && autoSync) {
      try {
        emit(SyncInProgress());
        final userId = _supabase.auth.currentUser?.id;
        if (userId == null) {
          emit(const SyncError('User not authenticated'));
          return;
        }

        final data = {
          'uuid': entry.uuid,
          'name': entry.name,
          'food_category': entry.category,
          'is_vegetarian': entry.isVegetarian,
          'image_url': entry.imageUrl,
          'timestamp': entry.timestamp.toIso8601String(),
          'user_id': userId,
        };

        await _supabase.from('food_entries').upsert(data);
        entry.isSynced = true;
        _objectBox.addFoodEntry(entry);

        final entries = _objectBox.getAllFoodEntries();
        emit(SyncSuccess(entries));
      } catch (e) {
        emit(SyncError(e.toString()));
      }
    }
  }

  Future<void> syncAllEntries() async {
    try {
      emit(SyncInProgress());
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        emit(const SyncError('User not authenticated'));
        return;
      }

      final entries = _objectBox.getAllFoodEntries();
      final unsyncedEntries =
          entries.where((entry) => !entry.isSynced).toList();

      for (final entry in unsyncedEntries) {
        final data = {
          'uuid': entry.uuid,
          'name': entry.name,
          'food_category': entry.category,
          'is_vegetarian': entry.isVegetarian,
          'image_url': entry.imageUrl,
          'timestamp': entry.timestamp.toIso8601String(),
          'user_id': userId,
        };

        await _supabase.from('food_entries').upsert(data);
        entry.isSynced = true;
        _objectBox.addFoodEntry(entry);
      }

      final updatedEntries = _objectBox.getAllFoodEntries();
      emit(SyncSuccess(updatedEntries));
    } catch (e) {
      emit(SyncError(e.toString()));
    }
  }
}
