import 'package:food_tracker/shared/models/food_entry.dart';
import 'package:flutter/foundation.dart';
import 'package:food_tracker/core/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:food_tracker/core/config/objectbox.dart';

class SyncService {
  final AuthService _auth;
  final SupabaseClient _supabase;
  final ObjectBox _objectBox;

  SyncService({
    required AuthService auth,
    required SupabaseClient supabase,
    required ObjectBox objectBox,
  })  : _auth = auth,
        _supabase = supabase,
        _objectBox = objectBox;

  Future<void> syncAllEntries(List<FoodEntry> entries) async {
    for (final entry in entries) {
      if (!entry.isSynced) {
        await _syncEntry(entry);
      }
    }
  }

  Future<void> _syncEntry(FoodEntry entry) async {
    try {
      final userId = await _auth.getCurrentUserId();
      if (userId == null) return;

      final data = {
        'uuid': entry.uuid,
        'name': entry.name,
        'category': entry.category,
        'is_vegetarian': entry.isVegetarian,
        'image_url': entry.imageUrl,
        'timestamp': entry.timestamp.toIso8601String(),
        'user_id': userId,
      };

      await _supabase.from('food_entries').upsert(data);
      entry.isSynced = true;
      await _objectBox.storeFoodEntry(entry);
    } catch (e) {
      debugPrint('Error syncing entry: $e');
      rethrow;
    }
  }

  Future<void> syncFoodEntry(FoodEntry entry) async {
    if (!entry.isSynced) {
      await _syncEntry(entry);
    }
  }
}
