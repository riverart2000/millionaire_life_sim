// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MoneyTransaction _$MoneyTransactionFromJson(Map<String, dynamic> json) {
  return _MoneyTransaction.fromJson(json);
}

/// @nodoc
mixin _$MoneyTransaction {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get jarId => throw _privateConstructorUsedError;
  @HiveField(2)
  double get amount => throw _privateConstructorUsedError;
  @HiveField(3)
  TransactionKind get kind => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime get date => throw _privateConstructorUsedError;
  @HiveField(5)
  String get description => throw _privateConstructorUsedError;
  @HiveField(6)
  String? get counterpartyId => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get itemId => throw _privateConstructorUsedError;
  @HiveField(8)
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MoneyTransactionCopyWith<MoneyTransaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoneyTransactionCopyWith<$Res> {
  factory $MoneyTransactionCopyWith(
          MoneyTransaction value, $Res Function(MoneyTransaction) then) =
      _$MoneyTransactionCopyWithImpl<$Res, MoneyTransaction>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String jarId,
      @HiveField(2) double amount,
      @HiveField(3) TransactionKind kind,
      @HiveField(4) DateTime date,
      @HiveField(5) String description,
      @HiveField(6) String? counterpartyId,
      @HiveField(7) String? itemId,
      @HiveField(8) Map<String, dynamic>? metadata});
}

/// @nodoc
class _$MoneyTransactionCopyWithImpl<$Res, $Val extends MoneyTransaction>
    implements $MoneyTransactionCopyWith<$Res> {
  _$MoneyTransactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? jarId = null,
    Object? amount = null,
    Object? kind = null,
    Object? date = null,
    Object? description = null,
    Object? counterpartyId = freezed,
    Object? itemId = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      jarId: null == jarId
          ? _value.jarId
          : jarId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as TransactionKind,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyId: freezed == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      itemId: freezed == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MoneyTransactionImplCopyWith<$Res>
    implements $MoneyTransactionCopyWith<$Res> {
  factory _$$MoneyTransactionImplCopyWith(_$MoneyTransactionImpl value,
          $Res Function(_$MoneyTransactionImpl) then) =
      __$$MoneyTransactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String jarId,
      @HiveField(2) double amount,
      @HiveField(3) TransactionKind kind,
      @HiveField(4) DateTime date,
      @HiveField(5) String description,
      @HiveField(6) String? counterpartyId,
      @HiveField(7) String? itemId,
      @HiveField(8) Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$MoneyTransactionImplCopyWithImpl<$Res>
    extends _$MoneyTransactionCopyWithImpl<$Res, _$MoneyTransactionImpl>
    implements _$$MoneyTransactionImplCopyWith<$Res> {
  __$$MoneyTransactionImplCopyWithImpl(_$MoneyTransactionImpl _value,
      $Res Function(_$MoneyTransactionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? jarId = null,
    Object? amount = null,
    Object? kind = null,
    Object? date = null,
    Object? description = null,
    Object? counterpartyId = freezed,
    Object? itemId = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$MoneyTransactionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      jarId: null == jarId
          ? _value.jarId
          : jarId // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as TransactionKind,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      counterpartyId: freezed == counterpartyId
          ? _value.counterpartyId
          : counterpartyId // ignore: cast_nullable_to_non_nullable
              as String?,
      itemId: freezed == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MoneyTransactionImpl implements _MoneyTransaction {
  const _$MoneyTransactionImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.jarId,
      @HiveField(2) required this.amount,
      @HiveField(3) required this.kind,
      @HiveField(4) required this.date,
      @HiveField(5) this.description = '',
      @HiveField(6) this.counterpartyId,
      @HiveField(7) this.itemId,
      @HiveField(8) final Map<String, dynamic>? metadata})
      : _metadata = metadata;

  factory _$MoneyTransactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MoneyTransactionImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String jarId;
  @override
  @HiveField(2)
  final double amount;
  @override
  @HiveField(3)
  final TransactionKind kind;
  @override
  @HiveField(4)
  final DateTime date;
  @override
  @JsonKey()
  @HiveField(5)
  final String description;
  @override
  @HiveField(6)
  final String? counterpartyId;
  @override
  @HiveField(7)
  final String? itemId;
  final Map<String, dynamic>? _metadata;
  @override
  @HiveField(8)
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'MoneyTransaction(id: $id, jarId: $jarId, amount: $amount, kind: $kind, date: $date, description: $description, counterpartyId: $counterpartyId, itemId: $itemId, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoneyTransactionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.jarId, jarId) || other.jarId == jarId) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.counterpartyId, counterpartyId) ||
                other.counterpartyId == counterpartyId) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      jarId,
      amount,
      kind,
      date,
      description,
      counterpartyId,
      itemId,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MoneyTransactionImplCopyWith<_$MoneyTransactionImpl> get copyWith =>
      __$$MoneyTransactionImplCopyWithImpl<_$MoneyTransactionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MoneyTransactionImplToJson(
      this,
    );
  }
}

abstract class _MoneyTransaction implements MoneyTransaction {
  const factory _MoneyTransaction(
          {@HiveField(0) required final String id,
          @HiveField(1) required final String jarId,
          @HiveField(2) required final double amount,
          @HiveField(3) required final TransactionKind kind,
          @HiveField(4) required final DateTime date,
          @HiveField(5) final String description,
          @HiveField(6) final String? counterpartyId,
          @HiveField(7) final String? itemId,
          @HiveField(8) final Map<String, dynamic>? metadata}) =
      _$MoneyTransactionImpl;

  factory _MoneyTransaction.fromJson(Map<String, dynamic> json) =
      _$MoneyTransactionImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get jarId;
  @override
  @HiveField(2)
  double get amount;
  @override
  @HiveField(3)
  TransactionKind get kind;
  @override
  @HiveField(4)
  DateTime get date;
  @override
  @HiveField(5)
  String get description;
  @override
  @HiveField(6)
  String? get counterpartyId;
  @override
  @HiveField(7)
  String? get itemId;
  @override
  @HiveField(8)
  Map<String, dynamic>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$MoneyTransactionImplCopyWith<_$MoneyTransactionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
