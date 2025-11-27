// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MarketplaceItemAdapter extends TypeAdapter<MarketplaceItem> {
  @override
  final int typeId = 2;

  @override
  MarketplaceItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MarketplaceItem(
      id: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as String,
      requiredJar: fields[3] as String,
      price: fields[4] as double,
      description: fields[5] as String,
      imageUrl: fields[6] as String,
      ownerId: fields[7] as String?,
      isListed: fields[8] as bool,
      listedAt: fields[9] as DateTime?,
      soldAt: fields[10] as DateTime?,
      sellerId: fields[11] as String?,
      buyerId: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MarketplaceItem obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.requiredJar)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.ownerId)
      ..writeByte(8)
      ..write(obj.isListed)
      ..writeByte(9)
      ..write(obj.listedAt)
      ..writeByte(10)
      ..write(obj.soldAt)
      ..writeByte(11)
      ..write(obj.sellerId)
      ..writeByte(12)
      ..write(obj.buyerId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarketplaceItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MarketplaceItemImpl _$$MarketplaceItemImplFromJson(
        Map<String, dynamic> json) =>
    _$MarketplaceItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      requiredJar: json['requiredJar'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      ownerId: json['ownerId'] as String?,
      isListed: json['isListed'] as bool? ?? false,
      listedAt: json['listedAt'] == null
          ? null
          : DateTime.parse(json['listedAt'] as String),
      soldAt: json['soldAt'] == null
          ? null
          : DateTime.parse(json['soldAt'] as String),
      sellerId: json['sellerId'] as String?,
      buyerId: json['buyerId'] as String?,
    );

Map<String, dynamic> _$$MarketplaceItemImplToJson(
        _$MarketplaceItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'requiredJar': instance.requiredJar,
      'price': instance.price,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'ownerId': instance.ownerId,
      'isListed': instance.isListed,
      'listedAt': instance.listedAt?.toIso8601String(),
      'soldAt': instance.soldAt?.toIso8601String(),
      'sellerId': instance.sellerId,
      'buyerId': instance.buyerId,
    };
