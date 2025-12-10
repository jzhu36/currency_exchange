import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/currency_converter.dart';
import '../models/currency_data.dart';

/// A reusable widget for currency input fields.
///
/// Displays a text field for entering currency amounts with:
/// - Country flag emoji on the left
/// - Currency code displayed prominently
/// - Compact height design
/// - Appropriate input formatting (digits only for JPY, decimal allowed for others)
/// - Number keyboard
/// - Card wrapper for visual separation
class CurrencyInputField extends StatelessWidget {
  final String currencyCode;
  final TextEditingController controller;
  final FocusNode focusNode;

  const CurrencyInputField({
    super.key,
    required this.currencyCode,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    // Get currency info
    final currencyInfo = CurrencyData.getCurrency(currencyCode);
    final flagEmoji = currencyInfo?.flagEmoji ?? '🏳️';
    
    // JPY and other zero-decimal currencies should only allow whole numbers
    final allowDecimals = CurrencyConverter.getDecimalPlaces(currencyCode) > 0;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
        child: Row(
          children: [
            // Flag emoji
            Text(
              flagEmoji,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 12),
            
            // Currency code - always visible
            Text(
              currencyCode,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            
            // Text field
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: '0',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                  isDense: true,
                ),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                inputFormatters: [
                  // For JPY: only allow digits (no decimal point)
                  // For others: allow digits and one decimal point
                  if (allowDecimals)
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                  else
                    FilteringTextInputFormatter.digitsOnly,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
