import 'package:shared_preferences/shared_preferences.dart';
import '../core/config/app_config.dart';

class BillsService {
  BillsService({
    SharedPreferences? preferences,
    AppConfig? config,
  })  : _preferences = preferences,
        _config = config;

  static const String rentKey = 'bill_rent';
  static const String foodKey = 'bill_food';
  static const String travelKey = 'bill_travel';
  static const String accessoriesKey = 'bill_accessories';

  SharedPreferences? _preferences;
  AppConfig? _config;

  Future<SharedPreferences> get _prefs async => _preferences ??= await SharedPreferences.getInstance();
  Future<AppConfig> get _configuration async => _config ??= await AppConfig.load();

  Future<Map<String, double>> _getDefaultBills() async {
    final config = await _configuration;
    return {
      rentKey: config.bills.rent,
      foodKey: config.bills.food,
      travelKey: config.bills.travel,
      accessoriesKey: config.bills.accessories,
    };
  }

  Future<Map<String, double>> loadBills() async {
    final prefs = await _prefs;
    final defaultBills = await _getDefaultBills();
    final bills = <String, double>{};

    for (final entry in defaultBills.entries) {
      final stored = prefs.getDouble(entry.key) ?? entry.value;
      bills[entry.key] = stored.clamp(0.0, double.infinity);
    }

    return bills;
  }

  Future<double> getRent() async {
    final prefs = await _prefs;
    final defaultBills = await _getDefaultBills();
    return prefs.getDouble(rentKey) ?? defaultBills[rentKey]!;
  }

  Future<double> getFood() async {
    final prefs = await _prefs;
    final defaultBills = await _getDefaultBills();
    return prefs.getDouble(foodKey) ?? defaultBills[foodKey]!;
  }

  Future<double> getTravel() async {
    final prefs = await _prefs;
    final defaultBills = await _getDefaultBills();
    return prefs.getDouble(travelKey) ?? defaultBills[travelKey]!;
  }

  Future<double> getAccessories() async {
    final prefs = await _prefs;
    final defaultBills = await _getDefaultBills();
    return prefs.getDouble(accessoriesKey) ?? defaultBills[accessoriesKey]!;
  }

  Future<void> saveBill(String key, double amount) async {
    final prefs = await _prefs;
    final clamped = amount.clamp(0.0, double.infinity);
    await prefs.setDouble(key, clamped);
  }

  Future<void> saveBills({
    required double rent,
    required double food,
    required double travel,
    required double accessories,
  }) async {
    final prefs = await _prefs;
    await prefs.setDouble(rentKey, rent.clamp(0.0, double.infinity));
    await prefs.setDouble(foodKey, food.clamp(0.0, double.infinity));
    await prefs.setDouble(travelKey, travel.clamp(0.0, double.infinity));
    await prefs.setDouble(accessoriesKey, accessories.clamp(0.0, double.infinity));
  }

  Future<double> getTotalDailyBills() async {
    final bills = await loadBills();
    return bills.values.fold<double>(0.0, (sum, amount) => sum + amount);
  }

  /// Increase all bills by £0.10 per day (inflation)
  Future<void> increaseBillsDaily() async {
    final currentBills = await loadBills();
    final prefs = await _prefs;
    
    // Increase each bill by £0.10
    await prefs.setDouble(rentKey, (currentBills[rentKey]! + 0.1).clamp(0.0, double.infinity));
    await prefs.setDouble(foodKey, (currentBills[foodKey]! + 0.1).clamp(0.0, double.infinity));
    await prefs.setDouble(travelKey, (currentBills[travelKey]! + 0.1).clamp(0.0, double.infinity));
    await prefs.setDouble(accessoriesKey, (currentBills[accessoriesKey]! + 0.1).clamp(0.0, double.infinity));
  }
}

