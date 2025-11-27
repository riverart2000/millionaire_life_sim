import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../../models/jar_model.dart';
import '../interfaces/jar_repository.dart';

class FirestoreJarRepository implements JarRemoteRepository {
  FirestoreJarRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String userId) {
    return _firestore.collection(FirestorePaths.userJarsCollection(userId));
  }

  @override
  Future<void> deleteJar({required String userId, required String jarId}) async {
    await _collection(userId).doc(jarId).delete();
  }

  @override
  Future<void> upsertJar({required String userId, required Jar jar}) async {
    await _collection(userId).doc(jar.id).set(jar.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> upsertJars({required String userId, required List<Jar> jars}) async {
    final batch = _firestore.batch();
    final collection = _collection(userId);
    for (final jar in jars) {
      final docRef = collection.doc(jar.id);
      batch.set(docRef, jar.toJson(), SetOptions(merge: true));
    }
    await batch.commit();
  }

  @override
  Stream<List<Jar>> watchAll({required String userId}) {
    return _collection(userId).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Jar.fromJson(<String, dynamic>{...doc.data(), 'id': doc.id}))
              .toList(growable: false),
        );
  }
}

