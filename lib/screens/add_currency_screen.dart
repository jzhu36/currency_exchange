import 'package:flutter/material.dart';
import '../models/currency_data.dart';
import '../services/currency_preferences_service.dart';
import '../services/exchange_rate_service.dart';

/// Screen for adding new currencies to the converter.
/// 
/// Features:
/// - Search bar for filtering currencies
/// - List of all world currencies
/// - Shows flag, country name, and currency code
/// - Marks already selected currencies
/// - Fetches rate when currency is added
class AddCurrencyScreen extends StatefulWidget {
  const AddCurrencyScreen({super.key});

  @override
  State<AddCurrencyScreen> createState() => _AddCurrencyScreenState();
}

class _AddCurrencyScreenState extends State<AddCurrencyScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<CurrencyInfo> _filteredCurrencies = CurrencyData.allCurrencies;
  Set<String> _selectedCurrencies = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSelectedCurrencies();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Load currently selected currencies to mark them in the list.
  Future<void> _loadSelectedCurrencies() async {
    final selected = await CurrencyPreferencesService.getSelectedCurrencies();
    setState(() {
      _selectedCurrencies = selected.toSet();
      _isLoading = false;
    });
  }

  /// Handle search input changes.
  void _onSearchChanged() {
    final query = _searchController.text;
    setState(() {
      _filteredCurrencies = CurrencyData.search(query);
    });
  }

  /// Add currency and return to main screen.
  Future<void> _addCurrency(String currencyCode) async {
    // Show loading indicator
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Add to preferences
      await CurrencyPreferencesService.addCurrency(currencyCode);
      
      // Fetch rate for this currency if not already cached
      await ExchangeRateService.getRateForCurrency(currencyCode);
      
      if (!mounted) return;
      
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Return to converter screen with result
      Navigator.of(context).pop(currencyCode);
    } catch (e) {
      if (!mounted) return;
      
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add currency: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Currency'),
        elevation: 2,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search country or currency',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          
          // Currency list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCurrencies.isEmpty
                    ? Center(
                        child: Text(
                          'No currencies found',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: _filteredCurrencies.length,
                        itemBuilder: (context, index) {
                          final currency = _filteredCurrencies[index];
                          final isSelected = _selectedCurrencies.contains(currency.code);
                          
                          return ListTile(
                            leading: Text(
                              currency.flagEmoji,
                              style: const TextStyle(fontSize: 32),
                            ),
                            title: Text(
                              currency.countryName,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.grey : Colors.black,
                              ),
                            ),
                            subtitle: Text(
                              '${currency.currencyName} (${currency.code})',
                              style: TextStyle(
                                color: isSelected ? Colors.grey : Colors.grey[600],
                              ),
                            ),
                            trailing: isSelected
                                ? Icon(
                                    Icons.check_circle,
                                    color: Colors.green[600],
                                  )
                                : null,
                            enabled: !isSelected,
                            onTap: isSelected
                                ? null
                                : () => _addCurrency(currency.code),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}