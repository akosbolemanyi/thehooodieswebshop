import 'package:android_studio_projects/provider/theme-changer.provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../model/product.model.dart';

class ProductTitleWithImage extends StatelessWidget {
  const ProductTitleWithImage({super.key, required this.hoodie});

  final HoodieItemTile hoodie;
  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            hoodie.itemName, // hoodie.itemName,
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
                          color: themeChanger.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                        )),
                    TextSpan(
                        text: "\$${hoodie.itemPrice}",
                        style: GoogleFonts.cabin(
                            fontSize: 25,
                            color: themeChanger.themeMode == ThemeMode.dark
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
                    hoodie.imagePath,
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
