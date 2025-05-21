import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../constants.dart';
import '../../../../models/product.model.dart';
import '../../../../providers/cart.provider.dart';
import '../../../../utils/utils.dart';
import '../../../../menus/custom-bottom-menu.dart' as Footer;

class ProductCartAdder extends StatelessWidget {
  const ProductCartAdder({
    super.key,
    required this.product,
    required this.selectedSize,
    required this.quantity,
    required this.stockQuantity,
  });

  final ProductModel product;
  final String selectedSize;
  final int quantity;
  final int stockQuantity;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    int cartQuantity = 0;
    var existingItem = cartProvider.cartItems.firstWhere(
      (item) => item['id'] == product.name && item['size'] == selectedSize,
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
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 20.0),
            height: 50,
            width: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.green,
              ),
            ),
            child: IconButton(
              icon: Icon(Icons.add_shopping_cart_outlined, color: Colors.green),
              onPressed: isOutOfStock
                  ? showOutOfStockMessage
                  : () async {
                      int index = cartProvider.shopItems
                          .indexWhere((item) => item['id'] == product.id);
                      if (index != -1) {
                        cartProvider.addItem(index, selectedSize, quantity);
                        await Flushbar(
                          mainButton: TextButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Footer.CustomBottomMenu(
                                      page: Footer.Page.CART)),
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
                          message: "${product.name} x$quantity",
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
                      int index = cartProvider.shopItems
                          .indexWhere((item) => item['id'] == product.id);
                      if (index != -1) {
                        cartProvider.addItem(index, selectedSize, quantity);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Footer.CustomBottomMenu(
                                  page: Footer.Page.CART)),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                backgroundColor: Colors.green,
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
