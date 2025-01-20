import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase;

  AuthService({required SupabaseClient supabase}) : _supabase = supabase;

  Future<String?> getCurrentUserId() async {
    return _supabase.auth.currentUser?.id;
  }

  Future<bool> isSignedIn() async {
    return _supabase.auth.currentUser != null;
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}
