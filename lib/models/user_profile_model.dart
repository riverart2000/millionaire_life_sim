import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user_profile_model.freezed.dart';
part 'user_profile_model.g.dart';

@freezed
@HiveType(typeId: 3, adapterName: 'UserProfileAdapter')
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
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
}

