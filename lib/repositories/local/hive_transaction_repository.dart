import 'package:hive/hive.dart';

import '../../core/constants/hive_box_constants.dart';
import '../../core/utils/stream_extensions.dart';
import '../../models/transaction_model.dart';
import '../interfaces/transaction_repository.dart';

class HiveTransactionRepository implements TransactionRepository {
  HiveTransactionRepository({Box<MoneyTransaction>? box})
      : _box = box ?? Hive.box<MoneyTransaction>(HiveBoxConstants.transactions);

  final Box<MoneyTransaction> _box;

  @override
  Future<void> clear() async {
    await _box.clear();
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Future<List<MoneyTransaction>> fetchAll() async {
    return _box.values.toList(growable: false);
  }

  @override
  Future<List<MoneyTransaction>> fetchByJar(String jarId) async {
    return _box.values.where((tx) => tx.jarId == jarId).toList(growable: false);
  }

  @override
  Future<void> save(MoneyTransaction transaction) async {
    await _box.put(transaction.id, transaction);
  }

  @override
  Future<void> saveAll(List<MoneyTransaction> transactions) async {
    final entries = {for (final tx in transactions) tx.id: tx};
    await _box.putAll(entries);
  }

  @override
  Stream<List<MoneyTransaction>> watchAll() {
    return _box
        .watch()
        .map((_) => _box.values.toList(growable: false))
        .startWith(_box.values.toList(growable: false));
  }
}

