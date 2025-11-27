import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'marketplace_item_model.freezed.dart';
part 'marketplace_item_model.g.dart';

@freezed
@HiveType(typeId: 2, adapterName: 'MarketplaceItemAdapter')
class MarketplaceItem with _$MarketplaceItem {
  const factory MarketplaceItem({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String category,
    @HiveField(3) required String requiredJar,
    @HiveField(4) required double price,
    @HiveField(5) @Default('') String description,
    @HiveField(6) @Default('') String imageUrl,
    @HiveField(7) String? ownerId,
    @HiveField(8) @Default(false) bool isListed,
    @HiveField(9) DateTime? listedAt,
    @HiveField(10) DateTime? soldAt,
    @HiveField(11) String? sellerId,
    @HiveField(12) String? buyerId,
  }) = _MarketplaceItem;

  const MarketplaceItem._();

  bool get isOwned => ownerId != null && ownerId!.isNotEmpty;

  factory MarketplaceItem.fromJson(Map<String, dynamic> json) => _$MarketplaceItemFromJson(json);
}

