class CurrencyService {
  CurrencyService._();

  static final CurrencyService instance = CurrencyService._();

  String getCurrency(String? language) {
    switch (language) {
      case 'hu':
        return 'HUF';
      case 'en':
        return 'USD';
      default:
        return 'EUR';
    }
  }

  String format(String raw, String currency) {
    switch (currency) {
      case 'HUF':
        return '$raw Ft';
      case 'USD':
        return '\$$raw';
      default:
        return '€$raw';
    }
  }
}
