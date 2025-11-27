import '../../models/jar_model.dart';

abstract class JarRepository {
  Future<List<Jar>> fetchAll();
  Stream<List<Jar>> watchAll();
  Future<Jar?> findById(String id);
  Future<void> save(Jar jar);
  Future<void> saveAll(List<Jar> jars);
  Future<void> delete(String id);
  Future<void> clear();
}

abstract class JarRemoteRepository {
  Stream<List<Jar>> watchAll({required String userId});
  Future<void> upsertJar({required String userId, required Jar jar});
  Future<void> upsertJars({required String userId, required List<Jar> jars});
  Future<void> deleteJar({required String userId, required String jarId});
}

