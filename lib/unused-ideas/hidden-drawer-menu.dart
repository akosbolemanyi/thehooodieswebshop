import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:provider/provider.dart';
import '../components/cart.dart';
import '../components/contacts.dart';
import '../components/favourites.dart';
import '../components/map.dart';
import '../components/products.dart';
import '../components/profile.dart';
import '../provider/theme-changer.provider.dart';
import '../components/settings.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({Key? key}) : super(key: key);

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];

  final customTextStyle = GoogleFonts.cabin(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  @override
  void initState() {
    super.initState();

    _pages = [
      /*ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Home',
            baseStyle: customTextStyle,
            selectedStyle: TextStyle(),
            colorLineSelected: Colors.red),
        HomePage(),
      ),*/
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Products',
          baseStyle: TextStyle(),
          selectedStyle: TextStyle(),
        ),
        ProductsPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Favourites',
          baseStyle: TextStyle(),
          selectedStyle: TextStyle(),
        ),
        FavouritesPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Cart',
          baseStyle: TextStyle(),
          selectedStyle: TextStyle(),
        ),
        CartPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Map',
          baseStyle: TextStyle(),
          selectedStyle: TextStyle(),
        ),
        MapPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Contacts',
          baseStyle: TextStyle(),
          selectedStyle: TextStyle(),
        ),
        ContactPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Settings',
          baseStyle: TextStyle(),
          selectedStyle: TextStyle(),
        ),
        SettingsPage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Profile',
          baseStyle: TextStyle(),
          selectedStyle: TextStyle(),
        ),
        ProfilePage(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return HiddenDrawerMenu(
      backgroundColorMenu: themeChanger.themeMode == ThemeMode.dark
          ? Colors.black12
          : Colors.grey,
      screens: _pages,
      initPositionSelected: 0,
      slidePercent: 40,
      contentCornerRadius: 40,
    );
  }
}
