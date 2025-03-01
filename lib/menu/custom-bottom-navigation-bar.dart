import 'package:android_studio_projects/components/favourites.dart';
import 'package:android_studio_projects/components/products.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../components/cart.dart';
import '../components/main.dart';

// TODO - Handle state changes, and with that: wait for animation, mark current page.
class CustomNavigationBar extends StatefulWidget {
  CustomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
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
      onTap: (index) {
        if (_page != index) {
          setState(() {
            _page = index;
          });
          final CurvedNavigationBarState? navBarState =
              _bottomNavigationKey.currentState;
          navBarState?.setPage(index);
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProductsPage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavouritesPage()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
              break;
          }
        }
      },
    );
  }
}
