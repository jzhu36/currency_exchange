import 'currency_data.dart';
import 'package:intl/intl.dart';

/// Currency converter model with dynamic exchange rates.
/// Uses USD as the base currency for all conversions.
class CurrencyConverter {
  // Current exchange rates (set dynamically from API)
  static Map<String, double> _ratesFromUSD = {
    'USD': 1.0,
    'JPY': 149.50,
    'SGD': 1.34,
    'CNY': 7.24,
  };

  /// Update exchange rates from external source.
  static void updateRates(Map<String, dynamic> rates) {
    final Map<String, double> newRates = {};
    rates.forEach((key, value) {
      if (value is num) {
        newRates[key] = value.toDouble();
      }
    });
    
    if (newRates.isNotEmpty) {
      _ratesFromUSD = newRates;
    }
  }

  /// Get current exchange rates.
  static Map<String, double> getRates() {
    return Map.from(_ratesFromUSD);
  }

  /// Converts an amount from one currency to another.
  ///
  /// The conversion is done by first converting to USD (base currency),
  /// then converting from USD to the target currency.
  ///
  /// Formula: amountTo = (amountFrom / rateFrom) * rateTo
  ///
  /// Example: 1000 JPY to CNY = (1000 / 149.50) * 7.24 = 48.42 CNY
  static double convert(double amount, String fromCurrency, String toCurrency) {
    if (!_ratesFromUSD.containsKey(fromCurrency) ||
        !_ratesFromUSD.containsKey(toCurrency)) {
      throw ArgumentError('Unsupported currency: $fromCurrency or $toCurrency');
    }

    if (fromCurrency == toCurrency) {
      return amount;
    }

    // Convert to USD first, then to target currency
    final rateFrom = _ratesFromUSD[fromCurrency]!;
    final rateTo = _ratesFromUSD[toCurrency]!;

    final amountInUSD = amount / rateFrom;
    final amountInTarget = amountInUSD * rateTo;

    return amountInTarget;
  }

  /// Formats an amount according to the currency's decimal place rules.
  ///
  /// JPY, KRW, etc. will have 0 decimal places (e.g., "1,234")
  /// Most currencies will have 2 decimal places (e.g., "1,234.56")
  /// Some (BHD, KWD, etc.) will have 3 decimal places
  ///
  /// Numbers are formatted with thousand separators for better readability.
  /// Trailing zeros after decimal point are removed for cleaner display.
  static String formatAmount(double amount, String currency) {
    final decimalPlaces = getDecimalPlaces(currency);

    // Create a NumberFormat with thousand separators
    final formatter = NumberFormat('#,##0${decimalPlaces > 0 ? '.' + '0' * decimalPlaces : ''}', 'en_US');
    String formatted = formatter.format(amount);

    // Remove trailing zeros after decimal point for cleaner display
    // e.g., "1,234.50" stays as "1,234.50", but "1,234.00" becomes "1,234"
    if (decimalPlaces > 0 && formatted.contains('.')) {
      formatted = formatted.replaceAll(RegExp(r'0+$'), '');
      formatted = formatted.replaceAll(RegExp(r'\.$'), '');
    }

    return formatted;
  }

  /// Returns the number of decimal places for a given currency.
  static int getDecimalPlaces(String currency) {
    return CurrencyData.getDecimalPlaces(currency);
  }

  /// Returns all supported currency codes.
  static List<String> getSupportedCurrencies() {
    return _ratesFromUSD.keys.toList();
  }
}
