// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jar_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class JarAdapter extends TypeAdapter<Jar> {
  @override
  final int typeId = 0;

  @override
  Jar read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Jar(
      id: fields[0] as String,
      name: fields[1] as String,
      percentage: fields[2] as double,
      balance: fields[3] as double,
      transactionIds: (fields[4] as List).cast<String>(),
      lastUpdated: fields[5] as DateTime?,
      isDefault: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Jar obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.percentage)
      ..writeByte(3)
      ..write(obj.balance)
      ..writeByte(4)
      ..write(obj.transactionIds)
      ..writeByte(5)
      ..write(obj.lastUpdated)
      ..writeByte(6)
      ..write(obj.isDefault);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$JarImpl _$$JarImplFromJson(Map<String, dynamic> json) => _$JarImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0,
      transactionIds: (json['transactionIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      isDefault: json['isDefault'] as bool? ?? false,
    );

Map<String, dynamic> _$$JarImplToJson(_$JarImpl instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'percentage': instance.percentage,
      'balance': instance.balance,
      'transactionIds': instance.transactionIds,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'isDefault': instance.isDefault,
    };
