// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapterGenerated extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 3;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      dailyIncome: fields[3] as double,
      jarPercentages: (fields[4] as Map).cast<String, double>(),
      autoSimulateDaily: fields[5] as bool,
      lastSyncedAt: fields[6] as DateTime?,
      syncEnabled: fields[7] as bool,
      unallocatedBalance: fields[8] as double,
      mindsetLevel: fields[9] as double,
      purchasedCourses: (fields[10] as List).cast<String>(),
      dayCounter: fields[11] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.dailyIncome)
      ..writeByte(4)
      ..write(obj.jarPercentages)
      ..writeByte(5)
      ..write(obj.autoSimulateDaily)
      ..writeByte(6)
      ..write(obj.lastSyncedAt)
      ..writeByte(7)
      ..write(obj.syncEnabled)
      ..writeByte(8)
      ..write(obj.unallocatedBalance)
      ..writeByte(9)
      ..write(obj.mindsetLevel)
      ..writeByte(10)
      ..write(obj.purchasedCourses)
      ..writeByte(11)
      ..write(obj.dayCounter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapterGenerated &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      dailyIncome: (json['dailyIncome'] as num?)?.toDouble() ?? 0,
      jarPercentages: (json['jarPercentages'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const <String, double>{},
      autoSimulateDaily: json['autoSimulateDaily'] as bool? ?? true,
      lastSyncedAt: json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
      syncEnabled: json['syncEnabled'] as bool? ?? true,
      unallocatedBalance: (json['unallocatedBalance'] as num?)?.toDouble() ?? 0,
      mindsetLevel: (json['mindsetLevel'] as num?)?.toDouble() ?? 1.0,
      purchasedCourses: (json['purchasedCourses'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      dayCounter: (json['dayCounter'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'dailyIncome': instance.dailyIncome,
      'jarPercentages': instance.jarPercentages,
      'autoSimulateDaily': instance.autoSimulateDaily,
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
      'syncEnabled': instance.syncEnabled,
      'unallocatedBalance': instance.unallocatedBalance,
      'mindsetLevel': instance.mindsetLevel,
      'purchasedCourses': instance.purchasedCourses,
      'dayCounter': instance.dayCounter,
    };
