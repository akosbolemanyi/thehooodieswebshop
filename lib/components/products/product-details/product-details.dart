import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../menus/custom-bottom-menu.dart' as Footer;
import 'package:badges/badges.dart' as badges;
import '../../../models/product.model.dart';
import '../../../providers/cart.provider.dart';
import '../../../providers/theme.provider.dart';
import 'package:provider/provider.dart';
import 'details-sections/cart-adder.dart';
import 'details-sections/delivery-and-favourite.dart';
import 'details-sections/description.dart';
import 'details-sections/header.dart';
import 'details-sections/size-selector.dart';

class ProductDetailsPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  String selectedSize = "M";
  int selectedQuantity = 1;
  int inStock = 0;

  void updateQuantity(int quantity) {
    setState(() {
      selectedQuantity = quantity;
    });
  }

  void updateStockQuantity(int quantity) {
    setState(() {
      inStock = quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final cartProvider = Provider.of<CartProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.themeMode == ThemeMode.dark
          ? Colors.grey.shade800
          : Colors.grey.shade400,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: themeProvider.themeMode == ThemeMode.dark
            ? Colors.grey.shade800
            : Colors.grey.shade400,
        elevation: 0,
        actions: <Widget>[
          badges.Badge(
            position: badges.BadgePosition.topEnd(top: -5, end: -6),
            showBadge: cartProvider.cartItems.isNotEmpty,
            badgeStyle: badges.BadgeStyle(
              badgeColor: Colors.white,
              shape: badges.BadgeShape.circle,
              borderRadius: BorderRadius.circular(10),
            ),
            badgeContent: Text(cartProvider.totalQuantity.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              iconSize: 25,
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Footer.CustomBottomMenu(page: Footer.Page.CART)),
                );
              },
            ),
          ),
          SizedBox(width: 20.0 / 2),
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
                      left: 20.0,
                      right: 20.0,
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
                        ProductSizeSelector(
                          product: widget.product,
                          onSizeChanged: (size) {
                            setState(() {
                              selectedSize = size;
                            });
                          },
                          onStockChanged: updateStockQuantity,
                        ),
                        const SizedBox(height: 20.0 / 2),
                        ProductDescription(product: widget.product),
                        const SizedBox(height: 20.0 / 2),
                        ProductQuantityAndFavourite(
                            product: widget.product,
                            onQuantityChanged: updateQuantity),
                        const SizedBox(height: 20.0 / 2),
                        ProductCartAdder(
                          product: widget.product,
                          selectedSize: selectedSize,
                          quantity: selectedQuantity,
                          stockQuantity: inStock,
                        ),
                      ],
                    ),
                  ),
                  ProductHeader(product: widget.product)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
