import 'package:android_studio_projects/order/success-animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../providers/cart.provider.dart';
import '../providers/theme.provider.dart';
import '../services/currency.service.dart';
import '../services/order.service.dart';
import '../services/order-email.service.dart';
import '../services/payment.service.dart';

class PaymentBackground extends StatelessWidget {
  const PaymentBackground({super.key});

  Future<String?> _getUserName(BuildContext context) async {
    final nation = Locales.currentLocale(context)?.languageCode ?? 'en';
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userData.exists) return null;

    final profile = userData.data() as Map<String, dynamic>;
    final name = nation == 'hu'
        ? '${profile['lastname']} ${profile['firstname']}'
        : '${profile['firstname']} ${profile['lastname']}';

    return name;
  }

  @override
  Widget build(BuildContext context) {
    final nation = Locales.currentLocale(context)?.languageCode;
    final cartProvider = Provider.of<CartProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final cartItems = Provider.of<CartProvider>(context).orderItems;
    final languageCode = Locales.currentLocale(context)?.languageCode;
    final currencyService = CurrencyService.instance;
    final currency = currencyService.getCurrency(nation);
    final sumPrice = cartProvider.sumPrice(nation!);
    return FutureBuilder<String?>(
        future: _getUserName(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Scaffold(
              body: Center(child: Text("Unable to load user data.")),
            );
          }

          final name = snapshot.data!;
          return Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight + 10),
                child: Container(
                  color: Colors.red,
                  padding: EdgeInsets.only(top: 10),
                  child: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    iconTheme: IconThemeData(color: Colors.black),
                    title: LocaleText(
                      'payment',
                      style: GoogleFonts.cabin(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                )),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 5),
                  Text(
                    "Hooodies!",
                    style: GoogleFonts.lobster(fontSize: 50, color: Colors.red),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Text(
                      '${Locales.string(context, 'pay_online')}\n${Locales.string(context, 'pay_in_person')}',
                      style: GoogleFonts.cabin(
                        fontSize: 25,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 50, right: 50, top: 10),
                    child: Text(
                      currencyService.format(sumPrice, currency),
                      style: GoogleFonts.cabin(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(8.0, 50.0),
                    ),
                    icon: const Icon(Icons.credit_card_rounded,
                        size: 32, color: Colors.black),
                    label: LocaleText(
                      'pay_with_card',
                      style:
                          GoogleFonts.cabin(fontSize: 24, color: Colors.black),
                    ),
                    onPressed: () async {
                      bool isPaymentSuccessful = await StripeService.instance
                          .makePayment(cartProvider.sumPrice(nation), currency,
                              themeProvider, name);
                      if (isPaymentSuccessful) {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => const Center(
                            child: SpinKitDualRing(
                              color: Colors.red,
                              size: 40.0,
                            ),
                          ),
                        );
                        String orderId =
                            await OrderService.instance.create(cartItems);
                        if (orderId != '') {
                          String orderDate = DateTime.now().toString();
                          await sendEmails(
                              orderId, orderDate, cartProvider, languageCode!);
                          cartProvider.cartItems = [];
                          Navigator.of(context).push(PageTransition(
                            type: PageTransitionType.fade,
                            child: SuccessAnimationPage(orderId: orderId),
                          ));
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
