// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'investment_price_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InvestmentPrice _$InvestmentPriceFromJson(Map<String, dynamic> json) {
  return _InvestmentPrice.fromJson(json);
}

/// @nodoc
mixin _$InvestmentPrice {
  @HiveField(0)
  String get symbol => throw _privateConstructorUsedError;
  @HiveField(1)
  double get price => throw _privateConstructorUsedError;
  @HiveField(2)
  DateTime get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InvestmentPriceCopyWith<InvestmentPrice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InvestmentPriceCopyWith<$Res> {
  factory $InvestmentPriceCopyWith(
          InvestmentPrice value, $Res Function(InvestmentPrice) then) =
      _$InvestmentPriceCopyWithImpl<$Res, InvestmentPrice>;
  @useResult
  $Res call(
      {@HiveField(0) String symbol,
      @HiveField(1) double price,
      @HiveField(2) DateTime timestamp});
}

/// @nodoc
class _$InvestmentPriceCopyWithImpl<$Res, $Val extends InvestmentPrice>
    implements $InvestmentPriceCopyWith<$Res> {
  _$InvestmentPriceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? price = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InvestmentPriceImplCopyWith<$Res>
    implements $InvestmentPriceCopyWith<$Res> {
  factory _$$InvestmentPriceImplCopyWith(_$InvestmentPriceImpl value,
          $Res Function(_$InvestmentPriceImpl) then) =
      __$$InvestmentPriceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String symbol,
      @HiveField(1) double price,
      @HiveField(2) DateTime timestamp});
}

/// @nodoc
class __$$InvestmentPriceImplCopyWithImpl<$Res>
    extends _$InvestmentPriceCopyWithImpl<$Res, _$InvestmentPriceImpl>
    implements _$$InvestmentPriceImplCopyWith<$Res> {
  __$$InvestmentPriceImplCopyWithImpl(
      _$InvestmentPriceImpl _value, $Res Function(_$InvestmentPriceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? symbol = null,
    Object? price = null,
    Object? timestamp = null,
  }) {
    return _then(_$InvestmentPriceImpl(
      symbol: null == symbol
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$InvestmentPriceImpl implements _InvestmentPrice {
  const _$InvestmentPriceImpl(
      {@HiveField(0) required this.symbol,
      @HiveField(1) required this.price,
      @HiveField(2) required this.timestamp});

  factory _$InvestmentPriceImpl.fromJson(Map<String, dynamic> json) =>
      _$$InvestmentPriceImplFromJson(json);

  @override
  @HiveField(0)
  final String symbol;
  @override
  @HiveField(1)
  final double price;
  @override
  @HiveField(2)
  final DateTime timestamp;

  @override
  String toString() {
    return 'InvestmentPrice(symbol: $symbol, price: $price, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InvestmentPriceImpl &&
            (identical(other.symbol, symbol) || other.symbol == symbol) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, symbol, price, timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InvestmentPriceImplCopyWith<_$InvestmentPriceImpl> get copyWith =>
      __$$InvestmentPriceImplCopyWithImpl<_$InvestmentPriceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InvestmentPriceImplToJson(
      this,
    );
  }
}

abstract class _InvestmentPrice implements InvestmentPrice {
  const factory _InvestmentPrice(
      {@HiveField(0) required final String symbol,
      @HiveField(1) required final double price,
      @HiveField(2) required final DateTime timestamp}) = _$InvestmentPriceImpl;

  factory _InvestmentPrice.fromJson(Map<String, dynamic> json) =
      _$InvestmentPriceImpl.fromJson;

  @override
  @HiveField(0)
  String get symbol;
  @override
  @HiveField(1)
  double get price;
  @override
  @HiveField(2)
  DateTime get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$InvestmentPriceImplCopyWith<_$InvestmentPriceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
