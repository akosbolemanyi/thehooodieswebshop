import 'package:android_studio_projects/provider/theme-changer.provider.dart';
import 'package:flutter/material.dart';
import '../menu/custom-bottom-navigation-bar.dart' as OwnBar;
import 'package:badges/badges.dart' as badges;
import '../menu/custom-bottom-navigation-bar.dart';
import '../model/product.model.dart';
import '../constants.dart';
import '../provider/cart.provider.dart';
import 'add-quantity_favourite-button.dart';
import 'add-to-cart.dart';
import 'available-sizes.dart';
import 'description.dart';
import 'package:provider/provider.dart';

import 'header.dart';

class HoodieDetailsPage extends StatefulWidget {
  final HoodieItemTile hoodie;

  const HoodieDetailsPage({super.key, required this.hoodie});

  @override
  _HoodieDetailsPageState createState() => _HoodieDetailsPageState();
}

class _HoodieDetailsPageState extends State<HoodieDetailsPage> {
  String selectedSize = "M";
  int selectedQuantity = 1; // Mennyiség változó
  int stockQuantity = 0;

  void updateQuantity(int quantity) {
    setState(() {
      selectedQuantity = quantity;
    });
  }

  void updateStockQuantity(int quantity) {
    setState(() {
      stockQuantity = quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final cartModel = Provider.of<CartModel>(context);
    final themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      backgroundColor: themeChanger.themeMode == ThemeMode.dark
          ? Colors.grey.shade800
          : Colors.grey.shade400,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: themeChanger.themeMode == ThemeMode.dark
            ? Colors.grey.shade800
            : Colors.grey.shade400,
        elevation: 0,
        actions: <Widget>[
          badges.Badge(
            position: badges.BadgePosition.topEnd(top: -5, end: -6),
            showBadge: cartModel.cartItems.isNotEmpty,
            badgeStyle: badges.BadgeStyle(
              badgeColor: Colors.white,
              shape: badges.BadgeShape.circle,
              borderRadius: BorderRadius.circular(10),
            ),
            badgeContent: Text(cartModel.totalQuantity.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              iconSize: 25,
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CustomBottomNavigationBar(page: OwnBar.Page.CART)),
                );
              },
            ),
          ),
          SizedBox(width: kDefaultPaddin / 2),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.3),
                    padding: EdgeInsets.only(
                      top: size.height * 0.12,
                      left: kDefaultPaddin,
                      right: kDefaultPaddin,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        ColorAndSize(
                          hoodie: widget.hoodie,
                          onSizeChanged: (size) {
                            setState(() {
                              selectedSize = size;
                            });
                          },
                          onStockChanged: updateStockQuantity,
                        ),
                        const SizedBox(height: kDefaultPaddin / 2),
                        Description(hoodie: widget.hoodie),
                        const SizedBox(height: kDefaultPaddin / 2),
                        CounterWithFavBtn(
                            hoodie: widget.hoodie,
                            onQuantityChanged: updateQuantity),
                        const SizedBox(height: kDefaultPaddin / 2),
                        AddToCart(
                          hoodie: widget.hoodie,
                          selectedSize: selectedSize,
                          quantity: selectedQuantity, // Átadja a mennyiséget
                          stockQuantity: stockQuantity,
                        ),
                      ],
                    ),
                  ),
                  ProductTitleWithImage(hoodie: widget.hoodie)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
