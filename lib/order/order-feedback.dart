import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../menus/custom-side-menu.dart' as Sidebar;
import '../menus/custom-bottom-menu.dart' as Footer;
import '../providers/theme.provider.dart';
import '../utils/utils.dart';

class OrderFeedbackPage extends StatelessWidget {
  final String orderId;
  const OrderFeedbackPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      drawer: Sidebar.CustomSideMenu(),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 10),
          child: Container(
              color: Colors.green,
              padding: EdgeInsets.only(top: 10),
              child: AppBar(
                backgroundColor: Colors.green,
                iconTheme: IconThemeData(color: Colors.black),
                title: LocaleText(
                  'successful_order',
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
              child: Column(
                children: [
                  Text(
                    Locales.string(context, 'thank_you_order'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cabin(
                      fontSize: 25,
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    Locales.string(context, 'order_number_is'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cabin(
                      fontSize: 22,
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            orderId,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cabin(
                              fontSize: 22,
                              color: themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.copy, color: Colors.grey[600]),
                          tooltip: Locales.string(context, 'copy_order_id'),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: orderId));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(Locales.string(context, 'order_email_sent'),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cabin(
                          fontSize: 20,
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black)),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(8.0, 50.0),
                ),
                child: LocaleText(
                  'ok',
                  style: GoogleFonts.cabin(fontSize: 27.5, color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).push(PageTransition(
                    type: PageTransitionType.fade,
                    child: Footer.CustomBottomMenu(page: Footer.Page.HOME),
                  ));
                }),
          ],
        ),
      ),
    );
  }
}
