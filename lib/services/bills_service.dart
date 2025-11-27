import 'package:shared_preferences/shared_preferences.dart';

class BillsService {
  BillsService({SharedPreferences? preferences}) : _preferences = preferences;

  static const String rentKey = 'bill_rent';
  static const String foodKey = 'bill_food';
  static const String travelKey = 'bill_travel';
  static const String accessoriesKey = 'bill_accessories';

  static const Map<String, double> _defaultBills = {
    rentKey: 10.0, // Default £10/day
    foodKey: 10.0, // Default £10/day
    travelKey: 10.0, // Default £10/day
    accessoriesKey: 10.0, // Default £10/day
  };

  SharedPreferences? _preferences;

  Future<SharedPreferences> get _prefs async => _preferences ??= await SharedPreferences.getInstance();

  Future<Map<String, double>> loadBills() async {
    final prefs = await _prefs;
    final bills = <String, double>{};

    for (final entry in _defaultBills.entries) {
      final stored = prefs.getDouble(entry.key) ?? entry.value;
      bills[entry.key] = stored.clamp(0.0, double.infinity);
    }

    return bills;
  }

  Future<double> getRent() async {
    final prefs = await _prefs;
    return prefs.getDouble(rentKey) ?? _defaultBills[rentKey]!;
  }

  Future<double> getFood() async {
    final prefs = await _prefs;
    return prefs.getDouble(foodKey) ?? _defaultBills[foodKey]!;
  }

  Future<double> getTravel() async {
    final prefs = await _prefs;
    return prefs.getDouble(travelKey) ?? _defaultBills[travelKey]!;
  }

  Future<double> getAccessories() async {
    final prefs = await _prefs;
    return prefs.getDouble(accessoriesKey) ?? _defaultBills[accessoriesKey]!;
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

