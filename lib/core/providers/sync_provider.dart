import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/core/services/sync_service.dart';
import 'package:food_tracker/core/services/auth_service.dart';
import 'package:food_tracker/core/config/supabase_config.dart';
import 'package:food_tracker/core/providers/objectbox_provider.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  final objectBox = ref.watch(objectBoxProvider);
  final authService = AuthService(supabase: SupabaseConfig.client);

  return SyncService(
    auth: authService,
    supabase: SupabaseConfig.client,
    objectBox: objectBox,
  );
});

final syncStateProvider = StateProvider<bool>((ref) => false);

final autoSyncProvider = StateProvider<bool>((ref) => true);
