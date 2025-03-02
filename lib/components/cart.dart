import 'package:android_studio_projects/provider/cart.provider.dart';
import 'package:android_studio_projects/profile/shipping-address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CartPage({super.key}) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 15),
        child: Container(
          color: Colors.red,
          padding: EdgeInsets.only(top: 15),
          child: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            title: LocaleText(
              'menu_cart',
              style: GoogleFonts.cabin(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ));
  }

  Widget buildBody(BuildContext context) {
    final nation = Locales.currentLocale(context)?.languageCode;
    return Consumer<CartModel>(
      builder: (context, cartModel, child) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartModel.cartItems.length,
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  final item = cartModel.cartItems[index];
                  return Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 120, // Nagyobb hely a méretnek és gomboknak
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: Image.network(
                          item['imageUrl'],
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(
                          item['name'],
                          style: const TextStyle(color: Colors.black),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nation == 'hu'
                                  ? "${item['priceHuf']} Ft"
                                  : nation == 'en'
                                      ? "\$${item['priceDollar']}"
                                      : "€${item['priceEuro']}",
                              style: const TextStyle(color: Colors.black),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Méret: ${item['size'].toUpperCase()}", // Méret kiírása
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            // Mennyiség növelő és csökkentő gombok
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove,
                                      color: Colors.red),
                                  onPressed: () =>
                                      cartModel.decreaseQuantity(index),
                                ),
                                Text(
                                  item['quantity'].toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add,
                                      color: Colors.green),
                                  onPressed: () =>
                                      cartModel.increaseQuantity(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () => cartModel.removeItem(index),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(36.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LocaleText(
                          'total_price',
                          style: GoogleFonts.cabin(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          nation == 'hu'
                              ? "${cartModel.totalPriceHuf()} Ft"
                              : nation == 'en'
                                  ? "\$${cartModel.totalPriceDollar()}"
                                  : "€${cartModel.totalPriceEuro()}",
                          style: GoogleFonts.cabin(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.green.shade100, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigálás a Shipping oldalra
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShippingAddressPage(
                                        isPaymentMode:
                                            true)), // Cseréld a ShippingPage-t az aktuális shipping oldaladra
                              );
                            },
                            child: LocaleText(
                              'pay_now',
                              style: GoogleFonts.cabin(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.green.shade100,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ShippingPage {}
