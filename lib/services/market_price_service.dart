import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

import '../core/utils/logger.dart';

class MarketPriceService {
  MarketPriceService();
  
  // Cache for USD to GBP exchange rate
  double? _usdToGbpRate;
  
  // Static fallback prices (in GBP) for when APIs fail (especially on web with CORS)
  static const _fallbackGoldPrice = 1950.0; // £ per ounce
  static const _fallbackSilverPrice = 23.5; // £ per ounce
  static const _fallbackBtcPrice = 52000.0; // £ per BTC
  static const _fallbackRealEstatePrice = 100000.0; // £ per unit
  
  // Fetch USD to GBP exchange rate
  Future<double?> _fetchUsdToGbpRate() async {
    if (_usdToGbpRate != null) return _usdToGbpRate;
    
    try {
      // Try to fetch from Yahoo Finance for exchange rate
      final yahooResponse = await http.get(
        Uri.parse('https://query1.finance.yahoo.com/v8/finance/chart/GBPUSD=X'),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      ).timeout(const Duration(seconds: 5));
      
      if (yahooResponse.statusCode == 200) {
        final data = json.decode(yahooResponse.body) as Map<String, dynamic>;
        final result = data['chart']?['result'] as List?;
        if (result != null && result.isNotEmpty) {
          final meta = result[0]?['meta'];
          final rate = meta?['regularMarketPrice'] ?? meta?['previousClose'];
          if (rate != null) {
            // GBPUSD=X gives GBP per USD, we need USD per GBP (inverse)
            _usdToGbpRate = 1.0 / (rate as num).toDouble();
            logInfo('✅ USD to GBP rate: $_usdToGbpRate');
            return _usdToGbpRate;
          }
        }
      }
      
      // Fallback: approximate rate (can be updated)
      _usdToGbpRate = 0.79; // Approximate USD to GBP rate
      logInfo('⚠️ Using fallback USD to GBP rate: $_usdToGbpRate');
      return _usdToGbpRate;
    } catch (error, stackTrace) {
      logError('Error fetching USD to GBP rate', error, stackTrace);
      _usdToGbpRate = 0.79; // Fallback rate
      return _usdToGbpRate;
    }
  }
  
  // Convert USD price to GBP
  Future<double?> _convertUsdToGbp(double usdPrice) async {
    final rate = await _fetchUsdToGbpRate();
    if (rate == null) return null;
    return usdPrice * rate;
  }

  // Fetch BTC price from CoinGecko (free, no API key needed)
  Future<double?> fetchBTCPrice() async {
    // On web, skip API calls and use fallback directly due to CORS
    if (kIsWeb) {
      logInfo('ℹ️ Running on web - using fallback BTC price: £${_fallbackBtcPrice.toStringAsFixed(2)}');
      return _fallbackBtcPrice;
    }
    
    try {
      // Fetch in GBP to match app currency
      final response = await http.get(
        Uri.parse('https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=gbp'),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final price = data['bitcoin']?['gbp'];
        if (price != null) {
          final priceDouble = (price as num).toDouble();
          logInfo('✅ BTC price from CoinGecko: £${priceDouble.toStringAsFixed(2)}');
          return priceDouble;
        }
      }
      logError('Failed to fetch BTC price', 'Status: ${response.statusCode}', null);
    } catch (error, stackTrace) {
      logError('Error fetching BTC price', error, stackTrace);
    }
    
    // API failed - use static fallback
    logInfo('⚠️ BTC price API failed - using fallback: £${_fallbackBtcPrice.toStringAsFixed(2)}');
    return _fallbackBtcPrice;
  }

  // Fetch Gold price (per ounce) - try multiple sources for SPOT price
  Future<double?> fetchGoldPrice() async {
    // On web, skip API calls and use fallback directly due to CORS
    if (kIsWeb) {
      logInfo('ℹ️ Running on web - using fallback Gold price: £${_fallbackGoldPrice.toStringAsFixed(2)}');
      return _fallbackGoldPrice;
    }
    
    // Try Google Finance spot price first (XAUUSD=X - what Google shows)
    final spotPrice = await _fetchGoldSpotPrice();
    if (spotPrice != null) return spotPrice;
    
    // Fallback to metals-api.com
    final metalsPrice = await _fetchGoldFromMetalsAPI();
    if (metalsPrice != null) return metalsPrice;
    
    // Last resort: Yahoo Finance futures (GC=F)
    final yahooPrice = await _fetchGoldFromYahooFutures();
    if (yahooPrice != null) return yahooPrice;
    
    // All APIs failed - use static fallback
    logInfo('⚠️ All Gold price APIs failed - using fallback: £${_fallbackGoldPrice.toStringAsFixed(2)}');
    return _fallbackGoldPrice;
  }

