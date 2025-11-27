// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jar_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Jar _$JarFromJson(Map<String, dynamic> json) {
  return _Jar.fromJson(json);
}

/// @nodoc
mixin _$Jar {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  double get percentage => throw _privateConstructorUsedError;
  @HiveField(3)
  double get balance => throw _privateConstructorUsedError;
  @HiveField(4)
  List<String> get transactionIds => throw _privateConstructorUsedError;
  @HiveField(5)
  DateTime? get lastUpdated => throw _privateConstructorUsedError;
  @HiveField(6)
  bool get isDefault => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $JarCopyWith<Jar> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JarCopyWith<$Res> {
  factory $JarCopyWith(Jar value, $Res Function(Jar) then) =
      _$JarCopyWithImpl<$Res, Jar>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) double percentage,
      @HiveField(3) double balance,
      @HiveField(4) List<String> transactionIds,
      @HiveField(5) DateTime? lastUpdated,
      @HiveField(6) bool isDefault});
}

/// @nodoc
class _$JarCopyWithImpl<$Res, $Val extends Jar> implements $JarCopyWith<$Res> {
  _$JarCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? percentage = null,
    Object? balance = null,
    Object? transactionIds = null,
    Object? lastUpdated = freezed,
    Object? isDefault = null,
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
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      transactionIds: null == transactionIds
          ? _value.transactionIds
          : transactionIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JarImplCopyWith<$Res> implements $JarCopyWith<$Res> {
  factory _$$JarImplCopyWith(_$JarImpl value, $Res Function(_$JarImpl) then) =
      __$$JarImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) double percentage,
      @HiveField(3) double balance,
      @HiveField(4) List<String> transactionIds,
      @HiveField(5) DateTime? lastUpdated,
      @HiveField(6) bool isDefault});
}

/// @nodoc
class __$$JarImplCopyWithImpl<$Res> extends _$JarCopyWithImpl<$Res, _$JarImpl>
    implements _$$JarImplCopyWith<$Res> {
  __$$JarImplCopyWithImpl(_$JarImpl _value, $Res Function(_$JarImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? percentage = null,
    Object? balance = null,
    Object? transactionIds = null,
    Object? lastUpdated = freezed,
    Object? isDefault = null,
  }) {
    return _then(_$JarImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      balance: null == balance
          ? _value.balance
          : balance // ignore: cast_nullable_to_non_nullable
              as double,
      transactionIds: null == transactionIds
          ? _value._transactionIds
          : transactionIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JarImpl implements _Jar {
  const _$JarImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.name,
      @HiveField(2) this.percentage = 0,
      @HiveField(3) this.balance = 0,
      @HiveField(4) final List<String> transactionIds = const <String>[],
      @HiveField(5) this.lastUpdated,
      @HiveField(6) this.isDefault = false})
      : _transactionIds = transactionIds;

  factory _$JarImpl.fromJson(Map<String, dynamic> json) =>
      _$$JarImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @JsonKey()
  @HiveField(2)
  final double percentage;
  @override
  @JsonKey()
  @HiveField(3)
  final double balance;
  final List<String> _transactionIds;
  @override
  @JsonKey()
  @HiveField(4)
  List<String> get transactionIds {
    if (_transactionIds is EqualUnmodifiableListView) return _transactionIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transactionIds);
  }

  @override
  @HiveField(5)
  final DateTime? lastUpdated;
  @override
  @JsonKey()
  @HiveField(6)
  final bool isDefault;

  @override
  String toString() {
    return 'Jar(id: $id, name: $name, percentage: $percentage, balance: $balance, transactionIds: $transactionIds, lastUpdated: $lastUpdated, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JarImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            (identical(other.balance, balance) || other.balance == balance) &&
            const DeepCollectionEquality()
                .equals(other._transactionIds, _transactionIds) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      percentage,
      balance,
      const DeepCollectionEquality().hash(_transactionIds),
      lastUpdated,
      isDefault);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$JarImplCopyWith<_$JarImpl> get copyWith =>
      __$$JarImplCopyWithImpl<_$JarImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JarImplToJson(
      this,
    );
  }
}

abstract class _Jar implements Jar {
  const factory _Jar(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String name,
      @HiveField(2) final double percentage,
      @HiveField(3) final double balance,
      @HiveField(4) final List<String> transactionIds,
      @HiveField(5) final DateTime? lastUpdated,
      @HiveField(6) final bool isDefault}) = _$JarImpl;

  factory _Jar.fromJson(Map<String, dynamic> json) = _$JarImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  double get percentage;
  @override
  @HiveField(3)
  double get balance;
  @override
  @HiveField(4)
  List<String> get transactionIds;
  @override
  @HiveField(5)
  DateTime? get lastUpdated;
  @override
  @HiveField(6)
  bool get isDefault;
  @override
  @JsonKey(ignore: true)
  _$$JarImplCopyWith<_$JarImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
