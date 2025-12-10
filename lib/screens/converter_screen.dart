import 'package:flutter/material.dart';
import '../models/currency_converter.dart';
import '../widgets/currency_input_field.dart';
import '../services/exchange_rate_service.dart';
import '../services/currency_preferences_service.dart';
import '../models/currency_data.dart';
import 'package:intl/intl.dart';
import 'add_currency_screen.dart';

/// Main screen for currency conversion.
///
/// Features:
/// - Dynamic currency list from user preferences
/// - Real-time conversion as user types
/// - Drag to reorder currencies (long press)
/// - Drag to delete (drop on recycle bin)
/// - Add currency button
/// - Automatic daily rate updates with 24-hour cache
/// - Display of last update time
class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  // Dynamic currency management
  List<String> _currencies = [];
  Map<String, TextEditingController> _controllers = {};
  Map<String, FocusNode> _focusNodes = {};

  // Track which currency was last edited by the user
  String _lastEditedCurrency = '';

  // Flag to prevent circular updates
  bool _isUpdating = false;

  // Exchange rate data
  DateTime? _lastUpdateTime;
  bool _isLoading = true;

  // Drag and delete state
  bool _isDragging = false;
  String? _draggingCurrency;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// Initialize app data.
  Future<void> _initializeApp() async {
    await _loadCurrencies();
    await _loadExchangeRates();
  }

  /// Load user's selected currencies.
  Future<void> _loadCurrencies() async {
    final currencies = await CurrencyPreferencesService.getSelectedCurrencies();
    setState(() {
      _currencies = currencies;
      _setupControllersAndFocusNodes();
    });
  }

  /// Set up controllers and focus nodes for all currencies.
  void _setupControllersAndFocusNodes() {
    // Clean up old controllers and focus nodes
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes.values) {
      focusNode.dispose();
    }

    _controllers.clear();
    _focusNodes.clear();

    // Create new controllers and focus nodes
    for (final currency in _currencies) {
      final controller = TextEditingController();
      final focusNode = FocusNode();

      controller.addListener(() => _onAmountChanged(currency));
      focusNode.addListener(() {
        if (focusNode.hasFocus) _lastEditedCurrency = currency;
      });

      _controllers[currency] = controller;
      _focusNodes[currency] = focusNode;
    }
  }

  /// Load exchange rates from service.
  Future<void> _loadExchangeRates() async {
    try {
      final data = await ExchangeRateService.getRates();
      final rates = data['rates'] as Map<String, dynamic>;
      final timestamp = data['timestamp'] as int;

      setState(() {
        CurrencyConverter.updateRates(rates);
        _lastUpdateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // Clean up controllers and focus nodes
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes.values) {
      focusNode.dispose();
    }

    super.dispose();
  }

  /// Called when any currency field's text changes.
  void _onAmountChanged(String currency) {
    // Prevent recursive updates
    if (_isUpdating) return;

    // Only update if this is the currency the user is actually editing
    if (_lastEditedCurrency == currency) {
      _isUpdating = true;

      try {
        final controller = _controllers[currency];
        if (controller == null) return;
        
        final text = controller.text;

        // If empty, clear all other fields
        if (text.isEmpty) {
          _clearAllExcept(currency);
          return;
        }

        // Parse the amount
        final amount = double.tryParse(text);
        if (amount == null) {
          // Invalid number, don't update other fields
          return;
        }

        // Update all other fields with converted amounts
        _updateOtherFields(currency, amount);
      } finally {
        _isUpdating = false;
      }
    }
  }

  /// Clears all fields except the specified currency.
  void _clearAllExcept(String exceptCurrency) {
    for (final currency in _currencies) {
      if (currency != exceptCurrency) {
        final controller = _controllers[currency];
        if (controller != null) {
          controller.value = controller.value.copyWith(
            text: '',
            selection: const TextSelection.collapsed(offset: 0),
          );
        }
      }
    }
  }

  /// Updates all currency fields except the source currency.
  void _updateOtherFields(String sourceCurrency, double amount) {
    for (final targetCurrency in _currencies) {
      if (targetCurrency == sourceCurrency) continue;

      try {
        // Convert the amount to the target currency
        final convertedAmount = CurrencyConverter.convert(
          amount,
          sourceCurrency,
          targetCurrency,
        );

        // Format according to currency rules
        final formatted = CurrencyConverter.formatAmount(
          convertedAmount,
          targetCurrency,
        );

        // Update the controller without triggering its listener
        final controller = _controllers[targetCurrency];
        if (controller != null) {
          controller.value = controller.value.copyWith(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        }
      } catch (e) {
        // Currency conversion failed - skip this currency
        print('Failed to convert $sourceCurrency to $targetCurrency: $e');
      }
    }
  }

  /// Handle currency reordering.
  void _onReorder(int oldIndex, int newIndex) async {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final currency = _currencies.removeAt(oldIndex);
      _currencies.insert(newIndex, currency);
    });

    // Save to preferences
    await CurrencyPreferencesService.saveSelectedCurrencies(_currencies);
  }

  /// Handle currency deletion (dropped on delete zone).
  Future<void> _onCurrencyDeleted(String currency) async {
    final success = await CurrencyPreferencesService.removeCurrency(currency);
    
    if (success) {
      // Remove from local list
      setState(() {
        _currencies.remove(currency);
        
        // Clean up controller and focus node
        _controllers[currency]?.dispose();
        _controllers.remove(currency);
        _focusNodes[currency]?.dispose();
        _focusNodes.remove(currency);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$currency removed'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.orange[700],
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot remove last currency'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Navigate to add currency screen.
  Future<void> _navigateToAddCurrency() async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => const AddCurrencyScreen(),
      ),
    );

    if (result != null) {
      // Currency was added, reload the list
      await _loadCurrencies();
      
      // Reload rates to ensure we have the rate for the new currency
      await _loadExchangeRates();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$result added'),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green[700],
          ),
        );
      }
    }
  }

  /// Format the last update time.
  String _formatUpdateTime(DateTime? time) {
    if (time == null) return 'Never';
    
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      final formatter = DateFormat('MMM d, yyyy HH:mm');
      return formatter.format(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
        centerTitle: true,
        elevation: 2,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // Main content
                Column(
                  children: [
                    const SizedBox(height: 20),

                    // Header text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Enter amount in any currency',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey[700],
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Currency list with reordering
                    Expanded(
                      child: ReorderableListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: _currencies.length,
                        onReorder: _onReorder,
                        itemBuilder: (context, index) {
                          final currency = _currencies[index];
                          final controller = _controllers[currency];
                          final focusNode = _focusNodes[currency];

                          if (controller == null || focusNode == null) {
                            return const SizedBox.shrink(key: ValueKey('empty'));
                          }

                          return LongPressDraggable<String>(
                            key: ValueKey(currency),
                            data: currency,
                            feedback: Opacity(
                              opacity: 0.8,
                              child: Material(
                                elevation: 8,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 32,
                                  child: CurrencyInputField(
                                    currencyCode: currency,
                                    controller: TextEditingController(),
                                    focusNode: FocusNode(),
                                  ),
                                ),
                              ),
                            ),
                            childWhenDragging: Opacity(
                              opacity: 0.3,
                              child: CurrencyInputField(
                                currencyCode: currency,
                                controller: controller,
                                focusNode: focusNode,
                              ),
                            ),
                            onDragStarted: () {
                              setState(() {
                                _isDragging = true;
                                _draggingCurrency = currency;
                              });
                            },
                            onDragEnd: (details) {
                              setState(() {
                                _isDragging = false;
                                _draggingCurrency = null;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: CurrencyInputField(
                                currencyCode: currency,
                                controller: controller,
                                focusNode: focusNode,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Add Currency button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _navigateToAddCurrency,
                          icon: const Icon(Icons.add),
                          label: const Text('Add Currency'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Footer with rate info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Last updated: ${_formatUpdateTime(_lastUpdateTime)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Display current rates
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Builder(
                        builder: (context) {
                          final rates = CurrencyConverter.getRates();
                          final usdRate = rates['USD'] ?? 1.0;
                          final displayCurrencies = _currencies.take(3).toList();
                          
                          final rateTexts = displayCurrencies.where((c) => c != 'USD').map((c) {
                            final rate = rates[c];
                            if (rate != null) {
                              final decimals = CurrencyData.getDecimalPlaces(c);
                              return '${(rate / usdRate).toStringAsFixed(decimals)} $c';
                            }
                            return '';
                          }).where((s) => s.isNotEmpty).join(' | ');

                          return Text(
                            rateTexts.isEmpty ? '1 USD = Base currency' : '1 USD = $rateTexts',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[500],
                                  fontSize: 11,
                                ),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),

                // Delete zone (recycle bin) - appears during dragging
                if (_isDragging)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: DragTarget<String>(
                      onWillAccept: (data) => data != null && data == _draggingCurrency,
                      onAccept: (currency) {
                        _onCurrencyDeleted(currency);
                      },
                      builder: (context, candidateData, rejectedData) {
                        final isHovering = candidateData.isNotEmpty;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 100,
                          decoration: BoxDecoration(
                            color: isHovering ? Colors.red[700] : Colors.red[400],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, -3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete_forever,
                                  size: isHovering ? 50 : 40,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  isHovering ? 'Release to delete' : 'Drop here to delete',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
    );
  }
}
