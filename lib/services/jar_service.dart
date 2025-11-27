import '../core/constants/jar_constants.dart';
import '../core/utils/logger.dart';
import '../core/utils/result.dart';
import '../models/jar_model.dart';
import '../models/transaction_model.dart';
import '../repositories/interfaces/jar_repository.dart';
import '../repositories/interfaces/user_repository.dart';
import 'transaction_service.dart';

class JarService {
  JarService({
    required JarRepository localRepository,
    JarRemoteRepository? remoteRepository,
    required UserRepository userRepository,
    required TransactionService transactionService,
  })  : _localRepository = localRepository,
        _remoteRepository = remoteRepository,
        _userRepository = userRepository,
        _transactionService = transactionService;

  final JarRepository _localRepository;
  final JarRemoteRepository? _remoteRepository;
  final UserRepository _userRepository;
  final TransactionService _transactionService;

  Future<Result<List<Jar>>> initializeDefaultJars(String userId) async {
    try {
      final existing = await _localRepository.fetchAll();
      if (existing.isNotEmpty) {
        return Success(existing);
      }

      final jars = JarConstants.defaultPercentages.entries
          .map(
            (entry) => Jar(
              id: entry.key,
              name: entry.key,
              percentage: entry.value,
              balance: 0,
              isDefault: true,
            ),
          )
          .toList();

      await _localRepository.saveAll(jars);
      if (_remoteRepository != null) {
        await _remoteRepository.upsertJars(userId: userId, jars: jars);
      }
      return Success(jars);
    } catch (error, stackTrace) {
      logError('Failed to initialize jars', error, stackTrace);
      return Failure(error, stackTrace);
    }
  }

  Future<Result<Jar>> deposit({
    required String userId,
    required String jarId,
    required double amount,
    String description = 'Deposit',
    TransactionKind kind = TransactionKind.allocation,
  }) async {
    try {
      final jar = await _localRepository.findById(jarId);
      if (jar == null) {
        throw StateError('Jar $jarId not found');
      }

      final updated = jar.copyWith(
        balance: jar.balance + amount,
        lastUpdated: DateTime.now(),
      );
      await _localRepository.save(updated);
      if (_remoteRepository != null) {
        await _remoteRepository.upsertJar(userId: userId, jar: updated);
      }

      await _transactionService.logTransaction(
        userId: userId,
        jarId: jarId,
        amount: amount,
        kind: kind,
        description: description,
      );

      return Success(updated);
    } catch (error, stackTrace) {
      logError('Failed to deposit into jar', error, stackTrace);
      return Failure(error, stackTrace);
    }
  }

  Future<Result<Jar>> withdraw({
    required String userId,
    required String jarId,
    required double amount,
    String description = 'Withdrawal',
    TransactionKind kind = TransactionKind.purchase,
    bool allowNegative = false,
  }) async {
    try {
      final jar = await _localRepository.findById(jarId);
      if (jar == null) {
        throw StateError('Jar $jarId not found');
      }
      // Allow negative balance if explicitly permitted (e.g., for NEC jar bills)
      if (!allowNegative && jar.balance < amount) {
        throw StateError('Insufficient funds in jar $jarId');
      }

      // Calculate new balance - allow negative if allowNegative is true
      final newBalance = jar.balance - amount;
      logInfo('💸 Withdrawing £${amount.toStringAsFixed(2)} from $jarId: Balance £${jar.balance.toStringAsFixed(2)} → £${newBalance.toStringAsFixed(2)} (allowNegative: $allowNegative)');

      final updated = jar.copyWith(
        balance: newBalance, // This can be negative if allowNegative is true
        lastUpdated: DateTime.now(),
      );
      await _localRepository.save(updated);
      
      // Fire-and-forget remote sync (don't await to avoid blocking)
      // This will succeed silently if sync is disabled or network is slow
      _remoteRepository?.upsertJar(userId: userId, jar: updated).catchError((error) {
        logError('Failed to sync jar to remote (non-blocking)', error, null);
      });

      // Log transaction (local first, remote sync is fire-and-forget)
      await _transactionService.logTransaction(
        userId: userId,
        jarId: jarId,
        amount: -amount,
        kind: kind,
        description: description,
      );

      return Success(updated);
    } catch (error, stackTrace) {
      logError('Failed to withdraw from jar', error, stackTrace);
      return Failure(error, stackTrace);
    }
  }

