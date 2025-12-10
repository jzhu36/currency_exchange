import 'package:flutter_test/flutter_test.dart';
import 'package:currency_exchange/models/currency_converter.dart';

void main() {
  group('CurrencyConverter', () {
    test('converts USD to JPY correctly', () {
      final result = CurrencyConverter.convert(1.0, 'USD', 'JPY');
      expect(result, 155.28);
    });

    test('converts USD to SGD correctly', () {
      final result = CurrencyConverter.convert(1.0, 'USD', 'SGD');
      expect(result, 1.295);
    });

    test('converts USD to CNY correctly', () {
      final result = CurrencyConverter.convert(1.0, 'USD', 'CNY');
      expect(result, 7.07);
    });

    test('converts JPY to CNY correctly', () {
      // 1000 JPY = (1000 / 155.28) * 7.07 = 45.53 CNY
      final result = CurrencyConverter.convert(1000.0, 'JPY', 'CNY');
      expect(result, closeTo(45.53, 0.01));
    });

    test('converts SGD to USD correctly', () {
      // 100 SGD = (100 / 1.295) * 1.0 = 77.22 USD
      final result = CurrencyConverter.convert(100.0, 'SGD', 'USD');
      expect(result, closeTo(77.22, 0.01));
    });

    test('converts same currency returns same amount', () {
      expect(CurrencyConverter.convert(100.0, 'USD', 'USD'), 100.0);
      expect(CurrencyConverter.convert(100.0, 'JPY', 'JPY'), 100.0);
    });

    test('formats JPY with 0 decimal places', () {
      expect(CurrencyConverter.formatAmount(155.28, 'JPY'), '155');
      expect(CurrencyConverter.formatAmount(1000.0, 'JPY'), '1000');
    });

    test('formats USD with proper decimal places', () {
      expect(CurrencyConverter.formatAmount(100.50, 'USD'), '100.5');
      expect(CurrencyConverter.formatAmount(100.00, 'USD'), '100');
      expect(CurrencyConverter.formatAmount(99.99, 'USD'), '99.99');
    });

    test('formats SGD with proper decimal places', () {
      expect(CurrencyConverter.formatAmount(1.295, 'SGD'), '1.3');
      expect(CurrencyConverter.formatAmount(100.00, 'SGD'), '100');
    });

    test('formats CNY with proper decimal places', () {
      expect(CurrencyConverter.formatAmount(7.07, 'CNY'), '7.07');
      expect(CurrencyConverter.formatAmount(100.00, 'CNY'), '100');
    });

    test('getDecimalPlaces returns correct values', () {
      expect(CurrencyConverter.getDecimalPlaces('JPY'), 0);
      expect(CurrencyConverter.getDecimalPlaces('USD'), 2);
      expect(CurrencyConverter.getDecimalPlaces('SGD'), 2);
      expect(CurrencyConverter.getDecimalPlaces('CNY'), 2);
    });

    test('getSupportedCurrencies returns all currencies', () {
      final currencies = CurrencyConverter.getSupportedCurrencies();
      expect(currencies.length, 4);
      expect(currencies.contains('USD'), true);
      expect(currencies.contains('JPY'), true);
      expect(currencies.contains('SGD'), true);
      expect(currencies.contains('CNY'), true);
    });

    test('throws ArgumentError for unsupported currency', () {
      expect(
        () => CurrencyConverter.convert(100.0, 'USD', 'EUR'),
        throwsArgumentError,
      );
      expect(
        () => CurrencyConverter.convert(100.0, 'EUR', 'USD'),
        throwsArgumentError,
      );
    });
  });
}
