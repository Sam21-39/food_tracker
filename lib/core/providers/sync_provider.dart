import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/core/services/sync_service.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService();
});

final syncStateProvider = StateProvider<bool>((ref) => false);

final autoSyncProvider = StateProvider<bool>((ref) => true);
