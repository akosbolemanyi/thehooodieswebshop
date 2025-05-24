import 'package:android_studio_projects/components/profile/shipping-address-form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../menus/custom-side-menu.dart' as Sidebar;
import '../providers/cart.provider.dart';
import '../services/currency.service.dart';
import '../utils/utils.dart';

class CartPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  CartPage({super.key}) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar.CustomSideMenu(),
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 10),
        child: Container(
          color: Colors.red,
          padding: EdgeInsets.only(top: 10),
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
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 100,
      placeholder: (context, url) => Center(
        child: SpinKitDualRing(
          color: Colors.red,
          size: 40.0,
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  Widget buildNameLabel(String productName) {
    return Text(productName,
        style: GoogleFonts.cabin(fontWeight: FontWeight.bold, fontSize: 20));
  }

  Widget buildSize(String size) {
    return Row(children: [
      LocaleText('size_is', style: GoogleFonts.cabin(fontSize: 15)),
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
        Text(price,
            style:
                GoogleFonts.cabin(fontWeight: FontWeight.bold, fontSize: 20)),
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    final nation = Locales.currentLocale(context)?.languageCode;
    final currencyService = CurrencyService.instance;
    final currency = currencyService.getCurrency(nation);
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartProvider.cartItems.length,
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, index) {
                  final item = cartProvider.cartItems[index];
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
                              buildPrice(currencyService.format(
                                  item['prices'][currency]['raw'].toString(),
                                  currency)),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () => cartProvider.removeItem(index),
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
                                      cartProvider.decreaseQuantity(index),
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
                                  onPressed: () => cartProvider
                                      .increaseQuantity(index, context),
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
                          currencyService.format(
                              cartProvider.sumPrice(nation!), currency),
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
                              final cartIsEmpty = cartProvider
                                  .sumPrice(nation)
                                  .replaceAll(RegExp(r'[^0-9]'), '')
                                  .replaceAll('0', '')
                                  .isEmpty;
                              if (!cartIsEmpty) {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: ShippingAddressForm(
                                          isPaymentMode: true)),
                                );
                              } else {
                                Utils.showSnackBar(
                                    Locales.string(context, 'cart_empty'));
                              }
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
