import 'package:android_studio_projects/menu/custom-bottom-navigation-bar.dart';
import 'package:android_studio_projects/settings/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../components/contacts.dart';
import '../components/map.dart';
import '../profile/profile.dart';
import '../provider/theme-changer.provider.dart';
import '../menu/custom-bottom-navigation-bar.dart' as OwnBar;

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Drawer(
      backgroundColor: themeChanger.themeMode == ThemeMode.dark
          ? Colors.grey.shade900
          : Colors.white,
      width: 220,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: const Divider(
                color: Colors.black,
                thickness: 2.0,
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
    String? _uid = FirebaseAuth.instance.currentUser?.uid;
    return Container(
      // color: Colors.red.shade700,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 3.0,
                )),
            child: (user.photoURL != null)
                ? CircleAvatar(
                    radius: 50.0, backgroundImage: NetworkImage(user.photoURL!))
                : CircleAvatar(
                    radius: 50.0,
                    backgroundImage:
                        AssetImage('assets/img/default_profile.png')),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 7.5),
          ),
          Text(
            textAlign: TextAlign.center,
            "Bolemányi Ákos",
            style:
                GoogleFonts.lobster(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            textAlign: TextAlign.center,
            "bolemanyi.akos@gmail.com",
            style: GoogleFonts.cabin(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.only(top: 24, bottom: 24, right: 24, left: 10),
      child: Wrap(
        runSpacing: 10,
        children: [
          ListTile(
              leading: const Icon(Icons.home),
              title: LocaleText(
                'menu_home',
                style: GoogleFonts.cabin(fontSize: 15),
              ),
              onTap: () =>
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        CustomBottomNavigationBar(page: OwnBar.Page.HOME),
                  ))),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: LocaleText(
              'menu_products',
              style: GoogleFonts.cabin(fontSize: 15),
            ),
            onTap: () {
              // Előző navigator drawer bezárása
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    CustomBottomNavigationBar(page: OwnBar.Page.PRODUCTS),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: Text(
              'Favourites',
              style: GoogleFonts.cabin(fontSize: 15),
            ),
            onTap: () {
              // Előző navigator drawer bezárása
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    CustomBottomNavigationBar(page: OwnBar.Page.FAVOURITES),
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
              // Előző navigator drawer bezárása
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) =>
                    CustomBottomNavigationBar(page: OwnBar.Page.CART),
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.map_sharp),
            title: LocaleText(
              'menu_map',
              style: GoogleFonts.cabin(fontSize: 15),
            ),
            onTap: () {
              // Előző navigator drawer bezárása
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const MapPage(), //const HiddenDrawer(),
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
              // Előző navigator drawer bezárása
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ContactPage(),
              ));
            },
          ),
          Container(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: const Divider(
              color: Colors.black,
              thickness: 2.0,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: LocaleText(
              'menu_settings',
              style: GoogleFonts.cabin(fontSize: 15),
            ),
            onTap: () {
              // Előző navigator drawer bezárása
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SettingsPage(),
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
              // Előző navigator drawer bezárása
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ));
            },
          )
        ],
      ));
}
