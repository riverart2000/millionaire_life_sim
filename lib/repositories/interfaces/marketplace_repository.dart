import '../../models/marketplace_item_model.dart';

abstract class MarketplaceRepository {
  Future<List<MarketplaceItem>> fetchLocalCatalog();
  Stream<List<MarketplaceItem>> watchLocalCatalog();
  Future<void> saveLocalItem(MarketplaceItem item);
  Future<void> saveLocalItems(List<MarketplaceItem> items);
  Future<void> deleteLocalItem(String id);
}

abstract class MarketplaceRemoteRepository {
  Stream<List<MarketplaceItem>> watchGlobalListings();
  Future<void> publishListing(MarketplaceItem item);
  Future<void> markAsSold(String itemId, {required String buyerId});
  Future<void> removeListing(String itemId);
}

