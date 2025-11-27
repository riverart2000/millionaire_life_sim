import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'investment_price_model.freezed.dart';
part 'investment_price_model.g.dart';

@freezed
@HiveType(typeId: 4, adapterName: 'InvestmentPriceAdapter')
class InvestmentPrice with _$InvestmentPrice {
  const factory InvestmentPrice({
    @HiveField(0) required String symbol,
    @HiveField(1) required double price,
    @HiveField(2) required DateTime timestamp,
  }) = _InvestmentPrice;

  factory InvestmentPrice.fromJson(Map<String, dynamic> json) => _$InvestmentPriceFromJson(json);
}

