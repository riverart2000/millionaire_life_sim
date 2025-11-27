import 'package:hive/hive.dart';

import '../../core/constants/hive_box_constants.dart';
import '../../core/utils/stream_extensions.dart';
import '../../models/marketplace_item_model.dart';
import '../interfaces/marketplace_repository.dart';

class HiveMarketplaceRepository implements MarketplaceRepository {
  HiveMarketplaceRepository({Box<MarketplaceItem>? box})
      : _box = box ?? Hive.box<MarketplaceItem>(HiveBoxConstants.marketplaceItems);

  final Box<MarketplaceItem> _box;

  @override
  Future<void> deleteLocalItem(String id) async {
    await _box.delete(id);
  }

  @override
  Future<List<MarketplaceItem>> fetchLocalCatalog() async {
    return _box.values.toList(growable: false);
  }

  @override
  Future<void> saveLocalItem(MarketplaceItem item) async {
    await _box.put(item.id, item);
  }

  @override
  Future<void> saveLocalItems(List<MarketplaceItem> items) async {
    final entries = {for (final item in items) item.id: item};
    await _box.putAll(entries);
  }

  @override
  Stream<List<MarketplaceItem>> watchLocalCatalog() {
    return _box
        .watch()
        .map((_) => _box.values.toList(growable: false))
        .startWith(_box.values.toList(growable: false));
  }
}

