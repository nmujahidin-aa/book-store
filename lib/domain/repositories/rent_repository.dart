import '../entities/rent.dart';

abstract class RentRepository {
  Future<void> createRent({
    required String uid,
    required Rent rent,
  });

  Stream<List<Rent>> watchRents({required String uid});
}