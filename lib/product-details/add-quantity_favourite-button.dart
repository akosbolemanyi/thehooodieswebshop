import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/product.model.dart';
import '../provider/favourites.provider.dart';
import 'cart-quantity-counter.dart';

class CounterWithFavBtn extends StatefulWidget {
  final Function(int) onQuantityChanged; // Callback a mennyiséghez
  final HoodieItemTile hoodie;

  const CounterWithFavBtn(
      {super.key, required this.hoodie, required this.onQuantityChanged});

  @override
  State<CounterWithFavBtn> createState() => _CounterWithFavBtnState();
}

class _CounterWithFavBtnState extends State<CounterWithFavBtn> {
  int quantity = 1;

  void updateQuantity(int newQuantity) {
    setState(() {
      quantity = newQuantity;
    });
    widget.onQuantityChanged(newQuantity);
  }

  @override
  Widget build(BuildContext context) {
    final favouritesProvider = FavouriteProvider.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CartCounter(onQuantityChanged: updateQuantity),
        Text(
          'Darrow',
          style: GoogleFonts.lobster(
            fontSize: 25,
            fontWeight: FontWeight.w400,
          ),
        ),
        GestureDetector(
          onTap: () {
            favouritesProvider.toggleFavourite(
                widget.hoodie); // A kedvenc hozzáadása/eltávolítása
          },
          child: Icon(
            favouritesProvider.isExist(widget.hoodie)
                ? Icons.favorite
                : Icons.favorite_border,
            color: favouritesProvider.isExist(widget.hoodie)
                ? Colors.red
                : Colors.black,
            size: 28,
          ),
        ),
      ],
    );
  }
}
