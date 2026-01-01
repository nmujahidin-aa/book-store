import '../../repositories/auth_repository.dart';

class LoginUsecase {
  LoginUsecase(this.repo);
  final AuthRepository repo;

  Future<void> call({required String email, required String password}) {
    return repo.login(email: email, password: password);
  }
}