  Future<double?> _fetchGoldSpotPrice() async {
    try {
      // Google Finance/Yahoo Finance API for gold SPOT price (XAUUSD=X)
      // This is what Google shows when you search "price of gold today"
      final response = await http.get(
        Uri.parse('https://query1.finance.yahoo.com/v8/finance/chart/XAUUSD=X'),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final result = data['chart']?['result'] as List?;
        if (result != null && result.isNotEmpty) {
          final meta = result[0]?['meta'];
          // Try multiple price fields
          final price = meta?['regularMarketPrice'] ?? 
                       meta?['previousClose'] ?? 
                       meta?['chartPreviousClose'];
          if (price != null) {
            final usdPrice = (price as num).toDouble();
            logInfo('✅ Gold SPOT price (USD): \$${usdPrice.toStringAsFixed(2)} per ounce');
            // Convert USD to GBP
            final gbpPrice = await _convertUsdToGbp(usdPrice);
            if (gbpPrice != null) {
              logInfo('✅ Gold SPOT price (GBP): £${gbpPrice.toStringAsFixed(2)} per ounce');
              return gbpPrice;
            }
            return usdPrice; // Fallback to USD if conversion fails
          }
        }
      }
      return null;
    } catch (error, stackTrace) {
      logError('Error fetching Gold spot price', error, stackTrace);
      return null;
    }
  }
  
  Future<double?> _fetchGoldFromMetalsAPI() async {
    try {
      // Try metals-api.com free tier
      final response = await http.get(
        Uri.parse('https://api.metals-api.com/v1/latest?access_key=demo&base=USD&symbols=XAU'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map && data.containsKey('rates') && data['rates'] is Map) {
          final rates = data['rates'] as Map;
          final xauRate = rates['XAU'];
          if (xauRate != null) {
            // XAU is per troy ounce, convert from rate to price
            final price = 1.0 / (xauRate as num).toDouble();
            logInfo('✅ Gold price from metals-api: \$${price.toStringAsFixed(2)} per ounce');
            return price;
          }
        }
      }
      return null;
    } catch (error, stackTrace) {
      logError('Error fetching Gold from metals-api', error, stackTrace);
      return null;
    }
  }
  
  Future<double?> _fetchGoldFromYahooFutures() async {
    try {
      // Last resort: Yahoo Finance gold futures (GC=F) - in USD
      final response = await http.get(
        Uri.parse('https://query1.finance.yahoo.com/v8/finance/chart/GC=F'),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final result = data['chart']?['result'] as List?;
        if (result != null && result.isNotEmpty) {
          final meta = result[0]?['meta'];
          final price = meta?['regularMarketPrice'] ?? meta?['previousClose'];
          if (price != null) {
            final usdPrice = (price as num).toDouble();
            logInfo('✅ Gold price (futures USD): \$${usdPrice.toStringAsFixed(2)}');
            // Convert USD to GBP
            final gbpPrice = await _convertUsdToGbp(usdPrice);
            if (gbpPrice != null) {
              logInfo('✅ Gold price (futures GBP): £${gbpPrice.toStringAsFixed(2)}');
              return gbpPrice;
            }
            return usdPrice; // Fallback to USD if conversion fails
          }
        }
      }
      return null;
    } catch (error, stackTrace) {
      logError('Error fetching Gold from Yahoo Futures', error, stackTrace);
      return null;
    }
  }

  // Fetch Silver price (per ounce) - try multiple sources for SPOT price
  Future<double?> fetchSilverPrice() async {
    // On web, skip API calls and use fallback directly due to CORS
    if (kIsWeb) {
      logInfo('ℹ️ Running on web - using fallback Silver price: £${_fallbackSilverPrice.toStringAsFixed(2)}');
      return _fallbackSilverPrice;
    }
    
    // Try Google Finance spot price first (XAGUSD=X - what Google shows)
    final spotPrice = await _fetchSilverSpotPrice();
    if (spotPrice != null) return spotPrice;
    
    // Fallback to metals-api.com
    final metalsPrice = await _fetchSilverFromMetalsAPI();
    if (metalsPrice != null) return metalsPrice;
    
    // Last resort: Yahoo Finance futures (SI=F)
    final yahooPrice = await _fetchSilverFromYahooFutures();
    if (yahooPrice != null) return yahooPrice;
    
    // All APIs failed - use static fallback
    logInfo('⚠️ All Silver price APIs failed - using fallback: £${_fallbackSilverPrice.toStringAsFixed(2)}');
    return _fallbackSilverPrice;
  }

