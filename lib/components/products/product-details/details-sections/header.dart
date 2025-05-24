import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../models/product.model.dart';
import '../../../../providers/theme.provider.dart';
import '../../../../services/currency.service.dart';

/**
 * In this header widget, the price and image of the product is displayed.
 */

class ProductHeader extends StatelessWidget {
  const ProductHeader({super.key, required this.product});
  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final nation = Locales.currentLocale(context)?.languageCode;
    final currencyService = CurrencyService.instance;
    final currency = currencyService.getCurrency(nation);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            product.name,
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
                        text: '${Locales.string(context, 'price')}\n',
                        style: GoogleFonts.cabin(
                          fontSize: 17.5,
                          color: themeProvider.themeMode == ThemeMode.dark
                              ? Colors.white
                              : Colors.black,
                        )),
                    TextSpan(
                        text: currencyService.format(product.price, currency),
                        style: GoogleFonts.cabin(
                            fontSize: 25,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Hero(
                  tag: 1,
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    height: 300,
                    placeholder: (context, url) => Center(
                      child: SpinKitDualRing(
                        color: Colors.red,
                        size: 40.0,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
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
