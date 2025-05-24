import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../abstract-classes/page-content.dart';
import '../menus/custom-bottom-menu.dart' as Footer;
import '../menus/custom-side-menu.dart' as Sidebar;
import '../providers/theme-colour.provider.dart';
import '../providers/theme.provider.dart';
import '../utils/utils.dart';

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
        preferredSize: Size.fromHeight(kToolbarHeight + 10),
        child: Container(
            color: Colors.red,
            padding: EdgeInsets.only(top: 10),
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
    return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Image.asset('assets/images/main.png'),
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
              LocaleText('about_us',
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
                      LocaleText('our_purpose',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lobster(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 35)),
                      LocaleText(
                        'our_purpose_description',
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
                      LocaleText('how_it_started',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lobster(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 35)),
                      LocaleText(
                        'how_it_started_description',
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
                      LocaleText('our_materials',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lobster(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 35)),
                      LocaleText(
                        'our_materials_description',
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
                      LocaleText('work_with_us',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.lobster(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 35)),
                      LocaleText(
                        'work_with_us_description',
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
