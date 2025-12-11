import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/currency_converter.dart';
import '../widgets/currency_input_field.dart';
import '../services/exchange_rate_service.dart';
import '../services/currency_preferences_service.dart';
import '../models/currency_data.dart';
import 'package:intl/intl.dart';
import 'add_currency_screen.dart';

/// Main screen for currency conversion.
class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  List<String> _currencies = [];
  Map<String, TextEditingController> _controllers = {};
  Map<String, FocusNode> _focusNodes = {};
  String _lastEditedCurrency = '';
  bool _isUpdating = false;
  DateTime? _lastUpdateTime;
  bool _isLoading = true;
  bool _isDragging = false;
  String? _draggingCurrency;
  bool _isRefreshing = false;
  Timer? _retryTimer;
  bool _hasLoadError = false;
  int? _dragOverIndex;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _loadCurrencies();
    await _loadExchangeRates();
  }

  Future<void> _loadCurrencies() async {
    final currencies = await CurrencyPreferencesService.getSelectedCurrencies();
    setState(() {
      _currencies = currencies;
      _setupControllersAndFocusNodes();
    });
    _updateAllFieldsFromExisting();
  }
  
  void _updateAllFieldsFromExisting() {
    for (final currency in _currencies) {
      final controller = _controllers[currency];
      if (controller != null && controller.text.isNotEmpty) {
        // Remove thousand separators before parsing
        final cleanText = controller.text.replaceAll(',', '');
        final amount = double.tryParse(cleanText);
        if (amount != null && amount > 0) {
          _lastEditedCurrency = currency;
          _updateOtherFields(currency, amount);
          return;
        }
      }
    }
  }

  void _setupControllersAndFocusNodes() {
    final Map<String, String> existingValues = {};
    for (var entry in _controllers.entries) {
      existingValues[entry.key] = entry.value.text;
    }
    
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes.values) {
      focusNode.dispose();
    }

    _controllers.clear();
    _focusNodes.clear();

    for (final currency in _currencies) {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      
      if (existingValues.containsKey(currency)) {
        controller.text = existingValues[currency]!;
      }

      controller.addListener(() => _onAmountChanged(currency));
      focusNode.addListener(() {
        if (focusNode.hasFocus) _lastEditedCurrency = currency;
      });

      _controllers[currency] = controller;
      _focusNodes[currency] = focusNode;
    }
  }

  Future<void> _loadExchangeRates() async {
    try {
      final data = await ExchangeRateService.getRates();
      final rates = data['rates'] as Map<String, dynamic>;
      final timestamp = data['timestamp'] as int;

      setState(() {
        CurrencyConverter.updateRates(rates);
        _lastUpdateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        _isLoading = false;
        _hasLoadError = false;
      });

      // Cancel retry timer if rates loaded successfully
      _retryTimer?.cancel();
      _retryTimer = null;
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasLoadError = true;
      });

      // Show toast notification
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to load exchange rates. Retrying...'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.orange,
          ),
        );
      }

      // Start auto-retry timer (retry every 30 seconds)
      _retryTimer?.cancel();
      _retryTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
        try {
          final data = await ExchangeRateService.getRates();
          final rates = data['rates'] as Map<String, dynamic>;
          final timestamp = data['timestamp'] as int;

          if (mounted) {
            setState(() {
              CurrencyConverter.updateRates(rates);
              _lastUpdateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
              _hasLoadError = false;
            });

            // Update all fields with new rates
            _updateAllFieldsFromExisting();

            // Cancel timer after successful retry
            timer.cancel();
            _retryTimer = null;
          }
        } catch (e) {
          // Continue retrying
        }
      });
    }
  }

  Future<void> _refreshRates() async {
    setState(() {
      _isRefreshing = true;
    });

    try {
      final data = await ExchangeRateService.getRates();
      final rates = data['rates'] as Map<String, dynamic>;
      final timestamp = data['timestamp'] as int;

      setState(() {
        CurrencyConverter.updateRates(rates);
        _lastUpdateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        _isRefreshing = false;
      });

      // Update all fields with new rates
      _updateAllFieldsFromExisting();
    } catch (e) {
      setState(() {
        _isRefreshing = false;
      });

      // Show error toast
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to refresh rates. Will retry automatically.'),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _onAmountChanged(String currency) {
    if (_isUpdating) return;

    if (_lastEditedCurrency == currency) {
      _isUpdating = true;

      try {
        final controller = _controllers[currency];
        if (controller == null) return;

        final text = controller.text;

        if (text.isEmpty) {
          _clearAllExcept(currency);
          return;
        }

        // Remove thousand separators before parsing
        final cleanText = text.replaceAll(',', '');
        final amount = double.tryParse(cleanText);
        if (amount == null) return;

        _updateOtherFields(currency, amount);
      } finally {
        _isUpdating = false;
      }
    }
  }

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

  void _updateOtherFields(String sourceCurrency, double amount) {
    for (final targetCurrency in _currencies) {
      if (targetCurrency == sourceCurrency) continue;

      try {
        final convertedAmount = CurrencyConverter.convert(
          amount,
          sourceCurrency,
          targetCurrency,
        );

        final formatted = CurrencyConverter.formatAmount(
          convertedAmount,
          targetCurrency,
        );

        final controller = _controllers[targetCurrency];
        if (controller != null) {
          controller.value = controller.value.copyWith(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        }
      } catch (e) {
        print('Failed to convert $sourceCurrency to $targetCurrency: $e');
      }
    }
  }

  void _onReorder(String draggedCurrency, int newIndex) async {
    final oldIndex = _currencies.indexOf(draggedCurrency);
    if (oldIndex == -1 || oldIndex == newIndex) return;

    setState(() {
      _currencies.removeAt(oldIndex);
      _currencies.insert(newIndex, draggedCurrency);
    });
    await CurrencyPreferencesService.saveSelectedCurrencies(_currencies);
  }

  Future<void> _onCurrencyDeleted(String currency) async {
    final success = await CurrencyPreferencesService.removeCurrency(currency);
    
    if (success) {
      setState(() {
        _currencies.remove(currency);
        _controllers[currency]?.dispose();
        _controllers.remove(currency);
        _focusNodes[currency]?.dispose();
        _focusNodes.remove(currency);
      });
    }
  }

  Future<void> _navigateToAddCurrency() async {
    // The add card is automatically hidden when at max capacity
    // so no need to check here

    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => const AddCurrencyScreen(),
      ),
    );

    if (result != null) {
      await _loadCurrencies();
      await _loadExchangeRates();
    }
  }

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
                Column(
                  children: [
                    const SizedBox(height: 20),
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
                    
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: _currencies.length >= 20 ? _currencies.length + 1 : _currencies.length + 2,
                        itemBuilder: (context, index) {
                          if (index == _currencies.length) {
                            // Add Currency card (if under 20 limit)
                            if (_currencies.length < 20) {
                              return Padding(
                                key: const ValueKey('add_currency_card'),
                                padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
                                child: InkWell(
                                  onTap: _navigateToAddCurrency,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      border: Border.all(
                                        color: Colors.grey[400]!,
                                        width: 2,
                                        style: BorderStyle.solid,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0,
                                      vertical: 18.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_circle_outline,
                                          size: 32,
                                          color: Colors.blue,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Add Currency',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          }

                          if (index > _currencies.length) {
                            // Bottom section
                            return Column(
                              key: const ValueKey('footer'),
                              children: [
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Last updated: ${_formatUpdateTime(_lastUpdateTime)}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: _isRefreshing
                                          ? SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.grey[600],
                                              ),
                                            )
                                          : Icon(
                                              Icons.refresh,
                                              size: 20,
                                              color: Colors.grey[600],
                                            ),
                                      onPressed: _isRefreshing ? null : _refreshRates,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      tooltip: 'Refresh exchange rates',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Builder(
                                  builder: (context) {
                                    final rates = CurrencyConverter.getRates();
                                    final usdRate = rates['USD'] ?? 1.0;
                                    final rateTexts = _currencies.where((c) => c != 'USD').map((c) {
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
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    );
                                  },
                                ),
                                SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                              ],
                            );
                          }

                          final currency = _currencies[index];
                          final controller = _controllers[currency];
                          final focusNode = _focusNodes[currency];

                          if (controller == null || focusNode == null) {
                            return const SizedBox.shrink(key: ValueKey('empty'));
                          }

                          return DragTarget<String>(
                            onWillAccept: (data) {
                              return data != null && data != currency && _isDragging;
                            },
                            onAccept: (draggedCurrency) {
                              _onReorder(draggedCurrency, index);
                              setState(() {
                                _dragOverIndex = null;
                              });
                            },
                            onMove: (details) {
                              if (_dragOverIndex != index) {
                                setState(() {
                                  _dragOverIndex = index;
                                });
                              }
                            },
                            onLeave: (data) {
                              if (_dragOverIndex == index) {
                                setState(() {
                                  _dragOverIndex = null;
                                });
                              }
                            },
                            builder: (context, candidateData, rejectedData) {
                              final isHovering = candidateData.isNotEmpty;

                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: EdgeInsets.only(
                                  top: isHovering && index == 0 ? 8.0 : 0.0,
                                  bottom: isHovering ? 20.0 : 12.0,
                                ),
                                child: Column(
                                  children: [
                                    if (isHovering && index > 0)
                                      Container(
                                        height: 4,
                                        color: Colors.blue,
                                        margin: const EdgeInsets.only(bottom: 8.0),
                                      ),
                                    LongPressDraggable<String>(
                                      data: currency,
                                      feedback: Material(
                                        elevation: 8,
                                        borderRadius: BorderRadius.circular(12),
                                        child: Opacity(
                                          opacity: 0.8,
                                          child: SizedBox(
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
                                        HapticFeedback.mediumImpact();
                                        setState(() {
                                          _isDragging = true;
                                          _draggingCurrency = currency;
                                        });
                                      },
                                      onDragEnd: (details) {
                                        setState(() {
                                          _isDragging = false;
                                          _draggingCurrency = null;
                                          _dragOverIndex = null;
                                        });
                                      },
                                      child: CurrencyInputField(
                                        currencyCode: currency,
                                        controller: controller,
                                        focusNode: focusNode,
                                      ),
                                    ),
                                    if (isHovering && index == _currencies.length - 1)
                                      Container(
                                        height: 4,
                                        color: Colors.blue,
                                        margin: const EdgeInsets.only(top: 8.0),
                                      ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),

                if (_isDragging)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 20 + MediaQuery.of(context).padding.bottom,
                    child: Center(
                      child: DragTarget<String>(
                        onWillAccept: (data) => data != null && data == _draggingCurrency,
                        onAccept: (currency) {
                          _onCurrencyDeleted(currency);
                        },
                        builder: (context, candidateData, rejectedData) {
                          final isHovering = candidateData.isNotEmpty;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: isHovering ? Colors.red[700] : Colors.red[400],
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.delete_forever,
                              size: isHovering ? 36 : 30,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
