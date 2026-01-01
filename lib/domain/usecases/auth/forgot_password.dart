import '../../repositories/auth_repository.dart';

class ForgotPasswordUsecase {
  ForgotPasswordUsecase(this.repo);
  final AuthRepository repo;

  Future<void> call({required String email}) => repo.sendPasswordResetEmail(email: email);
}