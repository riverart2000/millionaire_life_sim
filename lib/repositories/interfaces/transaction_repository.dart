import '../../models/transaction_model.dart';

abstract class TransactionRepository {
  Future<List<MoneyTransaction>> fetchAll();
  Stream<List<MoneyTransaction>> watchAll();
  Future<List<MoneyTransaction>> fetchByJar(String jarId);
  Future<void> save(MoneyTransaction transaction);
  Future<void> saveAll(List<MoneyTransaction> transactions);
  Future<void> delete(String id);
  Future<void> clear();
}

abstract class TransactionRemoteRepository {
  Stream<List<MoneyTransaction>> watchAll({required String userId});
  Future<void> upsert({required String userId, required MoneyTransaction transaction});
  Future<void> upsertAll({required String userId, required List<MoneyTransaction> transactions});
}

