// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'investment_price_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvestmentPriceAdapter extends TypeAdapter<InvestmentPrice> {
  @override
  final int typeId = 4;

  @override
  InvestmentPrice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvestmentPrice(
      symbol: fields[0] as String,
      price: fields[1] as double,
      timestamp: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, InvestmentPrice obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.symbol)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvestmentPriceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InvestmentPriceImpl _$$InvestmentPriceImplFromJson(
        Map<String, dynamic> json) =>
    _$InvestmentPriceImpl(
      symbol: json['symbol'] as String,
      price: (json['price'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$InvestmentPriceImplToJson(
        _$InvestmentPriceImpl instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'price': instance.price,
      'timestamp': instance.timestamp.toIso8601String(),
    };
