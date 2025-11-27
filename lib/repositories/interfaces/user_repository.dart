import '../../models/user_profile_model.dart';

abstract class UserRepository {
  Future<UserProfile?> fetchProfile();
  Stream<UserProfile?> watchProfile();
  Future<void> saveProfile(UserProfile profile);
  Future<void> clearProfile();
}

abstract class UserRemoteRepository {
  Stream<UserProfile?> watchProfile({required String userId});
  Future<void> upsertProfile({required String userId, required UserProfile profile});
}

