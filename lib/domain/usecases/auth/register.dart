import '../../repositories/auth_repository.dart';

class RegisterUsecase {
  RegisterUsecase(this.repo);
  final AuthRepository repo;

  Future<void> call({required String name, required String email, required String password}) {
    return repo.register(name: name, email: email, password: password);
  }
}