import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
@HiveType(typeId: 3, adapterName: 'UserProfileAdapterGenerated')
class UserProfile with _$UserProfile {
  const factory UserProfile({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String email,
    @HiveField(3) @Default(0) double dailyIncome,
    @HiveField(4) @Default(<String, double>{}) Map<String, double> jarPercentages,
    @HiveField(5) @Default(true) bool autoSimulateDaily,
    @HiveField(6) DateTime? lastSyncedAt,
    @HiveField(7) @Default(true) bool syncEnabled,
    @HiveField(8) @Default(0) double unallocatedBalance,
    @HiveField(9) @Default(1.0) double mindsetLevel,
    @HiveField(10) @Default(<String>[]) List<String> purchasedCourses,
    @HiveField(11) @Default(1) int dayCounter,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
}

// Custom adapter to handle backward compatibility
class UserProfileAdapter extends TypeAdapter<UserProfile> {
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
      // Handle new fields with defaults for backward compatibility
      mindsetLevel: fields[9] as double? ?? 1.0,
      purchasedCourses: fields[10] != null ? (fields[10] as List).cast<String>() : <String>[],
      dayCounter: fields[11] as int? ?? 1,
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
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

