import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/auth_repository.dart';
import 'auth_state.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    FirebaseAuth.instance,
    FirebaseFirestore.instance,
  );
});

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<AuthState> {
  late final AuthRepository _repository;

  @override
  Future<AuthState> build() async {
    _repository = ref.read(authRepositoryProvider);
    final user = FirebaseAuth.instance.currentUser;

    return AuthState(isAuthenticated: user != null);
  }


  Future<void> login(String email, String password) async {
    state = const AsyncLoading();

    try {
      await _repository.login(email: email, password: password);
      state = const AsyncData(
        AuthState(isAuthenticated: true),
      );
    } catch (e) {
      state = AsyncData(
        AuthState(
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    state = const AsyncLoading();

    try {
      await _repository.register(
        name: name,
        email: email,
        password: password,
      );

      state = const AsyncData(
        AuthState(justRegistered: true),
      );
    } catch (e) {
      state = AsyncData(
        AuthState(
          errorMessage: e.toString().replaceAll('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AsyncData(AuthState(isAuthenticated: false));
  }

  void clearEvent() {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(
        justRegistered: false,
        clearError: true,
      ),
    );
  }
}
