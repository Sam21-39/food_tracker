import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthState {
  final bool isSignedIn;
  final String? userId;
  final String? error;

  AuthState({
    this.isSignedIn = false,
    this.userId,
    this.error,
  });

  AuthState copyWith({
    bool? isSignedIn,
    String? userId,
    String? error,
  }) {
    return AuthState(
      isSignedIn: isSignedIn ?? this.isSignedIn,
      userId: userId ?? this.userId,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Supabase _supabase;

  AuthNotifier(this._supabase) : super(AuthState()) {
    _initialize();
  }

  final _storage = const FlutterSecureStorage();

  void _initialize() {
    final session = _supabase.client.auth.currentSession;
    if (session != null) {
      state = AuthState(
        isSignedIn: true,
        userId: session.user.id,
      );
    }

    _supabase.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      state = AuthState(
        isSignedIn: session != null,
        userId: session?.user.id,
      );
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _supabase.client.auth.signUp(
        email: email,
        password: password,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _supabase.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.client.auth.signOut();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(Supabase.instance);
});
