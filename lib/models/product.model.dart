import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/favourites.provider.dart';
import '../providers/theme.provider.dart';
import '../services/currency.service.dart';

/**
 * This is the extended model of the products - to manipulate the displaying of them as well.
 */

class ProductModel extends StatefulWidget {
  final String id;
  final String name;
  final String material;
  final String price;
  final String colour;
  final String imageUrl;
  final double imageHeight;
  final double textSize;
  final double buttonFontSize;
  final int crossAxisCount;
  final void Function()? onPressed;
  final void Function()? onTap;

  const ProductModel({
    super.key,
    required this.id,
    required this.name,
    required this.material,
    required this.price,
    required this.colour,
    required this.imageUrl,
    required this.imageHeight,
    required this.textSize,
    required this.buttonFontSize,
    required this.crossAxisCount,
    required this.onPressed,
    required this.onTap,
  });

  @override
  _ProductModelState createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  @override
  Widget build(BuildContext context) {
    final favouritesProvider = FavouritesProvider.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final nation = Locales.currentLocale(context)?.languageCode;
    final currencyService = CurrencyService.instance;
    final currency = currencyService.getCurrency(nation);

    return Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: GestureDetector(
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
                    widget.name,
                    style: GoogleFonts.lobster(
                      fontSize: widget.textSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Flexible(
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      height: widget.imageHeight,
                      placeholder: (context, url) => Center(
                        child: SpinKitDualRing(
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  Text(
                    currencyService.format(widget.price, currency),
                    style: GoogleFonts.cabin(
                      fontWeight: FontWeight.bold,
                      fontSize: widget.buttonFontSize,
                    ),
                  ),
                  widget.crossAxisCount == 1
                      ? Container(
                          padding: EdgeInsets.only(left: 125.0, right: 125.0),
                          child: Divider(
                            thickness: 2.0,
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
            Positioned(
              top: widget.crossAxisCount == 2 ? 50 : 75,
              right: widget.crossAxisCount == 2 ? 15 : 30,
              child: GestureDetector(
                onTap: () {
                  favouritesProvider.toggleFavourite(widget);
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
      ),
    );
  }
}
