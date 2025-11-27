// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'marketplace_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MarketplaceItem _$MarketplaceItemFromJson(Map<String, dynamic> json) {
  return _MarketplaceItem.fromJson(json);
}

/// @nodoc
mixin _$MarketplaceItem {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  String get category => throw _privateConstructorUsedError;
  @HiveField(3)
  String get requiredJar => throw _privateConstructorUsedError;
  @HiveField(4)
  double get price => throw _privateConstructorUsedError;
  @HiveField(5)
  String get description => throw _privateConstructorUsedError;
  @HiveField(6)
  String get imageUrl => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get ownerId => throw _privateConstructorUsedError;
  @HiveField(8)
  bool get isListed => throw _privateConstructorUsedError;
  @HiveField(9)
  DateTime? get listedAt => throw _privateConstructorUsedError;
  @HiveField(10)
  DateTime? get soldAt => throw _privateConstructorUsedError;
  @HiveField(11)
  String? get sellerId => throw _privateConstructorUsedError;
  @HiveField(12)
  String? get buyerId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MarketplaceItemCopyWith<MarketplaceItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarketplaceItemCopyWith<$Res> {
  factory $MarketplaceItemCopyWith(
          MarketplaceItem value, $Res Function(MarketplaceItem) then) =
      _$MarketplaceItemCopyWithImpl<$Res, MarketplaceItem>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String category,
      @HiveField(3) String requiredJar,
      @HiveField(4) double price,
      @HiveField(5) String description,
      @HiveField(6) String imageUrl,
      @HiveField(7) String? ownerId,
      @HiveField(8) bool isListed,
      @HiveField(9) DateTime? listedAt,
      @HiveField(10) DateTime? soldAt,
      @HiveField(11) String? sellerId,
      @HiveField(12) String? buyerId});
}

/// @nodoc
class _$MarketplaceItemCopyWithImpl<$Res, $Val extends MarketplaceItem>
    implements $MarketplaceItemCopyWith<$Res> {
  _$MarketplaceItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? requiredJar = null,
    Object? price = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? ownerId = freezed,
    Object? isListed = null,
    Object? listedAt = freezed,
    Object? soldAt = freezed,
    Object? sellerId = freezed,
    Object? buyerId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      requiredJar: null == requiredJar
          ? _value.requiredJar
          : requiredJar // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String?,
      isListed: null == isListed
          ? _value.isListed
          : isListed // ignore: cast_nullable_to_non_nullable
              as bool,
      listedAt: freezed == listedAt
          ? _value.listedAt
          : listedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      soldAt: freezed == soldAt
          ? _value.soldAt
          : soldAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sellerId: freezed == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String?,
      buyerId: freezed == buyerId
          ? _value.buyerId
          : buyerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MarketplaceItemImplCopyWith<$Res>
    implements $MarketplaceItemCopyWith<$Res> {
  factory _$$MarketplaceItemImplCopyWith(_$MarketplaceItemImpl value,
          $Res Function(_$MarketplaceItemImpl) then) =
      __$$MarketplaceItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String category,
      @HiveField(3) String requiredJar,
      @HiveField(4) double price,
      @HiveField(5) String description,
      @HiveField(6) String imageUrl,
      @HiveField(7) String? ownerId,
      @HiveField(8) bool isListed,
      @HiveField(9) DateTime? listedAt,
      @HiveField(10) DateTime? soldAt,
      @HiveField(11) String? sellerId,
      @HiveField(12) String? buyerId});
}

