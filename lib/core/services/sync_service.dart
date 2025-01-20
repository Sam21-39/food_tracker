import 'package:food_tracker/core/config/supabase_config.dart';
import 'package:food_tracker/shared/models/food_entry.dart';

class SyncService {
  static const String _tableName = 'food_entries';

  Future<void> syncFoodEntry(FoodEntry entry) async {
    try {
      await SupabaseConfig.client.from(_tableName).upsert({
        'uuid': entry.uuid,
        'name': entry.name,
        'category': entry.category,
        'is_vegetarian': entry.isVegetarian,
        'image_url': entry.imageUrl,
        'timestamp': entry.timestamp.toIso8601String(),
      });
    } catch (e) {
      // Handle error or retry later
      print('Error syncing food entry: $e');
    }
  }

  Future<List<FoodEntry>> fetchRemoteEntries() async {
    try {
      final response = await SupabaseConfig.client
          .from(_tableName)
          .select()
          .order('timestamp', ascending: false);

      return (response as List)
          .map((json) => FoodEntry.fromJson({
                'uuid': json['uuid'],
                'name': json['name'],
                'category': json['category'],
                'isVegetarian': json['is_vegetarian'],
                'imageUrl': json['image_url'],
                'timestamp': json['timestamp'],
                'isSynced': true,
              }))
          .toList();
    } catch (e) {
      print('Error fetching remote entries: $e');
      return [];
    }
  }

  Future<void> syncAllLocalEntries(List<FoodEntry> entries) async {
    for (var entry in entries) {
      if (!entry.isSynced) {
        await syncFoodEntry(entry);
      }
    }
  }

  Future<void> deleteRemoteEntry(String uuid) async {
    try {
      await SupabaseConfig.client.from(_tableName).delete().eq('uuid', uuid);
    } catch (e) {
      print('Error deleting remote entry: $e');
    }
  }
}
