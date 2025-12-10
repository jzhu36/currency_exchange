# Currency Converter

A simple Flutter Android application for converting currencies in real-time.

## Features

- Support for 4 currencies: USD, JPY, SGD, CNY
- Real-time conversion as you type
- Clean, intuitive interface
- No buttons required - just type in any field
- Hardcoded exchange rates (as of December 2025)

## Exchange Rates

The app uses the following exchange rates (with USD as base currency):

- 1 USD = 155.28 JPY
- 1 USD = 1.295 SGD
- 1 USD = 7.07 CNY

## How to Use

1. Simply type an amount in any of the four currency fields
2. The other three fields will automatically update with the converted amounts
3. That's it! No buttons to press.

## Technical Details

- **Framework**: Flutter 3.9.2
- **Platform**: Android (minimum SDK 21)
- **State Management**: Simple setState approach
- **Dependencies**: None (pure Flutter)

## Building and Running

```bash
# Install dependencies
flutter pub get

# Run on connected Android device or emulator
flutter run

# Build release APK
flutter build apk --release
```

## Project Structure

```
lib/
├── main.dart                      # App entry point
├── models/
│   └── currency_converter.dart    # Conversion logic
├── screens/
│   └── converter_screen.dart      # Main UI screen
└── widgets/
    └── currency_input_field.dart  # Reusable input widget
```

## Number Formatting

- JPY (Japanese Yen): Displayed with 0 decimal places (e.g., "155")
- USD, SGD, CNY: Displayed with up to 2 decimal places (e.g., "100.50")

## Future Enhancements

- Auto-fetch exchange rates from an API
- Support for more currencies
- Conversion history
- Offline rate caching
