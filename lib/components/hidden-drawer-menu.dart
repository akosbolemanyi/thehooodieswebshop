import 'package:android_studio_projects/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:provider/provider.dart';
import '../SAVE-products.dart';
import '../providers/theme_changer_provider.dart';

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
      ScreenHiddenDrawer(
        ItemHiddenMenu(
            name: 'Home',
            baseStyle: customTextStyle,
            selectedStyle: TextStyle(),
            colorLineSelected: Colors.red),
        HomePage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Products',
          baseStyle: TextStyle(),
          selectedStyle: TextStyle(),
        ),
        ProductsPage(),
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
