import '../core/utils/logger.dart';
import '../core/utils/result.dart';
import '../models/jar_model.dart';
import '../models/marketplace_item_model.dart';
import '../models/transaction_model.dart';
import '../models/user_profile_model.dart';
import '../repositories/interfaces/jar_repository.dart';
import '../repositories/interfaces/marketplace_repository.dart';
import '../repositories/interfaces/transaction_repository.dart';
import '../repositories/interfaces/user_repository.dart';

class SyncService {
  SyncService({
    required JarRepository jarRepository,
    required JarRemoteRepository jarRemoteRepository,
    required TransactionRepository transactionRepository,
    required TransactionRemoteRepository transactionRemoteRepository,
    required UserRepository userRepository,
    required UserRemoteRepository userRemoteRepository,
    required MarketplaceRepository marketplaceRepository,
    required MarketplaceRemoteRepository marketplaceRemoteRepository,
  })  : _jarRepository = jarRepository,
        _jarRemoteRepository = jarRemoteRepository,
        _transactionRepository = transactionRepository,
        _transactionRemoteRepository = transactionRemoteRepository,
        _userRepository = userRepository,
        _userRemoteRepository = userRemoteRepository,
        _marketplaceRepository = marketplaceRepository,
        _marketplaceRemoteRepository = marketplaceRemoteRepository;

  final JarRepository _jarRepository;
  final JarRemoteRepository _jarRemoteRepository;
  final TransactionRepository _transactionRepository;
  final TransactionRemoteRepository _transactionRemoteRepository;
  final UserRepository _userRepository;
  final UserRemoteRepository _userRemoteRepository;
  final MarketplaceRepository _marketplaceRepository;
  final MarketplaceRemoteRepository _marketplaceRemoteRepository;

  Future<Result<void>> pullUserData(String userId) async {
    try {
      final profile = await _userRemoteRepository.watchProfile(userId: userId).first;
      if (profile != null) {
        await _userRepository.saveProfile(profile.copyWith(lastSyncedAt: DateTime.now()));
      }

      final jars = await _jarRemoteRepository.watchAll(userId: userId).first;
      await _jarRepository.saveAll(jars);

      final transactions = await _transactionRemoteRepository.watchAll(userId: userId).first;
      await _transactionRepository.saveAll(transactions);

      final listings = await _marketplaceRemoteRepository.watchGlobalListings().first;
      await _marketplaceRepository.saveLocalItems(listings);

      final localProfile = await _userRepository.fetchProfile();
      if (localProfile != null) {
        await _userRepository.saveProfile(localProfile.copyWith(lastSyncedAt: DateTime.now()));
      }

      return const Success(null);
    } catch (error, stackTrace) {
      logError('Failed to pull user data', error, stackTrace);
      return Failure(error, stackTrace);
    }
  }

  Future<Result<void>> pushUserData({
    required String userId,
    UserProfile? profile,
    List<Jar>? jars,
    List<MoneyTransaction>? transactions,
    List<MarketplaceItem>? listings,
  }) async {
    try {
      if (profile != null) {
        final updatedProfile = profile.copyWith(lastSyncedAt: DateTime.now());
        await _userRemoteRepository.upsertProfile(userId: userId, profile: updatedProfile);
        await _userRepository.saveProfile(updatedProfile);
      }
      if (jars != null) {
        await _jarRemoteRepository.upsertJars(userId: userId, jars: jars);
      }
      if (transactions != null) {
        await _transactionRemoteRepository.upsertAll(userId: userId, transactions: transactions);
      }
      if (listings != null) {
        for (final item in listings) {
          await _marketplaceRemoteRepository.publishListing(item);
        }
      }
      return const Success(null);
    } catch (error, stackTrace) {
      logError('Failed to push user data', error, stackTrace);
      return Failure(error, stackTrace);
    }
  }
}

