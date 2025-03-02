import 'package:android_studio_projects/components/products.dart';
import 'package:android_studio_projects/provider/theme.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../menu/custom-bottom-navigation-bar.dart' as OwnBar;
import '../menu/custom-drawer.dart' as sidebar;

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Hooodies!',
          style: GoogleFonts.lobster(
              fontWeight: FontWeight.bold, fontSize: 40, color: Colors.black),
        ),
        centerTitle: true,
      ),
      drawer: sidebar.NavigationDrawer(),
      body: AnimatedContainer(
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
                  setState(() {
                    provider.toggleTTL();
                  });
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
                      // boxShadow: [
                      //   // Sötét jobb-alsó rész
                      //   BoxShadow(
                      //     color: Colors.grey.shade500,
                      //     offset: const Offset(6, 6),
                      //     blurRadius: 15,
                      //     spreadRadius: 1,
                      //   ),
                      //   // Világos bal-felső rész
                      //   const BoxShadow(
                      //     color: Colors.white,
                      //     offset: Offset(-6, -6),
                      //     blurRadius: 15,
                      //     spreadRadius: 1,
                      //   )
                      // ]
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
            // Padding(
            //     padding: EdgeInsets.only(top: 5.0),
            //     child: Text("Rólunk", textAlign: TextAlign.center),
            // ),
            // Padding(
            //     padding: EdgeInsets.all(8.0),
            //     child: Icon(Icons.arrow_downward_rounded),
            // )
          ],
        ),
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(left: 30.0),
      //   child: Row(
      //     crossAxisAlignment: CrossAxisAlignment.end,
      //     children: [
      //       FloatingActionButton(
      //         heroTag: "btn1",
      //         backgroundColor: Colors.indigo.shade200,
      //         onPressed: () {
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (_) => const SettingScreen()));
      //         },
      //         child: const Icon(
      //           Icons.language_rounded,
      //         ),
      //       ),
      //       Expanded(child: Container()),
      //       FloatingActionButton(
      //         heroTag: "btn2",
      //         backgroundColor: Colors.indigo.shade200,
      //         onPressed: () => {}, //provider.toggleBGC(),
      //         child: const Icon(
      //           Icons.lightbulb_outline,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
