import '../entities/user_profile.dart';

abstract class UserRepository {
  Future<void> upsertProfile(UserProfile profile);
  Stream<UserProfile?> watchProfile(String uid);
}