import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/favourites.provider.dart';
import '../providers/theme.provider.dart';

/**
 * This is the extended model of the products - to manipulate the displaying of them as well.
 */

class ProductModel extends StatefulWidget {
  final String id;
  final String itemName;
  final String itemPrice;
  final String imagePath;
  final Color color;
  final void Function()? onPressed;
  final void Function()? onTap;
  final double imageHeight;
  final double textSize;
  final double buttonFontSize;
  final int crossAxisCount;

  const ProductModel({
    super.key,
    required this.id,
    required this.itemName,
    required this.itemPrice,
    required this.imagePath,
    required this.color,
    required this.onPressed,
    required this.onTap,
    required this.imageHeight,
    required this.textSize,
    required this.buttonFontSize,
    required this.crossAxisCount,
  });

  @override
  _ProductModelState createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  @override
  Widget build(BuildContext context) {
    final nation = Locales.currentLocale(context)?.languageCode;
    final favouritesProvider = FavouritesProvider.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  widget.itemName,
                  style: GoogleFonts.lobster(
                    fontSize: widget.textSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // TODO - Research cached network images!
                Image.network(
                  widget.imagePath,
                  height: widget.imageHeight,
                ),
                // TODO - Redesign the price display. Think about what else to display, if needed.
                Text(
                  nation == 'hu'
                      ? '${widget.itemPrice} Ft'
                      : nation == 'en'
                          ? '\$${widget.itemPrice}'
                          : '\€ ${widget.itemPrice}',
                  style: GoogleFonts.cabin(
                    fontWeight: FontWeight.bold,
                    fontSize: widget.buttonFontSize,
                  ),
                ),
                widget.crossAxisCount == 1
                    ? Container(
                        padding: EdgeInsets.only(left: 50.0, right: 50.0),
                        child: Divider(
                          thickness: 2.0,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          // Kedvenc ikon, amely dinamikusan változik
          Positioned(
            top: widget.crossAxisCount == 2
                ? 45
                : 10, // Fix pozíció a jobb felső sarokban
            right: widget.crossAxisCount == 2 ? 30 : 30,
            child: GestureDetector(
              onTap: () {
                favouritesProvider.toggleFavourite(
                    widget); // A kedvenc hozzáadása/eltávolítása
              },
              child: Icon(
                favouritesProvider.isExist(widget)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: favouritesProvider.isExist(widget)
                    ? Colors.red
                    : (themeProvider.themeMode == ThemeMode.dark
                        ? Colors.white54
                        : Colors.black),
                size: widget.crossAxisCount == 2 ? 30 : 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
