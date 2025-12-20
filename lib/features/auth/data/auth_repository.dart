import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;


  AuthRepository(this._firebaseAuth, this._firestore);

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseError(e);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = cred.user!.uid;

    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  Exception _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('Email tidak ada');
      case 'wrong-password':
        return Exception('Password salah');
      case 'email-already-in-use':
        return Exception('Email sudah digunakan');
      case 'invalid-email':
        return Exception('Format email tidak valid');
      case 'weak-password':
        return Exception('Password terlalu lemah (min. 8 karakter)');
      case 'network-request-failed':
        return Exception('Koneksi internet bermasalah');
      default:
        return Exception('Terjadi kesalahan. Silakan coba lagi.');
    }
  }
}