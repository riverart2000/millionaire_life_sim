import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../core/utils/logger.dart';
import '../core/utils/result.dart';
import '../models/marketplace_item_model.dart';
import '../repositories/interfaces/marketplace_repository.dart';

class DataSeedService {
  DataSeedService({
    required MarketplaceRepository marketplaceRepository,
    MarketplaceRemoteRepository? marketplaceRemoteRepository,
  })  : _marketplaceRepository = marketplaceRepository,
        _marketplaceRemoteRepository = marketplaceRemoteRepository;

  final MarketplaceRepository _marketplaceRepository;
  final MarketplaceRemoteRepository? _marketplaceRemoteRepository;

  Future<Result<void>> seedMarketplaceFromAsset(String assetPath) async {
    try {
      final raw = await rootBundle.loadString(assetPath);
      final list = (jsonDecode(raw) as List<dynamic>)
          .map((e) => MarketplaceItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      await _marketplaceRepository.saveLocalItems(list);
      return const Success(null);
    } catch (error, stackTrace) {
      logError('Failed to seed marketplace data', error, stackTrace);
      return Failure(error, stackTrace);
    }
  }

  /// Sync marketplace items from asset to Firebase if Firebase is available
  Future<Result<void>> syncMarketplaceToFirebase(String assetPath) async {
    try {
      if (_marketplaceRemoteRepository == null) {
        logInfo('Firebase not available, skipping marketplace sync to cloud');
        return const Success(null);
      }

      final raw = await rootBundle.loadString(assetPath);
      final items = (jsonDecode(raw) as List<dynamic>)
          .map((e) => MarketplaceItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();

      logInfo('Syncing ${items.length} marketplace items to Firebase...');
      
      for (final item in items) {
        try {
          // Publish each item as a global listing (not owned by anyone initially)
          final globalItem = item.copyWith(
            isListed: true,
            listedAt: DateTime.now(),
            ownerId: null, // Available for anyone to purchase
          );
          await _marketplaceRemoteRepository.publishListing(globalItem);
          logInfo('✅ Synced: ${item.name}');
        } catch (e) {
          logError('Failed to sync item: ${item.name}', e, null);
          // Continue with other items even if one fails
        }
      }
      
      logInfo('✅ Marketplace sync to Firebase complete');
      return const Success(null);
    } catch (error, stackTrace) {
      logError('Failed to sync marketplace to Firebase', error, stackTrace);
      return Failure(error, stackTrace);
    }
  }
}

