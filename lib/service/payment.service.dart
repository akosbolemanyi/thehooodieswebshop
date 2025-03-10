import 'package:android_studio_projects/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<bool> makePayment() async {
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(10, 'usd');
      if (paymentIntentClientSecret == null) return false;
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              // TODO - Make styling.
              paymentIntentClientSecret: paymentIntentClientSecret,
              merchantDisplayName: 'Bolemányi Ákos'));
      await _processPayment();
      return true;
    } catch (error) {
      print('1 | The following error was caught:\n$error');
      return false;
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        'amount': _calculateAmount(amount),
        'currency': currency,
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
      print('2 | The following error was caught:\n$error');
    }
    return null;
  }

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      // TODO - Track and handle the payment status!
      // await Stripe.instance.confirmPaymentSheetPayment();
    } catch (error) {
      print('3 | The following error was caught:\n$error');
    }
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}
