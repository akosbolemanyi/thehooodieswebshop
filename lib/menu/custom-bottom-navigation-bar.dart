import 'package:android_studio_projects/components/favourites.dart';
import 'package:android_studio_projects/components/products.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../components/cart.dart';
import '../components/main.dart';

enum Page { HOME, PRODUCTS, FAVOURITES, CART }

class CustomBottomNavigationBar extends StatefulWidget {
  final Page page;

  CustomBottomNavigationBar({
    Key? key,
    this.page = Page.HOME,
  }) : super(key: key) {}

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late int currentIndex;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

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
    HomePage(),
    ProductsPage(),
    FavouritesPage(),
    CartPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
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
          // Navigator.pop(context);
          currentIndex = index;
        }),
      ),
    );
  }
}
