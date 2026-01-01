import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<User?> authStateChanges();
  User? get currentUser;

  Future<void> login({required String email, required String password});
  Future<void> register({required String name, required String email, required String password});
  Future<void> sendPasswordResetEmail({required String email});
  Future<void> logout();
}