import '../../entities/rent.dart';
import '../../repositories/rent_repository.dart';

class CreateRentUsecase {
  CreateRentUsecase(this.repo);
  final RentRepository repo;

  Future<void> call({required String uid, required Rent rent}) {
    return repo.createRent(uid: uid, rent: rent);
  }
}