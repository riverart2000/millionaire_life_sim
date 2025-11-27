import '../core/constants/jar_constants.dart';
import '../core/utils/logger.dart';
import '../core/utils/result.dart';
import '../models/marketplace_item_model.dart';
import '../models/transaction_model.dart';
import '../repositories/interfaces/jar_repository.dart';
import '../repositories/interfaces/marketplace_repository.dart';
import 'jar_service.dart';
import 'transaction_service.dart';

class MarketplaceService {
  MarketplaceService({
    required MarketplaceRepository localRepository,
    MarketplaceRemoteRepository? remoteRepository,
    required JarRepository jarRepository,
    required JarService jarService,
    required TransactionService transactionService,
  })  : _localRepository = localRepository,
        _remoteRepository = remoteRepository,
        _jarRepository = jarRepository,
        _jarService = jarService,
        _transactionService = transactionService;

  final MarketplaceRepository _localRepository;
  final MarketplaceRemoteRepository? _remoteRepository;
  final JarRepository _jarRepository;
  final JarService _jarService;
  final TransactionService _transactionService;

  Future<Result<List<MarketplaceItem>>> loadCatalog() async {
    try {
      final items = await _localRepository.fetchLocalCatalog();
      return Success(items);
    } catch (error, stackTrace) {
      logError('Failed to load catalog', error, stackTrace);
      return Failure(error, stackTrace);
    }
  }

  Future<Result<void>> seedCatalog(List<MarketplaceItem> items) async {
    try {
      await _localRepository.saveLocalItems(items);
      return const Success(null);
    } catch (error, stackTrace) {
      logError('Failed to seed catalog', error, stackTrace);
      return Failure(error, stackTrace);
    }
  }

  Future<Result<void>> listItemForSale({
    required String userId,
    required MarketplaceItem item,
  }) async {
    try {
      final listing = item.copyWith(
        ownerId: userId,
        sellerId: userId,
        isListed: true,
        listedAt: DateTime.now(),
      );
      await _localRepository.saveLocalItem(listing);
      // Sync to Firebase if available
      if (_remoteRepository != null) {
        try {
          await _remoteRepository.publishListing(listing);
          logInfo('✅ Listing synced to Firebase');
        } catch (e) {
          logInfo('⚠️ Could not sync listing to Firebase: $e');
        }
      }
      return const Success(null);
    } catch (error, stackTrace) {
      logError('Failed to list item', error, stackTrace);
      return Failure(error, stackTrace);
    }
  }

  Future<Result<void>> cancelListing(String itemId) async {
    try {
      await _localRepository.deleteLocalItem(itemId);
      // Sync to Firebase if available
      if (_remoteRepository != null) {
        try {
          await _remoteRepository.removeListing(itemId);
          logInfo('✅ Listing removal synced to Firebase');
        } catch (e) {
          logInfo('⚠️ Could not sync listing removal to Firebase: $e');
        }
      }
      return const Success(null);
    } catch (error, stackTrace) {
      logError('Failed to cancel listing', error, stackTrace);
      return Failure(error, stackTrace);
    }
  }

  Future<Result<void>> purchaseItem({
    required String userId,
    required String sellerId,
    required MarketplaceItem item,
  }) async {
    try {
      final jar = await _jarRepository.findById(item.requiredJar);
      if (jar == null) {
        throw StateError('Required jar ${item.requiredJar} not found');
      }
      if (jar.balance < item.price) {
        throw StateError('Insufficient balance in ${jar.name} jar');
      }

      await _jarService.withdraw(
        userId: userId,
        jarId: item.requiredJar,
        amount: item.price,
        description: 'Purchased ${item.name}',
        kind: TransactionKind.purchase,
      );

      await _jarService.deposit(
        userId: sellerId,
        jarId: JarConstants.ffa,
        amount: item.price,
        description: 'Sale proceeds ${item.name}',
        kind: TransactionKind.sale,
      );

      final updatedItem = item.copyWith(
        isListed: false,
        buyerId: userId,
        soldAt: DateTime.now(),
      );
      await _localRepository.saveLocalItem(updatedItem);
      
      // Sync to Firebase if available
      if (_remoteRepository != null) {
        try {
          await _remoteRepository.markAsSold(item.id, buyerId: userId);
          logInfo('✅ Purchase synced to Firebase');
        } catch (e) {
          logInfo('⚠️ Could not sync purchase to Firebase: $e');
        }
      }

      await _transactionService.logTransaction(
        userId: userId,
        jarId: item.requiredJar,
        amount: -item.price,
        kind: TransactionKind.purchase,
        description: 'Bought ${item.name}',
        counterpartyId: sellerId,
        itemId: item.id,
      );
      await _transactionService.logTransaction(
        userId: sellerId,
        jarId: JarConstants.ffa,
        amount: item.price,
        kind: TransactionKind.sale,
        description: 'Sold ${item.name}',
        counterpartyId: userId,
        itemId: item.id,
      );

      return const Success(null);
    } catch (error, stackTrace) {
      logError('Failed to complete purchase', error, stackTrace);
      return Failure(error, stackTrace);
    }
  }

  Stream<List<MarketplaceItem>> watchLocalCatalog() {
    return _localRepository.watchLocalCatalog();
  }

  Stream<List<MarketplaceItem>> watchGlobalListings() {
    // Fall back to local catalog if remote repository is not available
    if (_remoteRepository == null) {
      logInfo('Remote repository not available, using local catalog');
      return _localRepository.watchLocalCatalog();
    }
    return _remoteRepository.watchGlobalListings();
  }
}

