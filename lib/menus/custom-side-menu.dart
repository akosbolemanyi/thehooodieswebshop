import 'package:android_studio_projects/components/settings/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../components/contacts.dart';
import '../components/map.dart';
import '../components/profile/profile.dart';
import '../providers/theme.provider.dart';
import 'custom-bottom-menu.dart' as Footer;

class CustomSideMenu extends StatefulWidget {
  const CustomSideMenu({super.key});

  @override
  CustomSideMenuState createState() => CustomSideMenuState();
}

class CustomSideMenuState extends State<CustomSideMenu> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Drawer(
      backgroundColor: themeProvider.themeMode == ThemeMode.dark
          ? Colors.grey.shade900
          : Colors.white,
      width: 220,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Divider(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
                thickness: 1.5,
              ),
            ),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Center(
              child: SpinKitDualRing(
                color: Colors.red,
                size: 40.0,
              ),
            ),
          );
        }
        final profile = snapshot.data!.data() as Map<String, dynamic>;
        final nation = Locales.currentLocale(context)?.languageCode;
        final name = nation == 'hu'
            ? '${profile['lastname']} ${profile['firstname']}'
            : '${profile['firstname']} ${profile['lastname']}';
        final email = profile['email'] ?? user.email;

        return Stack(alignment: Alignment.center, children: [
          Positioned(
            top: 44,
            left: 3,
            child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ),
          Container(
            padding: EdgeInsets.only(top: 60, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 3.0,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      )),
                  child: (user.photoURL != null)
                      ? CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(user.photoURL!))
                      : CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                              AssetImage('assets/images/default_profile.png')),
                ),
                SizedBox(height: 7.5),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lobster(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  email,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cabin(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ]);
      },
    );
  }

  Widget buildMenuItems(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
        padding:
            const EdgeInsets.only(top: 10, bottom: 24, right: 24, left: 10),
        child: Wrap(
          children: [
            ListTile(
                leading: const Icon(Icons.home),
                title: LocaleText(
                  'menu_home',
                  style: GoogleFonts.cabin(fontSize: 15),
                ),
                onTap: () => Navigator.of(context).push(PageTransition(
                      type: PageTransitionType.fade,
                      child: Footer.CustomBottomMenu(page: Footer.Page.HOME),
                    ))),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: LocaleText(
                'menu_products',
                style: GoogleFonts.cabin(fontSize: 15),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(PageTransition(
                  type: PageTransitionType.fade,
                  child: Footer.CustomBottomMenu(page: Footer.Page.PRODUCTS),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: LocaleText(
                'menu_favourites',
                style: GoogleFonts.cabin(fontSize: 15),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(PageTransition(
                  type: PageTransitionType.fade,
                  child: Footer.CustomBottomMenu(page: Footer.Page.FAVOURITES),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_basket),
              title: LocaleText(
                'menu_cart',
                style: GoogleFonts.cabin(fontSize: 15),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(PageTransition(
                  type: PageTransitionType.fade,
                  child: Footer.CustomBottomMenu(page: Footer.Page.CART),
                ));
              },
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Divider(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
                thickness: 1.0,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.map_sharp),
              title: LocaleText(
                'menu_map',
                style: GoogleFonts.cabin(fontSize: 15),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(PageTransition(
                  type: PageTransitionType.fade,
                  child: const MapPage(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: LocaleText(
                'menu_contact_us',
                style: GoogleFonts.cabin(fontSize: 15),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(PageTransition(
                  type: PageTransitionType.fade,
                  child: const ContactPage(),
                ));
              },
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Divider(
                color: themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.black,
                thickness: 1.0,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: LocaleText(
                'menu_settings',
                style: GoogleFonts.cabin(fontSize: 15),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(PageTransition(
                  type: PageTransitionType.fade,
                  child: SettingsPage(),
                ));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: LocaleText(
                'menu_profile',
                style: GoogleFonts.cabin(fontSize: 15),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(PageTransition(
                  type: PageTransitionType.fade,
                  child: ProfilePage(),
                ));
              },
            )
          ],
        ));
  }
}