  Future<Result<void>> updatePercentages({
    required String userId,
    required Map<String, double> percentages,
  }) async {
    try {
      final sum = percentages.values.fold<double>(0, (prev, value) => prev + value);
      if ((sum - 100).abs() > 0.01) {
        throw ArgumentError('Jar percentages must total 100%. Currently $sum%.');
      }

      final jars = await _localRepository.fetchAll();
      final updated = jars
          .map(
            (jar) => jar.copyWith(
              percentage: percentages[jar.id] ?? jar.percentage,
            ),
          )
          .toList();

      await _localRepository.saveAll(updated);
      if (_remoteRepository != null) {
        await _remoteRepository.upsertJars(userId: userId, jars: updated);
      }

      final profile = await _userRepository.fetchProfile();
      if (profile != null) {
        await _userRepository.saveProfile(
          profile.copyWith(jarPercentages: percentages, lastSyncedAt: DateTime.now()),
        );
      }

      return const Success(null);
    } catch (error, stackTrace) {
      logError('Failed to update jar percentages', error, stackTrace);
      return Failure(error, stackTrace);
    }
  }

  Future<Result<void>> distributeIncome({
    required String userId,
    required double incomeAmount,
  }) async {
    try {
      final profile = await _userRepository.fetchProfile();
      final jars = await _localRepository.fetchAll();
      final percentages = profile?.jarPercentages ?? JarConstants.defaultPercentages;

      final allocations = jars.map((jar) {
        final percentage = percentages[jar.id] ?? jar.percentage;
        final amount = incomeAmount * (percentage / 100);
        return MapEntry(jar, amount);
      }).toList();

      for (final entry in allocations) {
        final jar = entry.key;
        final amount = entry.value;
        final result = await deposit(
          userId: userId,
          jarId: jar.id,
          amount: amount,
          description: 'Income allocation (${_percentageLabel(percentages[jar.id] ?? jar.percentage)})',
          kind: TransactionKind.income,
        );
        if (result.isFailure) {
          throw result.error ?? StateError('Income allocation failed');
        }
      }
      return const Success(null);
    } catch (error, stackTrace) {
      logError('Failed to distribute income', error, stackTrace);
      return Failure(error, stackTrace);
    }
  }

  String _percentageLabel(double percentage) => '${percentage.toStringAsFixed(0)}%';

  Future<void> applyInterest({
    required String userId,
    required Map<String, double> interestRates,
  }) async {
    final jars = await _localRepository.fetchAll();
    logInfo('💰 Applying interest to jars. Rates: $interestRates');

    for (final jar in jars) {
      final rate = interestRates[jar.id];
      if (rate == null || rate <= 0) {
        logInfo('⏭️ Skipping ${jar.id} - no interest rate configured');
        continue;
      }

      final interestAmount = jar.balance * rate;
      if (interestAmount.abs() < 0.01) {
        logInfo('⏭️ Skipping ${jar.id} - interest amount too small: £${interestAmount.toStringAsFixed(4)}');
        continue;
      }

      logInfo('💰 Applying ${(rate * 100).toStringAsFixed(1)}% interest to ${jar.id}: Balance was £${jar.balance.toStringAsFixed(2)}, adding £${interestAmount.toStringAsFixed(2)}');

      final result = await deposit(
        userId: userId,
        jarId: jar.id,
        amount: interestAmount,
        description: 'Daily interest (${(rate * 100).toStringAsFixed(1)}%)',
        kind: TransactionKind.income,
      );

      if (result is Success<Jar>) {
        logInfo('✅ Interest applied to ${jar.id}. New balance: £${result.value.balance.toStringAsFixed(2)}');
      } else if (result is Failure<Jar>) {
        logError('❌ Failed to apply interest to ${jar.id}', result.exception, result.stackTrace);
      }
    }
    logInfo('✅ Finished applying interest to all jars');
  }

  Future<Result<List<Jar>>> syncFromRemote({required String userId}) async {
    try {
      if (_remoteRepository == null) {
        return Failure(StateError('Remote repository not available'), StackTrace.current);
      }
      final remoteStream = _remoteRepository.watchAll(userId: userId);
      final jars = await remoteStream.first;
      await _localRepository.saveAll(jars);
      return Success(jars);
    } catch (error, stackTrace) {
      logError('Failed to sync jars from remote', error, stackTrace);
      return Failure(error, stackTrace);
    }
  }
}

