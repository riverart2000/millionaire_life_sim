import 'package:hive/hive.dart';

import '../../core/constants/hive_box_constants.dart';
import '../../core/utils/stream_extensions.dart';
import '../../models/user_profile_model.dart';
import '../interfaces/user_repository.dart';

class HiveUserRepository implements UserRepository {
  HiveUserRepository({Box<UserProfile>? box})
      : _box = box ?? Hive.box<UserProfile>(HiveBoxConstants.userProfile);

  final Box<UserProfile> _box;

  static const _profileKey = 'current_profile';

  @override
  Future<void> clearProfile() async {
    await _box.delete(_profileKey);
  }

  @override
  Future<UserProfile?> fetchProfile() async {
    return _box.get(_profileKey);
  }

  @override
  Future<void> saveProfile(UserProfile profile) async {
    await _box.put(_profileKey, profile);
  }

  @override
  Stream<UserProfile?> watchProfile() {
    return _box
        .watch(key: _profileKey)
        .map((_) => _box.get(_profileKey))
        .startWith(_box.get(_profileKey));
  }
}

