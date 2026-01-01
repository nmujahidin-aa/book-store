import '../../domain/entities/rent.dart';
import '../../domain/repositories/rent_repository.dart';
import '../datasources/firebase/firestore_rent_service.dart';
import '../models/rent_model.dart';

class RentRepositoryImpl implements RentRepository {
  RentRepositoryImpl(this._svc);
  final FirestoreRentService _svc;

  @override
  Future<void> createRent({required String uid, required Rent rent}) async {
    final model = RentModel(
      id: '',
      bookId: rent.bookId,
      title: rent.title,
      coverImage: rent.coverImage,
      authorName: rent.authorName,
      rentDays: rent.rentDays,
      pricePerDay: rent.pricePerDay,
      totalPrice: rent.totalPrice,
      rentedAt: rent.rentedAt,
      expiredAt: rent.expiredAt,
    );
    await _svc.createRent(uid, model);
  }

  @override
  Stream<List<Rent>> watchRents({required String uid}) {
    return _svc.watchRents(uid).map((list) => list.map((m) => m.toEntity()).toList());
  }
}