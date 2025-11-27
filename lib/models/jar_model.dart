import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'jar_model.freezed.dart';
part 'jar_model.g.dart';

@freezed
@HiveType(typeId: 0, adapterName: 'JarAdapter')
class Jar with _$Jar {
  const factory Jar({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) @Default(0) double percentage,
    @HiveField(3) @Default(0) double balance,
    @HiveField(4) @Default(<String>[]) List<String> transactionIds,
    @HiveField(5) DateTime? lastUpdated,
    @HiveField(6) @Default(false) bool isDefault,
  }) = _Jar;

  factory Jar.fromJson(Map<String, dynamic> json) => _$JarFromJson(json);
}

