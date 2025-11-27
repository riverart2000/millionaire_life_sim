import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/hive_box_constants.dart';
import '../core/utils/logger.dart';
import '../models/investment_model.dart';
import '../models/investment_price_model.dart';

class InvestmentService {
  InvestmentService({
    SharedPreferences? preferences,
    Box<InvestmentPrice>? priceBox,
  })  : _preferences = preferences,
        _priceBox = priceBox;

  SharedPreferences? _preferences;
  Box<InvestmentPrice>? _priceBox;

  static const String _storagePrefix = 'investment_units_';
  static const Duration _priceCacheDuration = Duration(hours: 4);

  Future<Box<InvestmentPrice>> get _pricesBox async {
    if (_priceBox != null) return _priceBox!;
    _priceBox = await Hive.openBox<InvestmentPrice>(HiveBoxConstants.investmentPrices);
    return _priceBox!;
  }

  static const Map<String, _InvestmentDefinition> _defaultDefinitions = {
    'GOLD': _InvestmentDefinition(name: 'Gold', pricePerUnit: 2200.0),
    'SILVER': _InvestmentDefinition(name: 'Silver', pricePerUnit: 25.0),
    'BTC': _InvestmentDefinition(name: 'Bitcoin', pricePerUnit: 65000.0),
    'REALESTATE': _InvestmentDefinition(name: 'Real Estate', pricePerUnit: 100000.0),
  };

  Future<SharedPreferences> get _prefs async => _preferences ??= await SharedPreferences.getInstance();

  Future<List<Investment>> fetchInvestments() async {
    final prefs = await _prefs;
    final pricesBox = await _pricesBox;
    final investments = <Investment>[];

    for (final entry in _defaultDefinitions.entries) {
      final symbol = entry.key;
      final definition = entry.value;
      final units = prefs.getDouble('$_storagePrefix$symbol') ?? 0.0;
      
      // Get stored price from Hive or use default
      final storedPriceData = pricesBox.get(symbol);
      final price = storedPriceData?.price ?? definition.pricePerUnit;
      
      logInfo('📈 Fetching $symbol: stored=${storedPriceData?.price.toStringAsFixed(2)}, timestamp=${storedPriceData?.timestamp}, using=${price.toStringAsFixed(2)}, units=$units');
      
      investments.add(
        Investment(
          symbol: symbol,
          name: definition.name,
          pricePerUnit: price,
          unitsOwned: units,
        ),
      );
    }

    return investments;
  }

  Future<void> updatePrices(Map<String, double> prices) async {
    final pricesBox = await _pricesBox;
    final now = DateTime.now();
    
    logInfo('💰 Updating investment prices in Hive: $prices');
    for (final entry in prices.entries) {
      final priceData = InvestmentPrice(
        symbol: entry.key,
        price: entry.value,
        timestamp: now,
      );
      await pricesBox.put(entry.key, priceData);
      logInfo('✅ Stored ${entry.key} price: £${entry.value.toStringAsFixed(2)} with timestamp: $now');
    }
    
    // Verify storage
    for (final symbol in prices.keys) {
      final stored = pricesBox.get(symbol);
      logInfo('🔍 Verified ${symbol} stored: ${stored != null ? "£${stored.price.toStringAsFixed(2)} at ${stored.timestamp}" : "NULL"}');
    }
  }
  
  /// Check if cached price is still valid (not older than 4 hours)
  bool _isPriceStale(InvestmentPrice? priceData) {
    if (priceData == null) return true;
    final age = DateTime.now().difference(priceData.timestamp);
    return age > _priceCacheDuration;
  }
  
  /// Get cached price if valid, otherwise return null
  Future<double?> getCachedPrice(String symbol) async {
    final pricesBox = await _pricesBox;
    final priceData = pricesBox.get(symbol);
    
    if (priceData == null || _isPriceStale(priceData)) {
      logInfo('⏰ Cached price for $symbol is ${priceData == null ? "missing" : "stale (age: ${DateTime.now().difference(priceData.timestamp).inHours}h)"}');
      return null;
    }
    
    logInfo('✅ Using cached price for $symbol: £${priceData.price.toStringAsFixed(2)} (age: ${DateTime.now().difference(priceData.timestamp).inHours}h)');
    return priceData.price;
  }

  double priceFor(String symbol) {
    final definition = _defaultDefinitions[symbol];
    if (definition == null) {
      throw ArgumentError('Unknown investment symbol: $symbol');
    }
    return definition.pricePerUnit;
  }

  Future<double> priceForAsync(String symbol) async {
    // First try to get cached price from Hive
    final cachedPrice = await getCachedPrice(symbol);
    if (cachedPrice != null) {
      return cachedPrice;
    }
    
    // Fallback to default if no cache
    final definition = _defaultDefinitions[symbol];
    if (definition == null) {
      throw ArgumentError('Unknown investment symbol: $symbol');
    }
    return definition.pricePerUnit;
  }

  Future<void> recordPurchase({required String symbol, required double units}) async {
    final prefs = await _prefs;
    final current = prefs.getDouble('$_storagePrefix$symbol') ?? 0.0;
    await prefs.setDouble('$_storagePrefix$symbol', current + units);
  }

  Future<void> recordSale({required String symbol, required double units}) async {
    final prefs = await _prefs;
    final current = prefs.getDouble('$_storagePrefix$symbol') ?? 0.0;
    final newAmount = (current - units).clamp(0.0, double.infinity);
    await prefs.setDouble('$_storagePrefix$symbol', newAmount);
  }

  /// Apply daily returns to investments (increases units owned)
  Future<void> applyDailyReturns(Map<String, double> returnRates) async {
    final prefs = await _prefs;
    
    for (final symbol in _defaultDefinitions.keys) {
      final currentUnits = prefs.getDouble('$_storagePrefix$symbol') ?? 0.0;
      
      if (currentUnits > 0) {
        final returnRate = returnRates[symbol] ?? 0.0;
        final additionalUnits = currentUnits * returnRate;
        final newUnits = currentUnits + additionalUnits;
        
        await prefs.setDouble('$_storagePrefix$symbol', newUnits);
        
        logInfo('📈 $symbol return: ${(returnRate * 100).toStringAsFixed(2)}% daily → +${additionalUnits.toStringAsFixed(6)} units (${currentUnits.toStringAsFixed(4)} → ${newUnits.toStringAsFixed(4)})');
      }
    }
  }
}

class _InvestmentDefinition {
  const _InvestmentDefinition({required this.name, required this.pricePerUnit});

  final String name;
  final double pricePerUnit;
}

