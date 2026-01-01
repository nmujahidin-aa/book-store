import '../../entities/rent.dart';
import '../../repositories/rent_repository.dart';

class WatchRentsUsecase {
  WatchRentsUsecase(this.repo);
  final RentRepository repo;

  Stream<List<Rent>> call({required String uid}) => repo.watchRents(uid: uid);
}