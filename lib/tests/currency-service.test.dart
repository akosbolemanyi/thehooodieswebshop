import 'package:flutter_test/flutter_test.dart';
import '../services/currency.service.dart';

void main() {
  final currencyService = CurrencyService.instance;

  group('CurrencyService', () {
    test('Should return HUF for the hungarian language!', () {
      expect(currencyService.getCurrency('hu'), 'HUF');
    });

    test('Should return USD for the english language!', () {
      expect(currencyService.getCurrency('en'), 'USD');
    });

    test('Should return EURO currency for intended users and null-value!', () {
      expect(currencyService.getCurrency('de'), 'EUR');
      expect(currencyService.getCurrency(null), 'EUR');
      expect(currencyService.getCurrency('fr'), 'EUR');
    });
  });

  group('CurrencyService format', () {
    test('Should format the HUF currency correctly!', () {
      expect(currencyService.format('1000', 'HUF'), '1000 Ft');
    });

    test('Should format the USD currency correctly!', () {
      expect(currencyService.format('25', 'USD'), r'$25');
    });

    test('Should format the EUR currency correctly!', () {
      expect(currencyService.format('50', 'EUR'), '€50');
    });

    test('Should give EURO back, as non-existent currency is given!', () {
      expect(currencyService.format('75', 'ABC'), '€75');
    });
  });
}
