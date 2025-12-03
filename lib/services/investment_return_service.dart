import 'package:shared_preferences/shared_preferences.dart';
import '../core/config/app_config.dart';

class InvestmentReturnService {
  InvestmentReturnService({
    SharedPreferences? preferences,
    AppConfig? config,
  })  : _preferences = preferences,
        _config = config;

  static const double minRate = 0.001; // 0.1% per day
  static const double maxRate = 0.02; // 2.0% per day

  static const String _prefsPrefix = 'investment_return_rate_';

  SharedPreferences? _preferences;
  AppConfig? _config;

  Future<SharedPreferences> get _prefs async => _preferences ??= await SharedPreferences.getInstance();
  Future<AppConfig> get _configuration async => _config ??= await AppConfig.load();

  Future<Map<String, double>> _getDefaultRates() async {
    final config = await _configuration;
    return {
      'GOLD': config.investmentReturns.gold / 100, // Convert percentage to decimal
      'SILVER': config.investmentReturns.silver / 100,
      'BTC': config.investmentReturns.btc / 100,
      'REALESTATE': config.investmentReturns.realEstate / 100,
    };
  }

  Future<Map<String, double>> loadRates() async {
    final prefs = await _prefs;
    final defaultRates = await _getDefaultRates();
    final rates = <String, double>{};

    for (final entry in defaultRates.entries) {
      final stored = prefs.getDouble('$_prefsPrefix${entry.key}') ?? entry.value;
      final clamped = stored.clamp(minRate, maxRate);
      rates[entry.key] = clamped;
    }

    return rates;
  }

  Future<void> saveRate(String symbol, double rate) async {
    final prefs = await _prefs;
    final clamped = rate.clamp(minRate, maxRate);
    await prefs.setDouble('$_prefsPrefix$symbol', clamped);
  }

  Future<void> saveRates(Map<String, double> rates) async {
    final prefs = await _prefs;
    for (final entry in rates.entries) {
      final clamped = entry.value.clamp(minRate, maxRate);
      await prefs.setDouble('$_prefsPrefix${entry.key}', clamped);
    }
  }
}

