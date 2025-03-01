import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/theme-changer.provider.dart';

class CustomNavigationBar extends StatelessWidget {
  //final Function(int) onTap;
  //final int currentIndex;

  const CustomNavigationBar({
    Key? key,
    // required this.onTap,
    // required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);

    return CurvedNavigationBar(
      height: 50,
      backgroundColor: themeChanger.themeMode == ThemeMode.dark
          ? Colors.black
          : Colors.white,
      color: Colors.red.shade600,
      animationDuration: const Duration(milliseconds: 300),
      items: const [
        Icon(Icons.home, color: Colors.white),
        Icon(Icons.search, color: Colors.white),
        Icon(Icons.favorite, color: Colors.white),
        Icon(Icons.shopping_cart, color: Colors.white),
      ],
    );
  }
}
