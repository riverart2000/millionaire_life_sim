import 'package:intl/intl.dart';

/// Centralized currency formatter for the app
/// Uses USD ($) as the default and only currency
class CurrencyFormatter {
  static const String _currencySymbol = '\$';
  static const String _locale = 'en_US';
  
  /// Format a number as USD currency
  /// Example: format(1234.56) returns "$1,234.56"
  static String format(double value, {int decimalDigits = 2}) {
    return NumberFormat.currency(
      locale: _locale,
      symbol: _currencySymbol,
      decimalDigits: decimalDigits,
    ).format(value);
  }
  
  /// Format a number as USD currency without decimals
  /// Example: formatWhole(1234.56) returns "$1,235"
  static String formatWhole(double value) {
    return format(value, decimalDigits: 0);
  }
  
  /// Get the currency symbol
  static String get symbol => _currencySymbol;
  
  /// Format with custom decimal places
  /// Example: formatWithDecimals(1234.5678, 4) returns "$1,234.5678"
  static String formatWithDecimals(double value, int decimalDigits) {
    return format(value, decimalDigits: decimalDigits);
  }
}

