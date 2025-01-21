import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = 'https://yxbjrfixptufknmywmrh.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl4YmpyZml4cHR1ZmtubXl3bXJoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzczNTEyNzEsImV4cCI6MjA1MjkyNzI3MX0.Yc7qMQDv7M9eIDlx7avxjUu9KVDVeJ0UPcvaSM94PR0';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      debug: false,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;

  static User? get currentUser => client.auth.currentUser;

  static Stream<AuthState> get authStateChanges =>
      client.auth.onAuthStateChange;
}
