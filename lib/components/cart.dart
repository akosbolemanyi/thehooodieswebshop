import 'package:android_studio_projects/provider/cart.provider.dart';
import 'package:android_studio_projects/profile/shipping-address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../menu/custom-drawer.dart' as MyDrawer;

class CartPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CartPage({super.key}) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer.NavigationDrawer(),
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

  Widget buildImage(String imageUrl) {
    return Image.network(imageUrl, width: 100);
  }

  Widget buildNameLabel(String productName) {
    return Text(productName,
        style: GoogleFonts.cabin(fontWeight: FontWeight.bold, fontSize: 20));
  }

  Widget buildSize(String size) {
    return Row(children: [
      Text('Size:', style: GoogleFonts.cabin(fontSize: 15)),
      const SizedBox(width: 5),
      Text(size,
          style: GoogleFonts.cabin(
              fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w400))
    ]);
  }

  Widget buildPrice(String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$price Ft',
            style:
                GoogleFonts.cabin(fontWeight: FontWeight.bold, fontSize: 20)),
      ],
    );
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                    child: Row(
                      children: [
                        buildImage(item['imageUrl']),
                        const SizedBox(width: 20),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildNameLabel(item['name']),
                              const SizedBox(height: 2.5),
                              buildSize(item['size']),
                              const SizedBox(height: 2.5),
                              buildPrice(item['priceHuf']),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () => cartModel.removeItem(index),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Colors.red,
                                    size: 35,
                                  ),
                                  onPressed: () =>
                                      cartModel.decreaseQuantity(index),
                                ),
                                Text(
                                  item['quantity'].toString(),
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.green,
                                    size: 35,
                                  ),
                                  onPressed: () =>
                                      cartModel.increaseQuantity(index),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShippingAddressPage(
                                        isPaymentMode: true)),
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
