import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../menu/custom-drawer.dart' as sidebar;
import '../menu/custom-bottom-navigation-bar.dart' as OwnBar;

class OrderFeedback extends StatelessWidget {
  final String orderId;
  const OrderFeedback({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: sidebar.NavigationDrawer(),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 15),
          child: Container(
              color: Colors.green,
              padding: EdgeInsets.only(top: 15),
              child: AppBar(
                backgroundColor: Colors.green,
                iconTheme: IconThemeData(color: Colors.black),
                title: Text(
                  'Successful order',
                  style: GoogleFonts.cabin(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ))),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 5),
            Text(
              "Hooodies!",
              style: GoogleFonts.lobster(fontSize: 50, color: Colors.green),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.cabin(
                    fontSize: 25,
                    fontWeight: FontWeight.normal,
                    color: Colors.black, // Add color if necessary
                  ),
                  children: [
                    TextSpan(text: 'Thank you for your order!\n'),
                    TextSpan(text: 'Your order number is: '),
                    TextSpan(
                      text: '$orderId\n',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text:
                            'A confirmation email has been sent to your account.'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(8.0, 50.0),
                ),
                child: Text(
                  'OK',
                  style: GoogleFonts.cabin(fontSize: 27.5, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).push(PageTransition(
                    type: PageTransitionType.fade,
                    child: OwnBar.CustomBottomNavigationBar(
                        page: OwnBar.Page.HOME),
                  ));
                }),
          ],
        ),
      ),
    );
  }
}
