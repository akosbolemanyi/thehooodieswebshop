class CurrencyService {
  CurrencyService._();

  static final CurrencyService instance = CurrencyService._();

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
