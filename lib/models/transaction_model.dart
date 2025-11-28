import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 10, adapterName: 'TransactionKindAdapter')
enum TransactionKind {
  @HiveField(0)
  income,
  @HiveField(1)
  allocation,
  @HiveField(2)
  purchase,
  @HiveField(3)
  sale,
  @HiveField(4)
  transfer,
  @HiveField(5)
  answer,
}

@freezed
@HiveType(typeId: 1, adapterName: 'MoneyTransactionAdapter')
class MoneyTransaction with _$MoneyTransaction {
  const factory MoneyTransaction({
    @HiveField(0) required String id,
    @HiveField(1) required String jarId,
    @HiveField(2) required double amount,
    @HiveField(3) required TransactionKind kind,
    @HiveField(4) required DateTime date,
    @HiveField(5) @Default('') String description,
    @HiveField(6) String? counterpartyId,
    @HiveField(7) String? itemId,
    @HiveField(8) Map<String, dynamic>? metadata,
  }) = _MoneyTransaction;

  factory MoneyTransaction.fromJson(Map<String, dynamic> json) => _$MoneyTransactionFromJson(json);
}

