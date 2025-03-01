import 'package:android_studio_projects/settings/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/cart.dart';
import '../components/contacts.dart';
import '../components/map.dart';
import '../components/favourites.dart';
import '../components/main.dart';
import '../components/products.dart';
import '../profile/profile.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        width: 220,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );
  Widget buildHeader(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    String? _uid = FirebaseAuth.instance.currentUser?.uid;
    return Container(
      color: Colors.grey.shade800,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 15),
          (user.photoURL != null)
              ? CircleAvatar(
                  radius: 70.0, backgroundImage: NetworkImage(user.photoURL!))
              : CircleAvatar(
                  radius: 70.0,
                  backgroundImage:
                      AssetImage('assets/img/default_profile.png')),

          // Text(
          //   "Hooodies!",
          //   style: GoogleFonts.lobster(
          //       fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold),
          // )
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
                    builder: (context) => const HomePage(),
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
                builder: (context) => ProductsPage(),
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
                builder: (context) => FavouritesPage(),
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
                builder: (context) => const CartPage(),
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
          const Divider(color: Colors.black54),
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
