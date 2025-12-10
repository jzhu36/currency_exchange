import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing user's currency preferences.
/// 
/// Handles:
/// - Selected currencies list
/// - Currency display order
/// - Persistence via SharedPreferences
class CurrencyPreferencesService {
  static const String _selectedCurrenciesKey = 'selected_currencies';
  static const List<String> _defaultCurrencies = ['USD', 'JPY', 'SGD', 'CNY'];

  /// Get user's selected currencies in order.
  static Future<List<String>> getSelectedCurrencies() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_selectedCurrenciesKey);
    
    if (jsonString == null) {
      // First time - return defaults
      await saveSelectedCurrencies(_defaultCurrencies);
      return _defaultCurrencies;
    }
    
    try {
      final List<dynamic> list = json.decode(jsonString);
      return list.cast<String>();
    } catch (e) {
      // Corrupted data - return defaults
      await saveSelectedCurrencies(_defaultCurrencies);
      return _defaultCurrencies;
    }
  }

  /// Save user's selected currencies in order.
  static Future<void> saveSelectedCurrencies(List<String> currencies) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedCurrenciesKey, json.encode(currencies));
  }

  /// Add a currency to the list.
  static Future<void> addCurrency(String currencyCode) async {
    final currencies = await getSelectedCurrencies();
    if (!currencies.contains(currencyCode)) {
      currencies.add(currencyCode);
      await saveSelectedCurrencies(currencies);
    }
  }

  /// Remove a currency from the list.
  /// Returns false if it's the last currency (cannot remove).
  static Future<bool> removeCurrency(String currencyCode) async {
    final currencies = await getSelectedCurrencies();
    
    // Must keep at least one currency
    if (currencies.length <= 1) {
      return false;
    }
    
    currencies.remove(currencyCode);
    await saveSelectedCurrencies(currencies);
    return true;
  }

  /// Reorder currencies.
  static Future<void> reorderCurrencies(int oldIndex, int newIndex) async {
    final currencies = await getSelectedCurrencies();
    
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    
    final currency = currencies.removeAt(oldIndex);
    currencies.insert(newIndex, currency);
    
    await saveSelectedCurrencies(currencies);
  }

  /// Check if a currency is already selected.
  static Future<bool> isCurrencySelected(String currencyCode) async {
    final currencies = await getSelectedCurrencies();
    return currencies.contains(currencyCode);
  }
}