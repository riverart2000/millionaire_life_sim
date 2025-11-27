import 'package:uuid/uuid.dart';

import '../core/utils/logger.dart';
import '../core/utils/result.dart';
import '../models/transaction_model.dart';
import '../repositories/interfaces/transaction_repository.dart';
import '../repositories/interfaces/user_repository.dart';

class TransactionService {
  TransactionService({
    required TransactionRepository localRepository,
    TransactionRemoteRepository? remoteRepository,
    UserRepository? userRepository,
  })  : _localRepository = localRepository,
        _remoteRepository = remoteRepository;

  final TransactionRepository _localRepository;
  final TransactionRemoteRepository? _remoteRepository;
  final Uuid _uuid = const Uuid();

  Future<Result<MoneyTransaction>> logTransaction({
    required String userId,
    required String jarId,
    required double amount,
    required TransactionKind kind,
    String description = '',
    String? counterpartyId,
    String? itemId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final transaction = MoneyTransaction(
        id: _uuid.v4(),
        jarId: jarId,
        amount: amount,
        kind: kind,
        date: DateTime.now(),
        description: description,
        counterpartyId: counterpartyId,
        itemId: itemId,
        metadata: metadata,
      );

      await _localRepository.save(transaction);
      
      // Fire-and-forget remote sync (don't await to avoid blocking)
      // This will succeed silently if sync is disabled or network is slow
      _remoteRepository?.upsert(userId: userId, transaction: transaction).catchError((error) {
        logError('Failed to sync transaction to remote (non-blocking)', error, null);
      });
      
      return Success(transaction);
    } catch (error, stackTrace) {
      logError('Failed to log transaction', error, stackTrace);
      return Failure(error, stackTrace);
    }
  }

  Future<Result<List<MoneyTransaction>>> syncTransactions({
    required String userId,
    required List<MoneyTransaction> transactions,
  }) async {
    try {
      await _localRepository.saveAll(transactions);
      if (_remoteRepository != null) {
        await _remoteRepository.upsertAll(userId: userId, transactions: transactions);
      }
      return Success(transactions);
    } catch (error, stackTrace) {
      logError('Failed to sync transactions', error, stackTrace);
      return Failure(error, stackTrace);
    }
  }
}

