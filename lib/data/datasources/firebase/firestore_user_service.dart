import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_profile_model.dart';

class FirestoreUserService {
  FirestoreUserService(this._db);
  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> users() => _db.collection('users');

  Future<void> upsertProfile(UserProfileModel model) async {
    await users().doc(model.uid).set(model.toJson(), SetOptions(merge: true));
  }

  Stream<UserProfileModel?> watchProfile(String uid) {
    return users().doc(uid).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) return null;
      return UserProfileModel.fromDoc(uid, data);
    });
  }
}