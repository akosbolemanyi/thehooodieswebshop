import 'package:android_studio_projects/components/products.dart';
import 'package:android_studio_projects/provider/theme.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../abstract-classes/page-contact.dart';
import '../menu/custom-bottom-navigation-bar.dart' as OwnBar;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (locale) => MaterialApp(
          title: 'Hooodies!',
          localizationsDelegates: Locales.delegates,
          supportedLocales: Locales.supportedLocales,
          locale: locale,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.orange,
            ),
          ),
          home: OwnBar.CustomBottomNavigationBar(page: OwnBar.Page.HOME)),
    );
  }
}

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
      appBar: widget.buildAppBar(context),
      body: buildBody(context),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      title: Text(
        'Hooodies!',
        style: GoogleFonts.lobster(
            fontWeight: FontWeight.bold, fontSize: 40, color: Colors.black),
      ),
      centerTitle: true,
    );
  }

  Widget buildBody(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Image.asset('assets/img/main.png'),
          ),
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: TextButton(
              onPressed: () {
                provider.toggleTTL();
              },
              child: AnimatedDefaultTextStyle(
                style: GoogleFonts.cabin(
                    fontSize: 40,
                    color: provider.myTitleColor,
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
                  builder: (context) => ProductsPage(),
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
        ],
      ),
    );
  }
}
