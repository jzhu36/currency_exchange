import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/currency_converter.dart';
import '../models/currency_data.dart';

/// Custom text input formatter that adds thousand separators as user types.
class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final int decimalPlaces;

  ThousandsSeparatorInputFormatter({required this.decimalPlaces});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all commas to get the raw number
    String newText = newValue.text.replaceAll(',', '');

    // Validate input: only digits and optional decimal point
    if (decimalPlaces > 0) {
      if (!RegExp(r'^\d*\.?\d*$').hasMatch(newText)) {
        return oldValue;
      }
    } else {
      if (!RegExp(r'^\d*$').hasMatch(newText)) {
        return oldValue;
      }
    }

    // Handle decimal places limit
    if (newText.contains('.')) {
      final parts = newText.split('.');
      if (parts.length > 2) {
        return oldValue; // Multiple decimal points not allowed
      }
      if (parts[1].length > decimalPlaces) {
        return oldValue; // Too many decimal places
      }
    }

    // Format with thousand separators
    String formattedText = _formatWithThousands(newText, decimalPlaces);

    // Calculate cursor position in the raw (unformatted) text
    int rawCursorPosition = newValue.selection.end;
    
    // Count how many commas were in the input text before the cursor
    int commasBeforeCursor = 0;
    for (int i = 0; i < newValue.selection.end && i < newValue.text.length; i++) {
      if (newValue.text[i] == ',') {
        commasBeforeCursor++;
      }
    }
    
    // Adjust raw cursor position by removing commas
    rawCursorPosition -= commasBeforeCursor;
    rawCursorPosition = rawCursorPosition.clamp(0, newText.length);
    
    // Find the corresponding position in formatted text
    int formattedCursorPosition = 0;
    int rawPosition = 0;
    while (rawPosition < rawCursorPosition && formattedCursorPosition < formattedText.length) {
      if (formattedText[formattedCursorPosition] != ',') {
        rawPosition++;
      }
      formattedCursorPosition++;
    }
    
    formattedCursorPosition = formattedCursorPosition.clamp(0, formattedText.length);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedCursorPosition),
    );
  }

  String _formatWithThousands(String value, int decimalPlaces) {
    if (value.isEmpty) return '';

    // Split into integer and decimal parts
    final parts = value.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    // Add thousand separators to integer part
    if (integerPart.isNotEmpty) {
      final number = int.tryParse(integerPart);
      if (number != null) {
        final formatter = NumberFormat('#,###', 'en_US');
        integerPart = formatter.format(number);
      }
    }

    // Reconstruct the number
    if (decimalPart.isNotEmpty || value.endsWith('.')) {
      return '$integerPart.${decimalPart}';
    }
    return integerPart;
  }
}

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
  final Widget? leadingWidget;

  const CurrencyInputField({
    super.key,
    required this.currencyCode,
    required this.controller,
    required this.focusNode,
    this.leadingWidget,
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
            // Optional leading widget (like drag handle)
            if (leadingWidget != null) ...[
              leadingWidget!,
              const SizedBox(width: 8),
            ],
            
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
                  ThousandsSeparatorInputFormatter(
                    decimalPlaces: CurrencyConverter.getDecimalPlaces(currencyCode),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
