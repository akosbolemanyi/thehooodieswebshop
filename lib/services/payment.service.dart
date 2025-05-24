import 'package:android_studio_projects/constants.dart';
import 'package:android_studio_projects/providers/theme.provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<bool> makePayment(String price, String currency,
      ThemeProvider themeProvider, String name) async {
    try {
      String? paymentIntentClientSecret =
          await _createPaymentIntent(price, currency);
      if (paymentIntentClientSecret == null) return false;
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              style: themeProvider.themeMode,
              customFlow: false,
              appearance: PaymentSheetAppearance(
                  primaryButton: PaymentSheetPrimaryButtonAppearance(
                      shapes: PaymentSheetPrimaryButtonShape(blurRadius: 20.0)),
                  shapes: PaymentSheetShape(
                    borderRadius: 20.0,
                  )),
              paymentIntentClientSecret: paymentIntentClientSecret,
              merchantDisplayName: 'Bolemányi Ákos'));
      return await _processPayment();
    } catch (error) {
      print('Payment setup related error was caught! | $error');
      return false;
    }
  }

  Future<String?> _createPaymentIntent(String price, String currency) async {
    try {
      final Dio dio = Dio();

      Map<String, dynamic> data = {
        'amount': _calculateAmount(price, currency),
        'currency': currency.toLowerCase(),
      };
      var response = await dio.post('https://api.stripe.com/v1/payment_intents',
          data: data,
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            'Authorization': 'Bearer $stripeSecretKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          }));
      if (response.data != null) {
        return response.data['client_secret'];
      }
      return null;
    } catch (error) {
      print('The client_secret could not be requested:\n$error');
    }
    return null;
  }

  Future<bool> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      Stripe.instance.confirmPaymentSheetPayment();
      return true;
    } on StripeException catch (error) {
      print('Payment related error caught! | $error');
      return false;
    } catch (error) {
      print('Unexpected error was caught on payment! | $error');
      return false;
    }
  }

  String _calculateAmount(String price, String currency) {
    switch (currency) {
      case 'HUF':
        return (int.parse(price) * 100).toString();
      default:
        return (double.parse(price) * 100).round().toString();
    }
  }
}
