// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) {
  return _UserProfile.fromJson(json);
}

/// @nodoc
mixin _$UserProfile {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  String get email => throw _privateConstructorUsedError;
  @HiveField(3)
  double get dailyIncome => throw _privateConstructorUsedError;
  @HiveField(4)
  Map<String, double> get jarPercentages => throw _privateConstructorUsedError;
  @HiveField(5)
  bool get autoSimulateDaily => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime? get lastSyncedAt => throw _privateConstructorUsedError;
  @HiveField(7)
  bool get syncEnabled => throw _privateConstructorUsedError;
  @HiveField(8)
  double get unallocatedBalance => throw _privateConstructorUsedError;
  @HiveField(9)
  double get mindsetLevel => throw _privateConstructorUsedError;
  @HiveField(10)
  List<String> get purchasedCourses => throw _privateConstructorUsedError;
  @HiveField(11)
  int get dayCounter => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserProfileCopyWith<UserProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) then) =
      _$UserProfileCopyWithImpl<$Res, UserProfile>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String email,
      @HiveField(3) double dailyIncome,
      @HiveField(4) Map<String, double> jarPercentages,
      @HiveField(5) bool autoSimulateDaily,
      @HiveField(6) DateTime? lastSyncedAt,
      @HiveField(7) bool syncEnabled,
      @HiveField(8) double unallocatedBalance,
      @HiveField(9) double mindsetLevel,
      @HiveField(10) List<String> purchasedCourses,
      @HiveField(11) int dayCounter});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res, $Val extends UserProfile>
    implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? dailyIncome = null,
    Object? jarPercentages = null,
    Object? autoSimulateDaily = null,
    Object? lastSyncedAt = freezed,
    Object? syncEnabled = null,
    Object? unallocatedBalance = null,
    Object? mindsetLevel = null,
    Object? purchasedCourses = null,
    Object? dayCounter = null,
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
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      dailyIncome: null == dailyIncome
          ? _value.dailyIncome
          : dailyIncome // ignore: cast_nullable_to_non_nullable
              as double,
      jarPercentages: null == jarPercentages
          ? _value.jarPercentages
          : jarPercentages // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      autoSimulateDaily: null == autoSimulateDaily
          ? _value.autoSimulateDaily
          : autoSimulateDaily // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      syncEnabled: null == syncEnabled
          ? _value.syncEnabled
          : syncEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      unallocatedBalance: null == unallocatedBalance
          ? _value.unallocatedBalance
          : unallocatedBalance // ignore: cast_nullable_to_non_nullable
              as double,
      mindsetLevel: null == mindsetLevel
          ? _value.mindsetLevel
          : mindsetLevel // ignore: cast_nullable_to_non_nullable
              as double,
      purchasedCourses: null == purchasedCourses
          ? _value.purchasedCourses
          : purchasedCourses // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dayCounter: null == dayCounter
          ? _value.dayCounter
          : dayCounter // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProfileImplCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$$UserProfileImplCopyWith(
          _$UserProfileImpl value, $Res Function(_$UserProfileImpl) then) =
      __$$UserProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) String email,
      @HiveField(3) double dailyIncome,
      @HiveField(4) Map<String, double> jarPercentages,
      @HiveField(5) bool autoSimulateDaily,
      @HiveField(6) DateTime? lastSyncedAt,
      @HiveField(7) bool syncEnabled,
      @HiveField(8) double unallocatedBalance,
      @HiveField(9) double mindsetLevel,
      @HiveField(10) List<String> purchasedCourses,
      @HiveField(11) int dayCounter});
}

