import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/firebase/firestore_user_service.dart';
import '../models/user_profile_model.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._svc);
  final FirestoreUserService _svc;

  @override
  Future<void> upsertProfile(UserProfile profile) {
    final model = UserProfileModel(
      uid: profile.uid,
      name: profile.name,
      email: profile.email,
      createdAt: DateTime.now(),
    );
    return _svc.upsertProfile(model);
  }

  @override
  Stream<UserProfile?> watchProfile(String uid) {
    return _svc.watchProfile(uid).map((m) => m?.toEntity());
  }
}