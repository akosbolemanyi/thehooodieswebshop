import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../abstract-classes/page-content.dart';
import '../menus/custom-bottom-menu.dart' as Footer;
import '../menus/custom-side-menu.dart' as Sidebar;
import '../providers/cart.provider.dart';
import '../providers/theme-colour.provider.dart';
import '../providers/theme.provider.dart';

class HomePage extends StatefulWidget implements PageContent {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) {
    return _HomePageState().buildAppBar(context);
  }

  @override
  Widget buildBody(BuildContext context) {
    return _HomePageState().buildBody(context);
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar.CustomSideMenu(),
      appBar: widget.buildAppBar(context),
      body: buildBody(context),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 15),
        child: Container(
            color: Colors.red,
            padding: EdgeInsets.only(top: 15),
            child: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              title: Text(
                'Hooodies!',
                style: GoogleFonts.lobster(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.black),
              ),
              centerTitle: true,
            )));
  }

  Widget buildBody(BuildContext context) {
    final themeColourProvider = Provider.of<ThemeColourProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context).orderItems;
    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Image.asset('assets/img/main.png'),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: TextButton(
              onPressed: () {
                themeColourProvider.toggleTTL();
              },
              child: AnimatedDefaultTextStyle(
                style: GoogleFonts.cabin(
                    fontSize: 40,
                    color: themeColourProvider.myTitleColor,
                    fontWeight: FontWeight.bold),
                duration: const Duration(milliseconds: 200),
                child: const LocaleText(
                  'home_title',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          LocaleText(
            'made_in_szeged',
            textAlign: TextAlign.center,
            style: TextStyle(
                // color: provider.myTextColor,
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      Footer.CustomBottomMenu(page: Footer.Page.PRODUCTS),
                ),
              ),
              child: Align(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: LocaleText(
                    'shop_now',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lobster(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 30),
            child: Icon(size: 50, Icons.expand_more_sharp),
          ),
          Column(
            children: [
              Text('About us',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.lobster(
                      fontWeight: FontWeight.bold, fontSize: 35)),
              Container(
                padding: EdgeInsets.only(left: 100.0, right: 100.0),
                child: Divider(
                  color: themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                  thickness: 1.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 30.0, left: 12.5, right: 12.5, bottom: 20),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.grey.shade500
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 15,
                      right: 10,
                      left: 10,
                    ),
                    child: Column(children: [
                      Text('Our purpose',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lobster(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 35)),
                      Text(
                        'Our dream is not only to give style but comfort for those who seek the power of the '
                        'hoodies. Our concept relies on one simple rule: quality over quantity. '
                        'You have seen all the colors, felt all the kinds of materials. What we give you is simple. '
                        'The simplest yet most desired design: our hooodies.',
                        style: GoogleFonts.cabin(
                            color: Colors.black,
                            fontSize: 15,
                            fontStyle: FontStyle.italic),
                      ),
                    ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 12.5, right: 12.5, bottom: 20),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.grey.shade500
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 15,
                      right: 10,
                      left: 10,
                    ),
                    child: Column(children: [
                      Text('How it started',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lobster(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 35)),
                      Text(
                        'We have always wanted to give quality products to people, to make a trend, to give style. '
                        'We started out as a little group - a handful of friends - who wanted to make a difference. '
                        'We collected the best clothing materials we have always wanted, and started to make our dreams come true. '
                        'It was a love project. '
                        'With this passion, we decided to give this, and other ideas to the world, to YOU!',
                        style: GoogleFonts.cabin(
                            color: Colors.black,
                            fontSize: 15,
                            fontStyle: FontStyle.italic),
                      ),
                    ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 12.5, right: 12.5, bottom: 20),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.grey.shade500
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 15,
                      right: 10,
                      left: 10,
                    ),
                    child: Column(children: [
                      Text('Our materials',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lobster(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 35)),
                      Text(
                        'The quality is the single most significant component of the perfect hoodie. '
                        'We do not believe in giving this task of manufacturing to other companies. '
                        'We wanted to create ourselves, and we finally can. We hope, you feel it too.',
                        style: GoogleFonts.cabin(
                            color: Colors.black,
                            fontSize: 15,
                            fontStyle: FontStyle.italic),
                      ),
                    ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, left: 12.5, right: 12.5, bottom: 20),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: themeProvider.themeMode == ThemeMode.dark
                          ? Colors.grey.shade500
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: 15,
                      right: 10,
                      left: 10,
                    ),
                    child: Column(children: [
                      Text('Work with us!',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lobster(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 35)),
                      Text(
                        'We are continuously expanding. We would like to share our joy and passion with you!'
                        'We have our first shop in Szeged, and we would like to expand. Either on phone, email or in person, feel free'
                        ' to contact us! We would be honoured, if you would join us!',
                        style: GoogleFonts.cabin(
                            color: Colors.black,
                            fontSize: 15,
                            fontStyle: FontStyle.italic),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ]));
  }
}
