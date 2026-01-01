import '../../repositories/auth_repository.dart';

class LogoutUsecase {
  LogoutUsecase(this.repo);
  final AuthRepository repo;

  Future<void> call() => repo.logout();
}