  Future<double?> _fetchSilverSpotPrice() async {
    try {
      // Google Finance/Yahoo Finance API for silver SPOT price (XAGUSD=X)
      // This is what Google shows when you search "price of silver today"
      final response = await http.get(
        Uri.parse('https://query1.finance.yahoo.com/v8/finance/chart/XAGUSD=X'),
        headers: {
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final result = data['chart']?['result'] as List?;
        if (result != null && result.isNotEmpty) {
          final meta = result[0]?['meta'];
          // Try multiple price fields
          final price = meta?['regularMarketPrice'] ?? 
                       meta?['previousClose'] ?? 
                       meta?['chartPreviousClose'];
          if (price != null) {
            final usdPrice = (price as num).toDouble();
            logInfo('✅ Silver SPOT price (USD): \$${usdPrice.toStringAsFixed(2)} per ounce');
            // Convert USD to GBP
            final gbpPrice = await _convertUsdToGbp(usdPrice);
            if (gbpPrice != null) {
              logInfo('✅ Silver SPOT price (GBP): £${gbpPrice.toStringAsFixed(2)} per ounce');
              return gbpPrice;
            }
            return usdPrice; // Fallback to USD if conversion fails
          }
        }
      }
      return null;
    } catch (error, stackTrace) {
      logError('Error fetching Silver spot price', error, stackTrace);
      return null;
    }
  }
  
  Future<double?> _fetchSilverFromMetalsAPI() async {
    try {
      // Try metals-api.com free tier
      final response = await http.get(
        Uri.parse('https://api.metals-api.com/v1/latest?access_key=demo&base=USD&symbols=XAG'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map && data.containsKey('rates') && data['rates'] is Map) {
          final rates = data['rates'] as Map;
          final xagRate = rates['XAG'];
          if (xagRate != null) {
            // XAG is per troy ounce, convert from rate to price
            final price = 1.0 / (xagRate as num).toDouble();
            logInfo('✅ Silver price from metals-api: \$${price.toStringAsFixed(2)} per ounce');
            return price;
          }
        }
      }
      return null;
    } catch (error, stackTrace) {
      logError('Error fetching Silver from metals-api', error, stackTrace);
      return null;
    }
  }
  
  Future<double?> _fetchSilverFromYahooFutures() async {
    try {
      // Last resort: Yahoo Finance silver futures (SI=F) - in USD
      final response = await http.get(
        Uri.parse('https://query1.finance.yahoo.com/v8/finance/chart/SI=F'),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final result = data['chart']?['result'] as List?;
        if (result != null && result.isNotEmpty) {
          final meta = result[0]?['meta'];
          final price = meta?['regularMarketPrice'] ?? meta?['previousClose'];
          if (price != null) {
            final usdPrice = (price as num).toDouble();
            logInfo('✅ Silver price (futures USD): \$${usdPrice.toStringAsFixed(2)}');
            // Convert USD to GBP
            final gbpPrice = await _convertUsdToGbp(usdPrice);
            if (gbpPrice != null) {
              logInfo('✅ Silver price (futures GBP): £${gbpPrice.toStringAsFixed(2)}');
              return gbpPrice;
            }
            return usdPrice; // Fallback to USD if conversion fails
          }
        }
      }
      return null;
    } catch (error, stackTrace) {
      logError('Error fetching Silver from Yahoo Futures', error, stackTrace);
      return null;
    }
  }

  // Fetch Real Estate price (simulated - real estate prices are more stable)
  Future<double?> fetchRealEstatePrice() async {
    try {
      // Real estate prices are more stable and don't change as dramatically
      // We'll use a base price with small daily variations
      // In a real app, you might fetch from a real estate API or use historical data
      
      // Simulate small daily variation (±0.5%)
      final variation = (DateTime.now().millisecondsSinceEpoch % 100) / 10000.0 - 0.005;
      final price = _fallbackRealEstatePrice * (1.0 + variation);
      
      logInfo('✅ Real Estate price (simulated): £${price.toStringAsFixed(2)}');
      return price;
    } catch (error, stackTrace) {
      logError('Error fetching Real Estate price', error, stackTrace);
      return _fallbackRealEstatePrice;
    }
  }

  // Fetch all prices at once
  Future<Map<String, double>> fetchAllPrices() async {
    final prices = <String, double>{};

    if (kIsWeb) {
      logInfo('🌐 Running on web - using fallback prices for all investments');
    } else {
      logInfo('🔄 Fetching all investment prices...');
    }
    
    // Fetch all prices in parallel
    final results = await Future.wait([
      fetchGoldPrice(),
      fetchSilverPrice(),
      fetchBTCPrice(),
      fetchRealEstatePrice(),
    ]);

    final goldPrice = results[0];
    final silverPrice = results[1];
    final btcPrice = results[2];
    final realEstatePrice = results[3];

    // All prices should return a value (with fallbacks)
    if (goldPrice != null) {
      prices['GOLD'] = goldPrice;
    }
    
    if (silverPrice != null) {
      prices['SILVER'] = silverPrice;
    }
    
    if (btcPrice != null) {
      prices['BTC'] = btcPrice;
    }

    if (realEstatePrice != null) {
      prices['REALESTATE'] = realEstatePrice;
    }

    logInfo('📊 All prices ready: ${prices.length} investments (${prices.keys.join(", ")})');
    return prices;
  }
}

