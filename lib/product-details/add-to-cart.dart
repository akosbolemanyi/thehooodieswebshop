import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../constants.dart';
import '../components/cart.dart';
import '../model/product.model.dart';
import '../utils/utils.dart';
import '../provider/cart.provider.dart';

class AddToCart extends StatelessWidget {
  const AddToCart({
    super.key,
    required this.hoodie,
    required this.selectedSize,
    required this.quantity,
    required this.stockQuantity,
  });

  final HoodieItemTile hoodie;
  final String selectedSize;
  final int quantity;
  final int stockQuantity;

  @override
  Widget build(BuildContext context) {
    final cartModel = Provider.of<CartModel>(context, listen: false);
    // Ellenőrizd, hogy a kosárban hány darab van már a termékből
    int cartQuantity = 0;
    var existingItem = cartModel.cartItems.firstWhere(
      (item) => item['id'] == hoodie.itemName && item['size'] == selectedSize,
      orElse: () => {},
    );

    if (existingItem.isNotEmpty) {
      cartQuantity = existingItem['quantity'] ?? 0;
    }

    // Frissített logika a mennyiség ellenőrzésére
    int availableQuantity = stockQuantity -
        cartQuantity; // A raktáron lévő mennyiség - ami már a kosárban van

    bool isOutOfStock = availableQuantity <= 0 || quantity > availableQuantity;

    void showOutOfStockMessage() {
      Utils.showSnackBar(
          "A termék nincs raktáron vagy túl sokat választottál!");
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: kDefaultPaddin),
            height: 50,
            width: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: hoodie.color,
              ),
            ),
            child: IconButton(
              icon: SvgPicture.asset(
                "assets/icons/add_to_cart.svg",
                colorFilter: ColorFilter.mode(hoodie.color, BlendMode.srcIn),
              ),
              onPressed: isOutOfStock
                  ? showOutOfStockMessage
                  : () async {
                      int index = cartModel.shopItems
                          .indexWhere((item) => item['id'] == hoodie.itemName);
                      if (index != -1) {
                        cartModel.addItem(index, selectedSize, quantity);
                        await Flushbar(
                          mainButton: TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CartPage()),
                            ),
                            child: Text(
                              'Click me',
                              style: GoogleFonts.cabin(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.085,
                            bottom: 10,
                            left: 10,
                            right: 10,
                          ),
                          showProgressIndicator: false,
                          flushbarPosition: FlushbarPosition.TOP,
                          isDismissible: true,
                          backgroundColor: Colors.white.withOpacity(0.9),
                          messageSize: 12,
                          icon: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          barBlur: 8.0,
                          titleColor: Colors.black,
                          messageColor: Colors.black,
                          title: 'Added to cart!',
                          message: "${hoodie.itemName} x$quantity",
                          duration: Duration(seconds: 3),
                        ).show(context);
                      }
                    },
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: isOutOfStock
                  ? showOutOfStockMessage
                  : () async {
                      int index = cartModel.shopItems
                          .indexWhere((item) => item['id'] == hoodie.itemName);
                      if (index != -1) {
                        cartModel.addItem(index, selectedSize, quantity);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CartPage()),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                backgroundColor: hoodie.color,
              ),
              child: Text(
                "Buy Now".toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
