import 'dart:async';

import 'package:hive/hive.dart';

import '../../core/constants/hive_box_constants.dart';
import '../../core/utils/stream_extensions.dart';
import '../../models/jar_model.dart';
import '../interfaces/jar_repository.dart';

class HiveJarRepository implements JarRepository {
  HiveJarRepository({Box<Jar>? box}) : _box = box ?? Hive.box<Jar>(HiveBoxConstants.jars);

  final Box<Jar> _box;

  @override
  Future<void> clear() async {
    await _box.clear();
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<List<Jar>> fetchAll() async {
    return _box.values.toList(growable: false);
  }

  @override
  Future<Jar?> findById(String id) async {
    return _box.get(id);
  }

  @override
  Future<void> save(Jar jar) async {
    await _box.put(jar.id, jar);
  }

  @override
  Future<void> saveAll(List<Jar> jars) async {
    final entries = {for (final jar in jars) jar.id: jar};
    await _box.putAll(entries);
  }

  @override
  Stream<List<Jar>> watchAll() {
    return _box
        .watch()
        .map((_) => _box.values.toList(growable: false))
        .startWith(_box.values.toList(growable: false));
  }
}

