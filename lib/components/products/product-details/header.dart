import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../../../models/product.model.dart';
import '../../../providers/theme.provider.dart';

/**
 * In this header widget, the price and image of the product is displayed.
 */

class ProductHeader extends StatelessWidget {
  const ProductHeader({super.key, required this.product});

  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            product.itemName, // hoodie.itemName,
            style: GoogleFonts.lobster(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Price\n",
                        style: GoogleFonts.cabin(
                          fontSize: 17.5,
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                        )),
                    TextSpan(
                        text: "\$${product.itemPrice}",
                        style: GoogleFonts.cabin(
                            fontSize: 25,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(width: kDefaultPaddin),
              Expanded(
                child: Hero(
                  tag: 1,
                  child: Image.network(
                    product.imagePath,
                    height: 300,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
