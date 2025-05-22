import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../models/product.model.dart';
import '../../../../providers/favourites.provider.dart';
import '../../../../providers/theme.provider.dart';
import 'quantity-selector.dart';

/**
 * In this widget section, the quantity of the products can be selected, as well it can be marked as favourite.
 */

class ProductQuantityAndFavourite extends StatefulWidget {
  final Function(int) onQuantityChanged;
  final ProductModel product;

  const ProductQuantityAndFavourite(
      {super.key, required this.product, required this.onQuantityChanged});

  @override
  State<ProductQuantityAndFavourite> createState() => _CounterWithFavBtnState();
}

class _CounterWithFavBtnState extends State<ProductQuantityAndFavourite> {
  int quantity = 1;

  void updateQuantity(int newQuantity) {
    setState(() {
      quantity = newQuantity;
    });
    widget.onQuantityChanged(newQuantity);
  }

  @override
  Widget build(BuildContext context) {
    final favouritesProvider = FavouritesProvider.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ProductQuantitySelector(onQuantityChanged: updateQuantity),
        LocaleText(
          'delivery_days',
          style: GoogleFonts.aleo(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          onTap: () {
            favouritesProvider.toggleFavourite(widget.product);
          },
          child: Icon(
            favouritesProvider.isExist(widget.product)
                ? Icons.favorite
                : Icons.favorite_border,
            color: favouritesProvider.isExist(widget.product)
                ? Colors.red
                : (themeProvider.themeMode == ThemeMode.dark
                    ? Colors.white54
                    : Colors.black),
            size: 35,
          ),
        ),
      ],
    );
  }
}
