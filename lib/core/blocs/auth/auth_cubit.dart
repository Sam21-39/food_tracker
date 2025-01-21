import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_tracker/core/blocs/auth/auth_state.dart' as auth_bloc;
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthCubit extends Cubit<auth_bloc.AuthState> {
  final SupabaseClient _supabase;

  AuthCubit(this._supabase) : super(auth_bloc.AuthInitial()) {
    _initialize();
  }

  Future<void> _initialize() async {
    final session = _supabase.auth.currentSession;
    if (session != null) {
      emit(auth_bloc.AuthAuthenticated(session.user));
    } else {
      emit(auth_bloc.AuthUnauthenticated());
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      emit(auth_bloc.AuthLoading());
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        emit(auth_bloc.AuthAuthenticated(response.user!));
      } else {
        emit(const auth_bloc.AuthError('Sign in failed'));
      }
    } catch (e) {
      emit(auth_bloc.AuthError(e.toString()));
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      emit(auth_bloc.AuthLoading());
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user != null) {
        emit(auth_bloc.AuthAuthenticated(response.user!));
      } else {
        emit(const auth_bloc.AuthError('Sign up failed'));
      }
    } catch (e) {
      emit(auth_bloc.AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      emit(auth_bloc.AuthUnauthenticated());
    } catch (e) {
      emit(auth_bloc.AuthError(e.toString()));
    }
  }

  bool get isSignedIn => state is auth_bloc.AuthAuthenticated;
}
