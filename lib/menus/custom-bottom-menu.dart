import 'package:android_studio_projects/components/favourites.dart';
import 'package:android_studio_projects/components/products/products.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../components/cart.dart';
import '../components/home.dart';

/**
 * This file implements the bottom navigation menu, that will only be seen on the pages administrated in the Page enum
 * with those pages included in it for navigation.
 */

enum Page { HOME, PRODUCTS, FAVOURITES, CART }

class CustomBottomMenu extends StatefulWidget {
  final Page page;

  CustomBottomMenu({
    Key? key,
    this.page = Page.HOME,
  }) : super(key: key) {}

  @override
  CustomBottomNavigationBarState createState() =>
      CustomBottomNavigationBarState();
}

class CustomBottomNavigationBarState extends State<CustomBottomMenu> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    switch (widget.page) {
      case Page.PRODUCTS:
        this.currentIndex = 1;
        break;
      case Page.FAVOURITES:
        this.currentIndex = 2;
        break;
      case Page.CART:
        this.currentIndex = 3;
        break;
      default:
        this.currentIndex = 0;
    }
  }

  final screens = [
    new HomePage(),
    new ProductsPage(),
    new FavouritesPage(),
    new CartPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        color: Colors.red.shade600,
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.search, color: Colors.white),
          Icon(Icons.favorite, color: Colors.white),
          Icon(Icons.shopping_cart, color: Colors.white),
        ],
        index: currentIndex,
        onTap: (index) => setState(() {
          currentIndex = index;
        }),
      ),
    );
  }
}
