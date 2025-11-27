import 'package:shared_preferences/shared_preferences.dart';

class InterestService {
  InterestService({SharedPreferences? preferences}) : _preferences = preferences;

  static const double minRate = 0.001; // 0.1% per day
  static const double maxRate = 0.02; // 2.0% per day

  static const Map<String, double> _defaultRates = {
    'FFA': 0.003, // 0.3%
    'LTSS': 0.004, // 0.4%
    'EDU': 0.002, // 0.2%
  };

  static const String _prefsPrefix = 'interest_rate_';

  SharedPreferences? _preferences;

  Future<SharedPreferences> get _prefs async => _preferences ??= await SharedPreferences.getInstance();

  Future<Map<String, double>> loadRates() async {
    final prefs = await _prefs;
    final rates = <String, double>{};

    for (final entry in _defaultRates.entries) {
      final stored = prefs.getDouble('$_prefsPrefix${entry.key}') ?? entry.value;
      final clamped = stored.clamp(minRate, maxRate);
      rates[entry.key] = clamped;
    }

    return rates;
  }

  Future<void> saveRate(String jarId, double rate) async {
    final prefs = await _prefs;
    final clamped = rate.clamp(minRate, maxRate);
    await prefs.setDouble('$_prefsPrefix$jarId', clamped);
  }

  Future<void> saveRates(Map<String, double> rates) async {
    final prefs = await _prefs;
    for (final entry in rates.entries) {
      final clamped = entry.value.clamp(minRate, maxRate);
      await prefs.setDouble('$_prefsPrefix${entry.key}', clamped);
    }
  }
}

