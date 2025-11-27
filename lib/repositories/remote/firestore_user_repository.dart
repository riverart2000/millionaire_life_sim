import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../../models/user_profile_model.dart';
import '../interfaces/user_repository.dart';

class FirestoreUserRepository implements UserRemoteRepository {
  FirestoreUserRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  DocumentReference<Map<String, dynamic>> _doc(String userId) {
    return _firestore.doc(FirestorePaths.userDocument(userId));
  }

  @override
  Future<void> upsertProfile({required String userId, required UserProfile profile}) async {
    await _doc(userId).set(profile.toJson(), SetOptions(merge: true));
  }

  @override
  Stream<UserProfile?> watchProfile({required String userId}) {
    return _doc(userId).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) {
        return null;
      }
      return UserProfile.fromJson(<String, dynamic>{...data, 'id': snapshot.id});
    });
  }
}

