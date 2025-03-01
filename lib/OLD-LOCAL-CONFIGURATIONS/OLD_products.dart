import 'package:android_studio_projects/providers/theme_changer_provider.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../OLD-details/OLD_food-details-page.dart';
import 'OLD_cart.dart';
import 'OLD_cart_model.dart';
import 'OLD_hoodie_item_tile.dart';
import '../components/navigation_drawer.dart' as sidebar;
import 'package:badges/badges.dart' as badges;

class OldProductsPage extends StatefulWidget {

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<OldProductsPage> {
  int _crossAxisCount = 1;

  void _toggleGridCount() {
    setState(() {
      _crossAxisCount = _crossAxisCount == 1 ? 2 : 1;
    });
  }

    void navigateToDetailsPage(int index) {
      final nation = Locales.currentLocale(context)?.languageCode;
      final cartModel = Provider.of<OldCartModel>(context, listen: false);

      // Adatok kinyerése a megfelelő nyelv szerint
      final itemName = nation == 'hu'
          ? cartModel.shopItemsHuf[index][0]
          : nation == 'en'
          ? cartModel.shopItemsDollar[index][0]
          : cartModel.shopItemsEuro[index][0];
      final itemPrice = nation == 'hu'
          ? cartModel.shopItemsHuf[index][1]
          : nation == 'en'
          ? cartModel.shopItemsDollar[index][1]
          : cartModel.shopItemsEuro[index][1];
      final imagePath = cartModel.shopItemsHuf[index][2];
      final color = nation == 'hu'
          ? cartModel.shopItemsHuf[index][3]
          : nation == 'en'
          ? cartModel.shopItemsDollar[index][3]
          : cartModel.shopItemsEuro[index][3];

      // Átirányítás a HoodieDetailsPage-re a termék adataival
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OldHoodieDetailsPage(
            hoodie: OldHoodieItemTile(
              itemName: itemName,
              itemPrice: itemPrice,
              imagePath: imagePath,
              color: color,
              imageHeight: 310,
              textSize: 25,
              buttonFontSize: 30,
              crossAxisCount: _crossAxisCount,
              onTap: () { }, onPressed: () { }, // Nem használjuk itt
            ),
          ),
        ),
      );
    }


    @override
  Widget build(BuildContext context) {
    final nation = Locales.currentLocale(context)?.languageCode;
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
        drawer: const sidebar.NavigationDrawer(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: LocaleText('menu_products', style: GoogleFonts.cabin(
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),),
          // backgroundColor: Colors.blue,
          actions: [
            IconButton(
              icon: Icon(Icons.grid_view), // Ikon a nézet váltáshoz
              onPressed: _toggleGridCount, // Gomb lenyomásra vált
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Consumer<OldCartModel>(
                builder: (context, value, child) {
                  return badges.Badge(
                    position: badges.BadgePosition.topEnd(top: -5, end: -6),
                    showBadge: value.cartItemsHuf.length == 0 ? false : true,
                    badgeStyle: badges.BadgeStyle(
                        badgeColor: themeChanger.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
                        shape: badges.BadgeShape.circle,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    badgeContent: Text(value.cartItemsHuf.length.toString()),
                    badgeAnimation: badges.BadgeAnimation.rotation(),
                    child: IconButton(
                      icon: Icon(Icons.shopping_cart),
                      iconSize: 25,
                      color: Colors.black,
                      onPressed: () =>
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return const OldCartPage();
                              }
                          ),
                          ),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: LocaleText(
                  'hello_there',
                  style: GoogleFonts.cabin(fontSize: 15),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: LocaleText(
                    'products_motto',
                    style: GoogleFonts.cabin(
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                    ),
                  )
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Divider(),
              ),
              Expanded(
                child: Consumer<OldCartModel>(
                    builder: (context, value, child) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                            itemCount: value.shopItemsHuf.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              crossAxisCount: _crossAxisCount,
                              childAspectRatio: 0.9,
                            ),
                            itemBuilder: (context, index) {
                                double imageHeight = _crossAxisCount == 2 ? 120 : 310;
                                double textSize = _crossAxisCount == 2 ? 20 : 25;
                                double buttonFontSize = _crossAxisCount == 2 ? 20 : 30;
                                return OldHoodieItemTile(
                                  itemName: nation == 'hu' ? value.shopItemsHuf[index][0] : nation == 'en' ? value.shopItemsDollar[index][0] : value.shopItemsEuro[index][0],
                                  itemPrice: nation == 'hu' ? value.shopItemsHuf[index][1] : nation == 'en' ? value.shopItemsDollar[index][1] : value.shopItemsEuro[index][1],
                                  imagePath: value.shopItemsHuf[index][2],
                                  color: value.shopItemsHuf[index][3],
                                  onTap: () => navigateToDetailsPage(index),
                                  onPressed: () async {
                                    Provider.of<OldCartModel>(context, listen: false)
                                        .addItem(index);
                                        await Flushbar(
                                          mainButton: TextButton(
                                            onPressed: () => Navigator.push(context, MaterialPageRoute(
                                            builder: (context) {
                                              return const OldCartPage();
                                            }
                                              ),
                                            ), child: LocaleText(
                                                    'click_me',
                                                    style: GoogleFonts.cabin(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green
                                            ),
                                          )
                                          ),
                                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.085, bottom: 10, left: 10, right: 10),
                                          showProgressIndicator: false,
                                          flushbarPosition: FlushbarPosition.TOP,
                                          isDismissible: true,
                                          backgroundColor: Colors.white.withOpacity(0.9),
                                          messageSize: 12,
                                          icon: Icon(
                                              Icons.check_circle,
                                              color: Colors.green
                                          ),
                                        borderRadius: BorderRadius.circular(15),
                                        barBlur: 8.0,
                                        titleColor: Colors.black,
                                        messageColor: Colors.black,
                                        title: nation == 'hu' ? "Kosárhoz adva!" : nation == 'en' ? "Added to cart!" : 'Zum Warenkorb hinzugefügt!',
                                        message: nation == 'hu' ? value.shopItemsHuf[index][0] : nation == 'en' ? value.shopItemsDollar[index][0] : value.shopItemsEuro[index][0],
                                        duration: Duration(seconds: 3),
                                        ).show(context);
                                  },
                                  imageHeight: imageHeight,
                                  textSize: textSize,
                                  buttonFontSize: buttonFontSize,
                                  crossAxisCount: _crossAxisCount,
                                );
                            }
                        ),
                      );
                    }
                ),
              )
            ],
          ),
        )
    );
  }
}

