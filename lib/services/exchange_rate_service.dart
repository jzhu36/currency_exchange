import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Service for fetching and caching exchange rates.
/// 
/// Features:
/// - Fetches rates from API once per day
/// - Caches rates locally with 24-hour validity
/// - Comprehensive default rates for offline-first experience
/// - Supports 160+ currencies
class ExchangeRateService {
  static const String _ratesKey = 'exchange_rates';
  static const String _timestampKey = 'rates_timestamp';
  static const String _apiUrl = 'https://api.exchangerate-api.com/v4/latest/USD';
  
  // Comprehensive fallback rates (December 2025, USD base)
  static const Map<String, double> _defaultRates = {
    'USD': 1.0,
    'AED': 3.67, 'AFN': 68.5, 'ALL': 92.5, 'AMD': 387.0, 'ANG': 1.79,
    'AOA': 825.0, 'ARS': 350.0, 'AUD': 1.53, 'AWG': 1.79, 'AZN': 1.70,
    'BAM': 1.80, 'BBD': 2.0, 'BDT': 110.0, 'BGN': 1.80, 'BHD': 0.376,
    'BIF': 2850.0, 'BMD': 1.0, 'BND': 1.34, 'BOB': 6.91, 'BRL': 4.97,
    'BSD': 1.0, 'BTN': 83.12, 'BWP': 13.5, 'BYN': 3.25, 'BZD': 2.0,
    'CAD': 1.36, 'CDF': 2450.0, 'CHF': 0.88, 'CLP': 950.0, 'CNY': 7.24,
    'COP': 4050.0, 'CRC': 520.0, 'CUP': 24.0, 'CVE': 101.5, 'CZK': 22.5,
    'DJF': 177.72, 'DKK': 6.85, 'DOP': 58.5, 'DZD': 134.5, 'EGP': 30.9,
    'ERN': 15.0, 'ETB': 55.5, 'EUR': 0.92, 'FJD': 2.25, 'FKP': 0.79,
    'FOK': 6.85, 'GBP': 0.79, 'GEL': 2.70, 'GGP': 0.79, 'GHS': 12.0,
    'GIP': 0.79, 'GMD': 63.0, 'GNF': 8600.0, 'GTQ': 7.75, 'GYD': 209.0,
    'HKD': 7.82, 'HNL': 24.7, 'HRK': 6.93, 'HTG': 132.0, 'HUF': 355.0,
    'IDR': 15750.0, 'ILS': 3.65, 'IMP': 0.79, 'INR': 83.12, 'IQD': 1310.0,
    'IRR': 42000.0, 'ISK': 138.0, 'JEP': 0.79, 'JMD': 155.0, 'JOD': 0.709,
    'JPY': 149.50, 'KES': 129.0, 'KGS': 84.5, 'KHR': 4050.0, 'KID': 1.53,
    'KMF': 452.5, 'KRW': 1298.50, 'KWD': 0.307, 'KYD': 0.83, 'KZT': 450.0,
    'LAK': 17500.0, 'LBP': 89500.0, 'LKR': 300.0, 'LRD': 185.0, 'LSL': 18.65,
    'LYD': 4.82, 'MAD': 9.85, 'MDL': 17.8, 'MGA': 4500.0, 'MKD': 56.5,
    'MMK': 2100.0, 'MNT': 3400.0, 'MOP': 8.05, 'MRU': 39.5, 'MUR': 45.5,
    'MVR': 15.4, 'MWK': 1100.0, 'MXN': 17.15, 'MYR': 4.48, 'MZN': 63.8,
    'NAD': 18.65, 'NGN': 775.0, 'NIO': 36.7, 'NOK': 10.5, 'NPR': 133.0,
    'NZD': 1.67, 'OMR': 0.385, 'PAB': 1.0, 'PEN': 3.73, 'PGK': 3.90,
    'PHP': 55.8, 'PKR': 278.0, 'PLN': 3.98, 'PYG': 7300.0, 'QAR': 3.64,
    'RON': 4.57, 'RSD': 107.5, 'RUB': 92.0, 'RWF': 1280.0, 'SAR': 3.75,
    'SBD': 8.35, 'SCR': 13.5, 'SDG': 601.0, 'SEK': 10.35, 'SGD': 1.34,
    'SHP': 0.79, 'SLE': 22.5, 'SOS': 571.0, 'SRD': 35.3, 'SSP': 130.26,
    'STN': 22.5, 'SYP': 13000.0, 'SZL': 18.65, 'THB': 34.8, 'TJS': 10.9,
    'TMT': 3.50, 'TND': 3.12, 'TOP': 2.35, 'TRY': 32.5, 'TTD': 6.75,
    'TVD': 1.53, 'TWD': 31.5, 'TZS': 2500.0, 'UAH': 38.5, 'UGX': 3700.0,
    'UYU': 39.2, 'UZS': 12500.0, 'VES': 36.5, 'VND': 24500.0, 'VUV': 118.7,
    'WST': 2.70, 'XAF': 603.5, 'XCD': 2.70, 'XDR': 0.75, 'XOF': 603.5,
    'XPF': 109.8, 'YER': 250.3, 'ZAR': 18.65, 'ZMW': 26.5, 'ZWL': 322.0,
  };

