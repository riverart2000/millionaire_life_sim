import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  final AffirmationConfig affirmations;
  final IncomeConfig income;
  final BillsConfig bills;
  final Map<String, double> interestRates;
  final Map<String, double> investmentReturns;
  final Map<String, double> jarPercentages;

  AppConfig({
    required this.affirmations,
    required this.income,
    required this.bills,
    required this.interestRates,
    required this.investmentReturns,
    required this.jarPercentages,
  });

  static Future<AppConfig> load() async {
    try {
      final jsonString = await rootBundle.loadString('assets/config/default_settings.json');
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return AppConfig.fromJson(json);
    } catch (e) {
      print('Error loading config, using fallback defaults: $e');
      return AppConfig.defaults();
    }
  }

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      affirmations: AffirmationConfig.fromJson(json['affirmations'] as Map<String, dynamic>),
      income: IncomeConfig.fromJson(json['income'] as Map<String, dynamic>),
      bills: BillsConfig.fromJson(json['bills'] as Map<String, dynamic>),
      interestRates: (json['interestRates'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ),
      investmentReturns: (json['investmentReturns'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ),
      jarPercentages: (json['jarPercentages'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ),
    );
  }

  factory AppConfig.defaults() {
    return AppConfig(
      affirmations: AffirmationConfig.defaults(),
      income: IncomeConfig.defaults(),
      bills: BillsConfig.defaults(),
      interestRates: {'FFA': 0.3, 'LTSS': 0.4, 'EDU': 0.2},
      investmentReturns: {'GOLD': 0.1, 'SILVER': 0.1, 'BTC': 0.2, 'REALESTATE': 0.5},
      jarPercentages: {'FFA': 10.0, 'LTSS': 10.0, 'EDU': 10.0, 'NEC': 55.0, 'PLAY': 10.0, 'GIVE': 5.0},
    );
  }
}

class AffirmationConfig {
  final bool enabled;
  final int flashDurationMs;
  final double opacity;
  final int intervalSeconds;
  final bool randomPosition;
  final double fontSize;

  AffirmationConfig({
    required this.enabled,
    required this.flashDurationMs,
    required this.opacity,
    required this.intervalSeconds,
    required this.randomPosition,
    required this.fontSize,
  });

  factory AffirmationConfig.fromJson(Map<String, dynamic> json) {
    return AffirmationConfig(
      enabled: json['enabled'] as bool,
      flashDurationMs: json['flashDurationMs'] as int,
      opacity: (json['opacity'] as num).toDouble(),
      intervalSeconds: json['intervalSeconds'] as int,
      randomPosition: json['randomPosition'] as bool,
      fontSize: (json['fontSize'] as num).toDouble(),
    );
  }

  factory AffirmationConfig.defaults() {
    return AffirmationConfig(
      enabled: true,
      flashDurationMs: 150,
      opacity: 0.15,
      intervalSeconds: 60,
      randomPosition: true,
      fontSize: 32.0,
    );
  }
}

class IncomeConfig {
  final double dailyIncome;
  final bool autoSimulateDaily;

  IncomeConfig({
    required this.dailyIncome,
    required this.autoSimulateDaily,
  });

  factory IncomeConfig.fromJson(Map<String, dynamic> json) {
    return IncomeConfig(
      dailyIncome: (json['dailyIncome'] as num).toDouble(),
      autoSimulateDaily: json['autoSimulateDaily'] as bool,
    );
  }

  factory IncomeConfig.defaults() {
    return IncomeConfig(
      dailyIncome: 100.0,
      autoSimulateDaily: true,
    );
  }
}

class BillsConfig {
  final double rent;
  final double food;
  final double travel;
  final double accessories;

  BillsConfig({
    required this.rent,
    required this.food,
    required this.travel,
    required this.accessories,
  });

  factory BillsConfig.fromJson(Map<String, dynamic> json) {
    return BillsConfig(
      rent: (json['rent'] as num).toDouble(),
      food: (json['food'] as num).toDouble(),
      travel: (json['travel'] as num).toDouble(),
      accessories: (json['accessories'] as num).toDouble(),
    );
  }

  factory BillsConfig.defaults() {
    return BillsConfig(
      rent: 10.0,
      food: 10.0,
      travel: 10.0,
      accessories: 10.0,
    );
  }
}