/// @nodoc
class __$$UserProfileImplCopyWithImpl<$Res>
    extends _$UserProfileCopyWithImpl<$Res, _$UserProfileImpl>
    implements _$$UserProfileImplCopyWith<$Res> {
  __$$UserProfileImplCopyWithImpl(
      _$UserProfileImpl _value, $Res Function(_$UserProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? dailyIncome = null,
    Object? jarPercentages = null,
    Object? autoSimulateDaily = null,
    Object? lastSyncedAt = freezed,
    Object? syncEnabled = null,
    Object? unallocatedBalance = null,
    Object? mindsetLevel = null,
    Object? purchasedCourses = null,
    Object? dayCounter = null,
  }) {
    return _then(_$UserProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      dailyIncome: null == dailyIncome
          ? _value.dailyIncome
          : dailyIncome // ignore: cast_nullable_to_non_nullable
              as double,
      jarPercentages: null == jarPercentages
          ? _value._jarPercentages
          : jarPercentages // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      autoSimulateDaily: null == autoSimulateDaily
          ? _value.autoSimulateDaily
          : autoSimulateDaily // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSyncedAt: freezed == lastSyncedAt
          ? _value.lastSyncedAt
          : lastSyncedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      syncEnabled: null == syncEnabled
          ? _value.syncEnabled
          : syncEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      unallocatedBalance: null == unallocatedBalance
          ? _value.unallocatedBalance
          : unallocatedBalance // ignore: cast_nullable_to_non_nullable
              as double,
      mindsetLevel: null == mindsetLevel
          ? _value.mindsetLevel
          : mindsetLevel // ignore: cast_nullable_to_non_nullable
              as double,
      purchasedCourses: null == purchasedCourses
          ? _value._purchasedCourses
          : purchasedCourses // ignore: cast_nullable_to_non_nullable
              as List<String>,
      dayCounter: null == dayCounter
          ? _value.dayCounter
          : dayCounter // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProfileImpl implements _UserProfile {
  const _$UserProfileImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.name,
      @HiveField(2) required this.email,
      @HiveField(3) this.dailyIncome = 0,
      @HiveField(4)
      final Map<String, double> jarPercentages = const <String, double>{},
      @HiveField(5) this.autoSimulateDaily = true,
      @HiveField(6) this.lastSyncedAt,
      @HiveField(7) this.syncEnabled = true,
      @HiveField(8) this.unallocatedBalance = 0,
      @HiveField(9) this.mindsetLevel = 1.0,
      @HiveField(10) final List<String> purchasedCourses = const <String>[],
      @HiveField(11) this.dayCounter = 1})
      : _jarPercentages = jarPercentages,
        _purchasedCourses = purchasedCourses;

  factory _$UserProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProfileImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String email;
  @override
  @JsonKey()
  @HiveField(3)
  final double dailyIncome;
  final Map<String, double> _jarPercentages;
  @override
  @JsonKey()
  @HiveField(4)
  Map<String, double> get jarPercentages {
    if (_jarPercentages is EqualUnmodifiableMapView) return _jarPercentages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_jarPercentages);
  }

  @override
  @JsonKey()
  @HiveField(5)
  final bool autoSimulateDaily;
  @override
  @HiveField(6)
  final DateTime? lastSyncedAt;
  @override
  @JsonKey()
  @HiveField(7)
  final bool syncEnabled;
  @override
  @JsonKey()
  @HiveField(8)
  final double unallocatedBalance;
  @override
  @JsonKey()
  @HiveField(9)
  final double mindsetLevel;
  final List<String> _purchasedCourses;
  @override
  @JsonKey()
  @HiveField(10)
  List<String> get purchasedCourses {
    if (_purchasedCourses is EqualUnmodifiableListView)
      return _purchasedCourses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_purchasedCourses);
  }

  @override
  @JsonKey()
  @HiveField(11)
  final int dayCounter;

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, email: $email, dailyIncome: $dailyIncome, jarPercentages: $jarPercentages, autoSimulateDaily: $autoSimulateDaily, lastSyncedAt: $lastSyncedAt, syncEnabled: $syncEnabled, unallocatedBalance: $unallocatedBalance, mindsetLevel: $mindsetLevel, purchasedCourses: $purchasedCourses, dayCounter: $dayCounter)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.dailyIncome, dailyIncome) ||
                other.dailyIncome == dailyIncome) &&
            const DeepCollectionEquality()
                .equals(other._jarPercentages, _jarPercentages) &&
            (identical(other.autoSimulateDaily, autoSimulateDaily) ||
                other.autoSimulateDaily == autoSimulateDaily) &&
            (identical(other.lastSyncedAt, lastSyncedAt) ||
                other.lastSyncedAt == lastSyncedAt) &&
            (identical(other.syncEnabled, syncEnabled) ||
                other.syncEnabled == syncEnabled) &&
            (identical(other.unallocatedBalance, unallocatedBalance) ||
                other.unallocatedBalance == unallocatedBalance) &&
            (identical(other.mindsetLevel, mindsetLevel) ||
                other.mindsetLevel == mindsetLevel) &&
            const DeepCollectionEquality()
                .equals(other._purchasedCourses, _purchasedCourses) &&
            (identical(other.dayCounter, dayCounter) ||
                other.dayCounter == dayCounter));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      email,
      dailyIncome,
      const DeepCollectionEquality().hash(_jarPercentages),
      autoSimulateDaily,
      lastSyncedAt,
      syncEnabled,
      unallocatedBalance,
      mindsetLevel,
      const DeepCollectionEquality().hash(_purchasedCourses),
      dayCounter);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      __$$UserProfileImplCopyWithImpl<_$UserProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProfileImplToJson(
      this,
    );
  }
}

abstract class _UserProfile implements UserProfile {
  const factory _UserProfile(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String name,
      @HiveField(2) required final String email,
      @HiveField(3) final double dailyIncome,
      @HiveField(4) final Map<String, double> jarPercentages,
      @HiveField(5) final bool autoSimulateDaily,
      @HiveField(6) final DateTime? lastSyncedAt,
      @HiveField(7) final bool syncEnabled,
      @HiveField(8) final double unallocatedBalance,
      @HiveField(9) final double mindsetLevel,
      @HiveField(10) final List<String> purchasedCourses,
      @HiveField(11) final int dayCounter}) = _$UserProfileImpl;

  factory _UserProfile.fromJson(Map<String, dynamic> json) =
      _$UserProfileImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  String get email;
  @override
  @HiveField(3)
  double get dailyIncome;
  @override
  @HiveField(4)
  Map<String, double> get jarPercentages;
  @override
  @HiveField(5)
  bool get autoSimulateDaily;
  @override
  @HiveField(6)
  DateTime? get lastSyncedAt;
  @override
  @HiveField(7)
  bool get syncEnabled;
  @override
  @HiveField(8)
  double get unallocatedBalance;
  @override
  @HiveField(9)
  double get mindsetLevel;
  @override
  @HiveField(10)
  List<String> get purchasedCourses;
  @override
  @HiveField(11)
  int get dayCounter;
  @override
  @JsonKey(ignore: true)
  _$$UserProfileImplCopyWith<_$UserProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
