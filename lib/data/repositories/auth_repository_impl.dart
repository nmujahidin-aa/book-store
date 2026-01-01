import 'package:firebase_auth/firebase_auth.dart';
import '../../core/utils/validators.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/firebase/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._authService, this._userRepo);

  final AuthService _authService;
  final UserRepository _userRepo;

  @override
  Stream<User?> authStateChanges() => _authService.authStateChanges();

  @override
  User? get currentUser => _authService.currentUser;

  @override
  Future<void> login({required String email, required String password}) async {
    // Validasi oleh BE
    final pErr = Validators.password(password);
    if (pErr != null) throw Exception(pErr);

    await _authService.login(email, password);
  }

  @override
  Future<void> register({required String name, required String email, required String password}) async {
    final pErr = Validators.password(password);
    if (pErr != null) throw Exception(pErr);

    final cred = await _authService.register(email, password);
    final uid = cred.user!.uid;

    await _userRepo.upsertProfile(UserProfile(uid: uid, name: name, email: email));

    await _authService.logout();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    return _authService.sendReset(email);
  }

  @override
  Future<void> logout() => _authService.logout();
}