/// @nodoc
class __$$MarketplaceItemImplCopyWithImpl<$Res>
    extends _$MarketplaceItemCopyWithImpl<$Res, _$MarketplaceItemImpl>
    implements _$$MarketplaceItemImplCopyWith<$Res> {
  __$$MarketplaceItemImplCopyWithImpl(
      _$MarketplaceItemImpl _value, $Res Function(_$MarketplaceItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? requiredJar = null,
    Object? price = null,
    Object? description = null,
    Object? imageUrl = null,
    Object? ownerId = freezed,
    Object? isListed = null,
    Object? listedAt = freezed,
    Object? soldAt = freezed,
    Object? sellerId = freezed,
    Object? buyerId = freezed,
  }) {
    return _then(_$MarketplaceItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      requiredJar: null == requiredJar
          ? _value.requiredJar
          : requiredJar // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String?,
      isListed: null == isListed
          ? _value.isListed
          : isListed // ignore: cast_nullable_to_non_nullable
              as bool,
      listedAt: freezed == listedAt
          ? _value.listedAt
          : listedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      soldAt: freezed == soldAt
          ? _value.soldAt
          : soldAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sellerId: freezed == sellerId
          ? _value.sellerId
          : sellerId // ignore: cast_nullable_to_non_nullable
              as String?,
      buyerId: freezed == buyerId
          ? _value.buyerId
          : buyerId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MarketplaceItemImpl extends _MarketplaceItem {
  const _$MarketplaceItemImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.name,
      @HiveField(2) required this.category,
      @HiveField(3) required this.requiredJar,
      @HiveField(4) required this.price,
      @HiveField(5) this.description = '',
      @HiveField(6) this.imageUrl = '',
      @HiveField(7) this.ownerId,
      @HiveField(8) this.isListed = false,
      @HiveField(9) this.listedAt,
      @HiveField(10) this.soldAt,
      @HiveField(11) this.sellerId,
      @HiveField(12) this.buyerId})
      : super._();

  factory _$MarketplaceItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$MarketplaceItemImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String category;
  @override
  @HiveField(3)
  final String requiredJar;
  @override
  @HiveField(4)
  final double price;
  @override
  @JsonKey()
  @HiveField(5)
  final String description;
  @override
  @JsonKey()
  @HiveField(6)
  final String imageUrl;
  @override
  @HiveField(7)
  final String? ownerId;
  @override
  @JsonKey()
  @HiveField(8)
  final bool isListed;
  @override
  @HiveField(9)
  final DateTime? listedAt;
  @override
  @HiveField(10)
  final DateTime? soldAt;
  @override
  @HiveField(11)
  final String? sellerId;
  @override
  @HiveField(12)
  final String? buyerId;

  @override
  String toString() {
    return 'MarketplaceItem(id: $id, name: $name, category: $category, requiredJar: $requiredJar, price: $price, description: $description, imageUrl: $imageUrl, ownerId: $ownerId, isListed: $isListed, listedAt: $listedAt, soldAt: $soldAt, sellerId: $sellerId, buyerId: $buyerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MarketplaceItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.requiredJar, requiredJar) ||
                other.requiredJar == requiredJar) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.isListed, isListed) ||
                other.isListed == isListed) &&
            (identical(other.listedAt, listedAt) ||
                other.listedAt == listedAt) &&
            (identical(other.soldAt, soldAt) || other.soldAt == soldAt) &&
            (identical(other.sellerId, sellerId) ||
                other.sellerId == sellerId) &&
            (identical(other.buyerId, buyerId) || other.buyerId == buyerId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      category,
      requiredJar,
      price,
      description,
      imageUrl,
      ownerId,
      isListed,
      listedAt,
      soldAt,
      sellerId,
      buyerId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MarketplaceItemImplCopyWith<_$MarketplaceItemImpl> get copyWith =>
      __$$MarketplaceItemImplCopyWithImpl<_$MarketplaceItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MarketplaceItemImplToJson(
      this,
    );
  }
}

abstract class _MarketplaceItem extends MarketplaceItem {
  const factory _MarketplaceItem(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String name,
      @HiveField(2) required final String category,
      @HiveField(3) required final String requiredJar,
      @HiveField(4) required final double price,
      @HiveField(5) final String description,
      @HiveField(6) final String imageUrl,
      @HiveField(7) final String? ownerId,
      @HiveField(8) final bool isListed,
      @HiveField(9) final DateTime? listedAt,
      @HiveField(10) final DateTime? soldAt,
      @HiveField(11) final String? sellerId,
      @HiveField(12) final String? buyerId}) = _$MarketplaceItemImpl;
  const _MarketplaceItem._() : super._();

  factory _MarketplaceItem.fromJson(Map<String, dynamic> json) =
      _$MarketplaceItemImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  String get category;
  @override
  @HiveField(3)
  String get requiredJar;
  @override
  @HiveField(4)
  double get price;
  @override
  @HiveField(5)
  String get description;
  @override
  @HiveField(6)
  String get imageUrl;
  @override
  @HiveField(7)
  String? get ownerId;
  @override
  @HiveField(8)
  bool get isListed;
  @override
  @HiveField(9)
  DateTime? get listedAt;
  @override
  @HiveField(10)
  DateTime? get soldAt;
  @override
  @HiveField(11)
  String? get sellerId;
  @override
  @HiveField(12)
  String? get buyerId;
  @override
  @JsonKey(ignore: true)
  _$$MarketplaceItemImplCopyWith<_$MarketplaceItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
