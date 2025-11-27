// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MoneyTransactionAdapter extends TypeAdapter<MoneyTransaction> {
  @override
  final int typeId = 1;

  @override
  MoneyTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MoneyTransaction(
      id: fields[0] as String,
      jarId: fields[1] as String,
      amount: fields[2] as double,
      kind: fields[3] as TransactionKind,
      date: fields[4] as DateTime,
      description: fields[5] as String,
      counterpartyId: fields[6] as String?,
      itemId: fields[7] as String?,
      metadata: (fields[8] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, MoneyTransaction obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.jarId)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.kind)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.counterpartyId)
      ..writeByte(7)
      ..write(obj.itemId)
      ..writeByte(8)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MoneyTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TransactionKindAdapter extends TypeAdapter<TransactionKind> {
  @override
  final int typeId = 10;

  @override
  TransactionKind read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransactionKind.income;
      case 1:
        return TransactionKind.allocation;
      case 2:
        return TransactionKind.purchase;
      case 3:
        return TransactionKind.sale;
      case 4:
        return TransactionKind.transfer;
      default:
        return TransactionKind.income;
    }
  }

  @override
  void write(BinaryWriter writer, TransactionKind obj) {
    switch (obj) {
      case TransactionKind.income:
        writer.writeByte(0);
        break;
      case TransactionKind.allocation:
        writer.writeByte(1);
        break;
      case TransactionKind.purchase:
        writer.writeByte(2);
        break;
      case TransactionKind.sale:
        writer.writeByte(3);
        break;
      case TransactionKind.transfer:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionKindAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MoneyTransactionImpl _$$MoneyTransactionImplFromJson(
        Map<String, dynamic> json) =>
    _$MoneyTransactionImpl(
      id: json['id'] as String,
      jarId: json['jarId'] as String,
      amount: (json['amount'] as num).toDouble(),
      kind: $enumDecode(_$TransactionKindEnumMap, json['kind']),
      date: DateTime.parse(json['date'] as String),
      description: json['description'] as String? ?? '',
      counterpartyId: json['counterpartyId'] as String?,
      itemId: json['itemId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$MoneyTransactionImplToJson(
        _$MoneyTransactionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jarId': instance.jarId,
      'amount': instance.amount,
      'kind': _$TransactionKindEnumMap[instance.kind]!,
      'date': instance.date.toIso8601String(),
      'description': instance.description,
      'counterpartyId': instance.counterpartyId,
      'itemId': instance.itemId,
      'metadata': instance.metadata,
    };

const _$TransactionKindEnumMap = {
  TransactionKind.income: 'income',
  TransactionKind.allocation: 'allocation',
  TransactionKind.purchase: 'purchase',
  TransactionKind.sale: 'sale',
  TransactionKind.transfer: 'transfer',
};
