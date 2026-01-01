import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/rent_model.dart';

class FirestoreRentService {
  FirestoreRentService(this._db);
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> rentsRef(String uid) =>
      _db.collection('users').doc(uid).collection('rents');

  Future<void> createRent(String uid, RentModel rent) async {
    await rentsRef(uid).add(rent.toJson());
  }

  Stream<List<RentModel>> watchRents(String uid) {
    return rentsRef(uid)
        .orderBy('rentedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(RentModel.fromDoc).toList());
  }
}