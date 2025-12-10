/// Currency information including country, code, and display details.
class CurrencyInfo {
  final String code;
  final String countryName;
  final String currencyName;
  final String flagEmoji;
  final int decimalPlaces;

  const CurrencyInfo({
    required this.code,
    required this.countryName,
    required this.currencyName,
    required this.flagEmoji,
    this.decimalPlaces = 2,
  });
}

/// Complete database of world currencies.
class CurrencyData {
  static const List<CurrencyInfo> allCurrencies = [
    CurrencyInfo(code: 'AED', countryName: 'United Arab Emirates', currencyName: 'Dirham', flagEmoji: '🇦🇪'),
    CurrencyInfo(code: 'AFN', countryName: 'Afghanistan', currencyName: 'Afghani', flagEmoji: '🇦🇫'),
    CurrencyInfo(code: 'ALL', countryName: 'Albania', currencyName: 'Lek', flagEmoji: '🇦🇱'),
    CurrencyInfo(code: 'AMD', countryName: 'Armenia', currencyName: 'Dram', flagEmoji: '🇦🇲'),
    CurrencyInfo(code: 'ANG', countryName: 'Netherlands Antilles', currencyName: 'Guilder', flagEmoji: '🇳🇱'),
    CurrencyInfo(code: 'AOA', countryName: 'Angola', currencyName: 'Kwanza', flagEmoji: '🇦🇴'),
    CurrencyInfo(code: 'ARS', countryName: 'Argentina', currencyName: 'Peso', flagEmoji: '🇦🇷'),
    CurrencyInfo(code: 'AUD', countryName: 'Australia', currencyName: 'Dollar', flagEmoji: '🇦🇺'),
    CurrencyInfo(code: 'AWG', countryName: 'Aruba', currencyName: 'Florin', flagEmoji: '🇦🇼'),
    CurrencyInfo(code: 'AZN', countryName: 'Azerbaijan', currencyName: 'Manat', flagEmoji: '🇦🇿'),
    CurrencyInfo(code: 'BAM', countryName: 'Bosnia', currencyName: 'Mark', flagEmoji: '🇧🇦'),
    CurrencyInfo(code: 'BBD', countryName: 'Barbados', currencyName: 'Dollar', flagEmoji: '🇧🇧'),
    CurrencyInfo(code: 'BDT', countryName: 'Bangladesh', currencyName: 'Taka', flagEmoji: '🇧🇩'),
    CurrencyInfo(code: 'BGN', countryName: 'Bulgaria', currencyName: 'Lev', flagEmoji: '🇧🇬'),
    CurrencyInfo(code: 'BHD', countryName: 'Bahrain', currencyName: 'Dinar', flagEmoji: '🇧🇭', decimalPlaces: 3),
    CurrencyInfo(code: 'BIF', countryName: 'Burundi', currencyName: 'Franc', flagEmoji: '🇧🇮', decimalPlaces: 0),
    CurrencyInfo(code: 'BMD', countryName: 'Bermuda', currencyName: 'Dollar', flagEmoji: '🇧🇲'),
    CurrencyInfo(code: 'BND', countryName: 'Brunei', currencyName: 'Dollar', flagEmoji: '🇧🇳'),
    CurrencyInfo(code: 'BOB', countryName: 'Bolivia', currencyName: 'Boliviano', flagEmoji: '🇧🇴'),
    CurrencyInfo(code: 'BRL', countryName: 'Brazil', currencyName: 'Real', flagEmoji: '🇧🇷'),
    CurrencyInfo(code: 'BSD', countryName: 'Bahamas', currencyName: 'Dollar', flagEmoji: '🇧🇸'),
    CurrencyInfo(code: 'BTN', countryName: 'Bhutan', currencyName: 'Ngultrum', flagEmoji: '🇧🇹'),
    CurrencyInfo(code: 'BWP', countryName: 'Botswana', currencyName: 'Pula', flagEmoji: '🇧🇼'),
    CurrencyInfo(code: 'BYN', countryName: 'Belarus', currencyName: 'Ruble', flagEmoji: '🇧🇾'),
    CurrencyInfo(code: 'BZD', countryName: 'Belize', currencyName: 'Dollar', flagEmoji: '🇧🇿'),
    CurrencyInfo(code: 'CAD', countryName: 'Canada', currencyName: 'Dollar', flagEmoji: '🇨🇦'),
    CurrencyInfo(code: 'CDF', countryName: 'Congo', currencyName: 'Franc', flagEmoji: '🇨🇩'),
    CurrencyInfo(code: 'CHF', countryName: 'Switzerland', currencyName: 'Franc', flagEmoji: '🇨🇭'),
    CurrencyInfo(code: 'CLP', countryName: 'Chile', currencyName: 'Peso', flagEmoji: '🇨🇱', decimalPlaces: 0),
    CurrencyInfo(code: 'CNY', countryName: 'China', currencyName: 'Yuan', flagEmoji: '🇨🇳'),
    CurrencyInfo(code: 'COP', countryName: 'Colombia', currencyName: 'Peso', flagEmoji: '🇨🇴'),
    CurrencyInfo(code: 'CRC', countryName: 'Costa Rica', currencyName: 'Colon', flagEmoji: '🇨🇷'),
    CurrencyInfo(code: 'CUP', countryName: 'Cuba', currencyName: 'Peso', flagEmoji: '🇨🇺'),
    CurrencyInfo(code: 'CVE', countryName: 'Cape Verde', currencyName: 'Escudo', flagEmoji: '🇨🇻'),
    CurrencyInfo(code: 'CZK', countryName: 'Czech Republic', currencyName: 'Koruna', flagEmoji: '🇨🇿'),
    CurrencyInfo(code: 'DJF', countryName: 'Djibouti', currencyName: 'Franc', flagEmoji: '🇩🇯', decimalPlaces: 0),
    CurrencyInfo(code: 'DKK', countryName: 'Denmark', currencyName: 'Krone', flagEmoji: '🇩🇰'),
    CurrencyInfo(code: 'DOP', countryName: 'Dominican Republic', currencyName: 'Peso', flagEmoji: '🇩🇴'),
    CurrencyInfo(code: 'DZD', countryName: 'Algeria', currencyName: 'Dinar', flagEmoji: '🇩🇿'),
    CurrencyInfo(code: 'EGP', countryName: 'Egypt', currencyName: 'Pound', flagEmoji: '🇪🇬'),
    CurrencyInfo(code: 'ERN', countryName: 'Eritrea', currencyName: 'Nakfa', flagEmoji: '🇪🇷'),
    CurrencyInfo(code: 'ETB', countryName: 'Ethiopia', currencyName: 'Birr', flagEmoji: '🇪🇹'),
    CurrencyInfo(code: 'EUR', countryName: 'Eurozone', currencyName: 'Euro', flagEmoji: '🇪🇺'),
    CurrencyInfo(code: 'FJD', countryName: 'Fiji', currencyName: 'Dollar', flagEmoji: '🇫🇯'),
    CurrencyInfo(code: 'FKP', countryName: 'Falkland Islands', currencyName: 'Pound', flagEmoji: '🇫🇰'),
    CurrencyInfo(code: 'FOK', countryName: 'Faroe Islands', currencyName: 'Krona', flagEmoji: '🇫🇴'),
    CurrencyInfo(code: 'GBP', countryName: 'United Kingdom', currencyName: 'Pound', flagEmoji: '🇬🇧'),
    CurrencyInfo(code: 'GEL', countryName: 'Georgia', currencyName: 'Lari', flagEmoji: '🇬🇪'),
    CurrencyInfo(code: 'GGP', countryName: 'Guernsey', currencyName: 'Pound', flagEmoji: '🇬🇬'),
    CurrencyInfo(code: 'GHS', countryName: 'Ghana', currencyName: 'Cedi', flagEmoji: '🇬🇭'),
    CurrencyInfo(code: 'GIP', countryName: 'Gibraltar', currencyName: 'Pound', flagEmoji: '🇬🇮'),
    CurrencyInfo(code: 'GMD', countryName: 'Gambia', currencyName: 'Dalasi', flagEmoji: '🇬🇲'),
    CurrencyInfo(code: 'GNF', countryName: 'Guinea', currencyName: 'Franc', flagEmoji: '🇬🇳', decimalPlaces: 0),
    CurrencyInfo(code: 'GTQ', countryName: 'Guatemala', currencyName: 'Quetzal', flagEmoji: '🇬🇹'),
    CurrencyInfo(code: 'GYD', countryName: 'Guyana', currencyName: 'Dollar', flagEmoji: '🇬🇾'),
    CurrencyInfo(code: 'HKD', countryName: 'Hong Kong', currencyName: 'Dollar', flagEmoji: '🇭🇰'),
    CurrencyInfo(code: 'HNL', countryName: 'Honduras', currencyName: 'Lempira', flagEmoji: '🇭🇳'),
    CurrencyInfo(code: 'HRK', countryName: 'Croatia', currencyName: 'Kuna', flagEmoji: '🇭🇷'),
    CurrencyInfo(code: 'HTG', countryName: 'Haiti', currencyName: 'Gourde', flagEmoji: '🇭🇹'),
    CurrencyInfo(code: 'HUF', countryName: 'Hungary', currencyName: 'Forint', flagEmoji: '🇭🇺'),
    CurrencyInfo(code: 'IDR', countryName: 'Indonesia', currencyName: 'Rupiah', flagEmoji: '🇮🇩'),
    CurrencyInfo(code: 'ILS', countryName: 'Israel', currencyName: 'Shekel', flagEmoji: '🇮🇱'),
    CurrencyInfo(code: 'IMP', countryName: 'Isle of Man', currencyName: 'Pound', flagEmoji: '🇮🇲'),
    CurrencyInfo(code: 'INR', countryName: 'India', currencyName: 'Rupee', flagEmoji: '🇮🇳'),
    CurrencyInfo(code: 'IQD', countryName: 'Iraq', currencyName: 'Dinar', flagEmoji: '🇮🇶', decimalPlaces: 3),
    CurrencyInfo(code: 'IRR', countryName: 'Iran', currencyName: 'Rial', flagEmoji: '🇮🇷'),
    CurrencyInfo(code: 'ISK', countryName: 'Iceland', currencyName: 'Krona', flagEmoji: '🇮🇸', decimalPlaces: 0),
    CurrencyInfo(code: 'JEP', countryName: 'Jersey', currencyName: 'Pound', flagEmoji: '🇯🇪'),
    CurrencyInfo(code: 'JMD', countryName: 'Jamaica', currencyName: 'Dollar', flagEmoji: '🇯🇲'),
    CurrencyInfo(code: 'JOD', countryName: 'Jordan', currencyName: 'Dinar', flagEmoji: '🇯🇴', decimalPlaces: 3),
    CurrencyInfo(code: 'JPY', countryName: 'Japan', currencyName: 'Yen', flagEmoji: '🇯🇵', decimalPlaces: 0),
    CurrencyInfo(code: 'KES', countryName: 'Kenya', currencyName: 'Shilling', flagEmoji: '🇰🇪'),
    CurrencyInfo(code: 'KGS', countryName: 'Kyrgyzstan', currencyName: 'Som', flagEmoji: '🇰🇬'),
    CurrencyInfo(code: 'KHR', countryName: 'Cambodia', currencyName: 'Riel', flagEmoji: '🇰🇭'),
    CurrencyInfo(code: 'KID', countryName: 'Kiribati', currencyName: 'Dollar', flagEmoji: '🇰🇮'),
    CurrencyInfo(code: 'KMF', countryName: 'Comoros', currencyName: 'Franc', flagEmoji: '🇰🇲', decimalPlaces: 0),
    CurrencyInfo(code: 'KRW', countryName: 'South Korea', currencyName: 'Won', flagEmoji: '🇰🇷', decimalPlaces: 0),
    CurrencyInfo(code: 'KWD', countryName: 'Kuwait', currencyName: 'Dinar', flagEmoji: '🇰🇼', decimalPlaces: 3),
    CurrencyInfo(code: 'KYD', countryName: 'Cayman Islands', currencyName: 'Dollar', flagEmoji: '🇰🇾'),
    CurrencyInfo(code: 'KZT', countryName: 'Kazakhstan', currencyName: 'Tenge', flagEmoji: '🇰🇿'),
    CurrencyInfo(code: 'LAK', countryName: 'Laos', currencyName: 'Kip', flagEmoji: '🇱🇦'),
    CurrencyInfo(code: 'LBP', countryName: 'Lebanon', currencyName: 'Pound', flagEmoji: '🇱🇧'),
    CurrencyInfo(code: 'LKR', countryName: 'Sri Lanka', currencyName: 'Rupee', flagEmoji: '🇱🇰'),
    CurrencyInfo(code: 'LRD', countryName: 'Liberia', currencyName: 'Dollar', flagEmoji: '🇱🇷'),
    CurrencyInfo(code: 'LSL', countryName: 'Lesotho', currencyName: 'Loti', flagEmoji: '🇱🇸'),
    CurrencyInfo(code: 'LYD', countryName: 'Libya', currencyName: 'Dinar', flagEmoji: '🇱🇾', decimalPlaces: 3),
    CurrencyInfo(code: 'MAD', countryName: 'Morocco', currencyName: 'Dirham', flagEmoji: '🇲🇦'),
    CurrencyInfo(code: 'MDL', countryName: 'Moldova', currencyName: 'Leu', flagEmoji: '🇲🇩'),
    CurrencyInfo(code: 'MGA', countryName: 'Madagascar', currencyName: 'Ariary', flagEmoji: '🇲🇬'),
    CurrencyInfo(code: 'MKD', countryName: 'North Macedonia', currencyName: 'Denar', flagEmoji: '🇲🇰'),
    CurrencyInfo(code: 'MMK', countryName: 'Myanmar', currencyName: 'Kyat', flagEmoji: '🇲🇲'),
    CurrencyInfo(code: 'MNT', countryName: 'Mongolia', currencyName: 'Tugrik', flagEmoji: '🇲🇳'),
    CurrencyInfo(code: 'MOP', countryName: 'Macau', currencyName: 'Pataca', flagEmoji: '🇲🇴'),
    CurrencyInfo(code: 'MRU', countryName: 'Mauritania', currencyName: 'Ouguiya', flagEmoji: '🇲🇷'),
    CurrencyInfo(code: 'MUR', countryName: 'Mauritius', currencyName: 'Rupee', flagEmoji: '🇲🇺'),
    CurrencyInfo(code: 'MVR', countryName: 'Maldives', currencyName: 'Rufiyaa', flagEmoji: '🇲🇻'),
    CurrencyInfo(code: 'MWK', countryName: 'Malawi', currencyName: 'Kwacha', flagEmoji: '🇲🇼'),
    CurrencyInfo(code: 'MXN', countryName: 'Mexico', currencyName: 'Peso', flagEmoji: '🇲🇽'),
    CurrencyInfo(code: 'MYR', countryName: 'Malaysia', currencyName: 'Ringgit', flagEmoji: '🇲🇾'),
    CurrencyInfo(code: 'MZN', countryName: 'Mozambique', currencyName: 'Metical', flagEmoji: '🇲🇿'),
    CurrencyInfo(code: 'NAD', countryName: 'Namibia', currencyName: 'Dollar', flagEmoji: '🇳🇦'),
    CurrencyInfo(code: 'NGN', countryName: 'Nigeria', currencyName: 'Naira', flagEmoji: '🇳🇬'),
    CurrencyInfo(code: 'NIO', countryName: 'Nicaragua', currencyName: 'Cordoba', flagEmoji: '🇳🇮'),
    CurrencyInfo(code: 'NOK', countryName: 'Norway', currencyName: 'Krone', flagEmoji: '🇳🇴'),
    CurrencyInfo(code: 'NPR', countryName: 'Nepal', currencyName: 'Rupee', flagEmoji: '🇳🇵'),
    CurrencyInfo(code: 'NZD', countryName: 'New Zealand', currencyName: 'Dollar', flagEmoji: '🇳🇿'),
    CurrencyInfo(code: 'OMR', countryName: 'Oman', currencyName: 'Rial', flagEmoji: '🇴🇲', decimalPlaces: 3),
    CurrencyInfo(code: 'PAB', countryName: 'Panama', currencyName: 'Balboa', flagEmoji: '🇵🇦'),
    CurrencyInfo(code: 'PEN', countryName: 'Peru', currencyName: 'Sol', flagEmoji: '🇵🇪'),
    CurrencyInfo(code: 'PGK', countryName: 'Papua New Guinea', currencyName: 'Kina', flagEmoji: '🇵🇬'),
    CurrencyInfo(code: 'PHP', countryName: 'Philippines', currencyName: 'Peso', flagEmoji: '🇵🇭'),
    CurrencyInfo(code: 'PKR', countryName: 'Pakistan', currencyName: 'Rupee', flagEmoji: '🇵🇰'),
    CurrencyInfo(code: 'PLN', countryName: 'Poland', currencyName: 'Zloty', flagEmoji: '🇵🇱'),
    CurrencyInfo(code: 'PYG', countryName: 'Paraguay', currencyName: 'Guarani', flagEmoji: '🇵🇾', decimalPlaces: 0),
    CurrencyInfo(code: 'QAR', countryName: 'Qatar', currencyName: 'Riyal', flagEmoji: '🇶🇦'),
    CurrencyInfo(code: 'RON', countryName: 'Romania', currencyName: 'Leu', flagEmoji: '🇷🇴'),
    CurrencyInfo(code: 'RSD', countryName: 'Serbia', currencyName: 'Dinar', flagEmoji: '🇷🇸'),
    CurrencyInfo(code: 'RUB', countryName: 'Russia', currencyName: 'Ruble', flagEmoji: '🇷🇺'),
    CurrencyInfo(code: 'RWF', countryName: 'Rwanda', currencyName: 'Franc', flagEmoji: '🇷🇼', decimalPlaces: 0),
    CurrencyInfo(code: 'SAR', countryName: 'Saudi Arabia', currencyName: 'Riyal', flagEmoji: '🇸🇦'),
    CurrencyInfo(code: 'SBD', countryName: 'Solomon Islands', currencyName: 'Dollar', flagEmoji: '🇸🇧'),
    CurrencyInfo(code: 'SCR', countryName: 'Seychelles', currencyName: 'Rupee', flagEmoji: '🇸🇨'),
    CurrencyInfo(code: 'SDG', countryName: 'Sudan', currencyName: 'Pound', flagEmoji: '🇸🇩'),
    CurrencyInfo(code: 'SEK', countryName: 'Sweden', currencyName: 'Krona', flagEmoji: '🇸🇪'),
    CurrencyInfo(code: 'SGD', countryName: 'Singapore', currencyName: 'Dollar', flagEmoji: '🇸🇬'),
    CurrencyInfo(code: 'SHP', countryName: 'Saint Helena', currencyName: 'Pound', flagEmoji: '🇸🇭'),
    CurrencyInfo(code: 'SLE', countryName: 'Sierra Leone', currencyName: 'Leone', flagEmoji: '🇸🇱'),
    CurrencyInfo(code: 'SOS', countryName: 'Somalia', currencyName: 'Shilling', flagEmoji: '🇸🇴'),
    CurrencyInfo(code: 'SRD', countryName: 'Suriname', currencyName: 'Dollar', flagEmoji: '🇸🇷'),
    CurrencyInfo(code: 'SSP', countryName: 'South Sudan', currencyName: 'Pound', flagEmoji: '🇸🇸'),
    CurrencyInfo(code: 'STN', countryName: 'São Tomé and Príncipe', currencyName: 'Dobra', flagEmoji: '🇸🇹'),
    CurrencyInfo(code: 'SYP', countryName: 'Syria', currencyName: 'Pound', flagEmoji: '🇸🇾'),
    CurrencyInfo(code: 'SZL', countryName: 'Eswatini', currencyName: 'Lilangeni', flagEmoji: '🇸🇿'),
    CurrencyInfo(code: 'THB', countryName: 'Thailand', currencyName: 'Baht', flagEmoji: '🇹🇭'),
    CurrencyInfo(code: 'TJS', countryName: 'Tajikistan', currencyName: 'Somoni', flagEmoji: '🇹🇯'),
    CurrencyInfo(code: 'TMT', countryName: 'Turkmenistan', currencyName: 'Manat', flagEmoji: '🇹🇲'),
    CurrencyInfo(code: 'TND', countryName: 'Tunisia', currencyName: 'Dinar', flagEmoji: '🇹🇳', decimalPlaces: 3),
    CurrencyInfo(code: 'TOP', countryName: 'Tonga', currencyName: 'Paʻanga', flagEmoji: '🇹🇴'),
    CurrencyInfo(code: 'TRY', countryName: 'Turkey', currencyName: 'Lira', flagEmoji: '🇹🇷'),
    CurrencyInfo(code: 'TTD', countryName: 'Trinidad and Tobago', currencyName: 'Dollar', flagEmoji: '🇹🇹'),
    CurrencyInfo(code: 'TVD', countryName: 'Tuvalu', currencyName: 'Dollar', flagEmoji: '🇹🇻'),
    CurrencyInfo(code: 'TWD', countryName: 'Taiwan', currencyName: 'Dollar', flagEmoji: '🇹🇼'),
    CurrencyInfo(code: 'TZS', countryName: 'Tanzania', currencyName: 'Shilling', flagEmoji: '🇹🇿'),
    CurrencyInfo(code: 'UAH', countryName: 'Ukraine', currencyName: 'Hryvnia', flagEmoji: '🇺🇦'),
    CurrencyInfo(code: 'UGX', countryName: 'Uganda', currencyName: 'Shilling', flagEmoji: '🇺🇬', decimalPlaces: 0),
    CurrencyInfo(code: 'USD', countryName: 'United States', currencyName: 'Dollar', flagEmoji: '🇺🇸'),
    CurrencyInfo(code: 'UYU', countryName: 'Uruguay', currencyName: 'Peso', flagEmoji: '🇺🇾'),
    CurrencyInfo(code: 'UZS', countryName: 'Uzbekistan', currencyName: 'Som', flagEmoji: '🇺🇿'),
    CurrencyInfo(code: 'VES', countryName: 'Venezuela', currencyName: 'Bolívar', flagEmoji: '🇻🇪'),
    CurrencyInfo(code: 'VND', countryName: 'Vietnam', currencyName: 'Dong', flagEmoji: '🇻🇳', decimalPlaces: 0),
    CurrencyInfo(code: 'VUV', countryName: 'Vanuatu', currencyName: 'Vatu', flagEmoji: '🇻🇺', decimalPlaces: 0),
    CurrencyInfo(code: 'WST', countryName: 'Samoa', currencyName: 'Tala', flagEmoji: '🇼🇸'),
    CurrencyInfo(code: 'XAF', countryName: 'Central Africa', currencyName: 'CFA Franc', flagEmoji: '🌍', decimalPlaces: 0),
    CurrencyInfo(code: 'XCD', countryName: 'East Caribbean', currencyName: 'Dollar', flagEmoji: '🌴'),
    CurrencyInfo(code: 'XDR', countryName: 'IMF', currencyName: 'SDR', flagEmoji: '🏛️'),
    CurrencyInfo(code: 'XOF', countryName: 'West Africa', currencyName: 'CFA Franc', flagEmoji: '🌍', decimalPlaces: 0),
    CurrencyInfo(code: 'XPF', countryName: 'French Pacific', currencyName: 'Franc', flagEmoji: '🇵🇫', decimalPlaces: 0),
    CurrencyInfo(code: 'YER', countryName: 'Yemen', currencyName: 'Rial', flagEmoji: '🇾🇪'),
    CurrencyInfo(code: 'ZAR', countryName: 'South Africa', currencyName: 'Rand', flagEmoji: '🇿🇦'),
    CurrencyInfo(code: 'ZMW', countryName: 'Zambia', currencyName: 'Kwacha', flagEmoji: '🇿🇲'),
    CurrencyInfo(code: 'ZWL', countryName: 'Zimbabwe', currencyName: 'Dollar', flagEmoji: '🇿🇼'),
  ];

  /// Get currency info by code.
  static CurrencyInfo? getCurrency(String code) {
    try {
      return allCurrencies.firstWhere((c) => c.code == code);
    } catch (e) {
      return null;
    }
  }

  /// Get flag emoji for currency code.
  static String getFlagEmoji(String code) {
    final currency = getCurrency(code);
    return currency?.flagEmoji ?? '🏳️';
  }

  /// Get decimal places for currency code.
  static int getDecimalPlaces(String code) {
    final currency = getCurrency(code);
    return currency?.decimalPlaces ?? 2;
  }

  /// Search currencies by country name or currency code.
  static List<CurrencyInfo> search(String query) {
    if (query.isEmpty) return allCurrencies;
    
    final lowerQuery = query.toLowerCase();
    return allCurrencies.where((currency) {
      return currency.countryName.toLowerCase().contains(lowerQuery) ||
             currency.code.toLowerCase().contains(lowerQuery) ||
             currency.currencyName.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}