  /// Initialize default rates on first install.
  static Future<void> initializeDefaultRates() async {
    final prefs = await SharedPreferences.getInstance();
    final hasRates = prefs.containsKey(_ratesKey);
    
    if (!hasRates) {
      // First install - save default rates
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      await prefs.setString(_ratesKey, json.encode({
        'rates': _defaultRates,
        'timestamp': timestamp,
      }));
      await prefs.setInt(_timestampKey, timestamp);
    }
  }

  /// Get exchange rates, either from cache or by fetching new ones.
  /// Returns a map of currency code to rate (USD base).
  static Future<Map<String, dynamic>> getRates() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Ensure default rates are initialized
    await initializeDefaultRates();
    
    // Check if cached rates are still valid (less than 24 hours old)
    final timestamp = prefs.getInt(_timestampKey) ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    final hoursSinceUpdate = (now - timestamp) / (1000 * 60 * 60);
    
    if (hoursSinceUpdate < 24) {
      // Use cached rates
      final ratesJson = prefs.getString(_ratesKey);
      if (ratesJson != null) {
        try {
          final data = json.decode(ratesJson) as Map<String, dynamic>;
          return data;
        } catch (e) {
          // If cache is corrupted, fetch new rates
        }
      }
    }
    
    // Fetch new rates
    return await _fetchAndCacheRates(prefs);
  }

  /// Fetch rates from API and cache them.
  static Future<Map<String, dynamic>> _fetchAndCacheRates(SharedPreferences prefs) async {
    try {
      final response = await http.get(Uri.parse(_apiUrl)).timeout(
        const Duration(seconds: 10),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final rates = data['rates'] as Map<String, dynamic>;
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        
        // Merge with default rates to ensure all currencies are present
        final mergedRates = Map<String, dynamic>.from(_defaultRates);
        mergedRates.addAll(rates);
        
        // Cache the rates
        await prefs.setString(_ratesKey, json.encode({
          'rates': mergedRates,
          'timestamp': timestamp,
        }));
        await prefs.setInt(_timestampKey, timestamp);
        
        return {
          'rates': mergedRates,
          'timestamp': timestamp,
        };
      }
    } catch (e) {
      // Network error or timeout
      print('Failed to fetch rates: $e');
    }
    
    // Return cached or default rates if API fails
    final ratesJson = prefs.getString(_ratesKey);
    if (ratesJson != null) {
      try {
        return json.decode(ratesJson) as Map<String, dynamic>;
      } catch (e) {
        // Fall through to return defaults
      }
    }
    
    // Last resort - return default rates
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    await prefs.setString(_ratesKey, json.encode({
      'rates': _defaultRates,
      'timestamp': timestamp,
    }));
    await prefs.setInt(_timestampKey, timestamp);
    
    return {
      'rates': _defaultRates,
      'timestamp': timestamp,
    };
  }

  /// Force refresh rates from API.
  static Future<Map<String, dynamic>> forceRefresh() async {
    final prefs = await SharedPreferences.getInstance();
    return await _fetchAndCacheRates(prefs);
  }

  /// Get rate for a specific currency.
  static Future<double?> getRateForCurrency(String currencyCode) async {
    final data = await getRates();
    final rates = data['rates'] as Map<String, dynamic>;
    final rate = rates[currencyCode];
    return rate != null ? (rate as num).toDouble() : null;
  }

  /// Get the timestamp of the last update.
  static Future<DateTime?> getLastUpdateTime() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt(_timestampKey);
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }
}