import 'package:android_studio_projects/providers/favourites.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';

class OldHoodieItemTile extends StatefulWidget {
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

  const OldHoodieItemTile({
    super.key,
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
  _HoodieItemTileState createState() => _HoodieItemTileState();
}

class _HoodieItemTileState extends State<OldHoodieItemTile> {

  @override
  Widget build(BuildContext context) {
    final nation = Locales.currentLocale(context)?.languageCode;
    final favourite = FavouriteProvider.of(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
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
                Image.asset(
                  widget.imagePath,
                  height: widget.imageHeight,
                ),
                MaterialButton(
                  onPressed: widget.onPressed,
                  color: Colors.grey[800],
                  child: Text(
                    nation == 'hu'
                        ? '${widget.itemPrice} Ft'
                        : nation == 'en'
                        ? '\$${widget.itemPrice}'
                        : '\€ ${widget.itemPrice}',
                    style: GoogleFonts.cabin(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: widget.buttonFontSize,
                    ),
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
          Positioned(
            top: 30,
            right: 30,
            child: GestureDetector(
              onTap: () {
                // favourite.toggleFavourite(widget);
              },
              //child: Icon(
              //  favourite.isExist(widget) ? Icons.favorite : Icons.favorite_border,
              //  color: favourite.isExist(widget) ? Colors.red : Colors.black,
              //  size: 28,
              //),
            ),
          ),
        ],
      ),
    );
  }
}
