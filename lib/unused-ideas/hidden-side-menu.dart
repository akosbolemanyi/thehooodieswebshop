import 'package:android_studio_projects/providers/theme.provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:provider/provider.dart';
import '../components/cart.dart';
import '../components/contacts.dart';
import '../components/favourites.dart';
import '../components/map.dart';
import '../components/products/products.dart';
import '../components/profile/profile.dart';
import '../components/settings/settings.dart';

/**
 * This implementation is another side-menu idea, but is the inferior one, hence it is not currently used.
 */

class HiddenSideMenu extends StatefulWidget {
  const HiddenSideMenu({Key? key}) : super(key: key);

  @override
  State<HiddenSideMenu> createState() => _HiddenSideMenuState();
}

class _HiddenSideMenuState extends State<HiddenSideMenu> {
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return HiddenDrawerMenu(
      backgroundColorMenu: themeProvider.themeMode == ThemeMode.dark
          ? Colors.black12
          : Colors.grey,
      screens: _pages,
      initPositionSelected: 0,
      slidePercent: 40,
      contentCornerRadius: 40,
    );
  }
}
