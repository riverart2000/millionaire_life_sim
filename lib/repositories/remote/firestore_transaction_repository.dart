import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../../models/transaction_model.dart';
import '../interfaces/transaction_repository.dart';

class FirestoreTransactionRepository implements TransactionRemoteRepository {
  FirestoreTransactionRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _collection(String userId) {
    return _firestore.collection(FirestorePaths.userTransactionsCollection(userId));
  }

  @override
  Future<void> upsert({required String userId, required MoneyTransaction transaction}) async {
    await _collection(userId)
        .doc(transaction.id)
        .set(transaction.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> upsertAll({required String userId, required List<MoneyTransaction> transactions}) async {
    final batch = _firestore.batch();
    final collection = _collection(userId);
    for (final transaction in transactions) {
      final docRef = collection.doc(transaction.id);
      batch.set(docRef, transaction.toJson(), SetOptions(merge: true));
    }
    await batch.commit();
  }

  @override
  Stream<List<MoneyTransaction>> watchAll({required String userId}) {
    return _collection(userId).orderBy('date', descending: true).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => MoneyTransaction.fromJson(<String, dynamic>{...doc.data(), 'id': doc.id}))
              .toList(growable: false),
        );
  }
}

