import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../service/payment.service.dart';
import 'order-confirmation.dart';

class PaymentBackground extends StatelessWidget {
  const PaymentBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 15),
          child: Container(
            color: Colors.red,
            padding: EdgeInsets.only(top: 15),
            child: AppBar(
              leading: IconButton(
                icon:
                    Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                'Payment',
                style: GoogleFonts.cabin(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
              // backgroundColor: Colors.indigo.shade300,
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
                'Online payment is only available with credit cards. Paying in cash is available in our stores in person.',
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
              label: Text(
                'Pay via Credit Card',
                style: GoogleFonts.cabin(fontSize: 24, color: Colors.black),
              ),
              onPressed: () async {
                bool isSuccessful = await StripeService.instance.makePayment();
                // if (isSuccessful) {
                //   Navigator.of(context).push(PageTransition(
                //     type: PageTransitionType.fade,
                //     child: OrderConfirmationPage(),
                //   ));
                // }
              },
            ),
          ],
        ),
      ),
    );
  }
}
