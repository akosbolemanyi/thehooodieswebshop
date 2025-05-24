import 'package:android_studio_projects/abstract-classes/page-content.dart';
import 'package:android_studio_projects/components/products/product-details/product-details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../models/product.model.dart';
import 'package:badges/badges.dart' as badges;
import '../menus/custom-side-menu.dart' as Sidebar;
import '../menus/custom-bottom-menu.dart' as Footer;
import '../providers/cart.provider.dart';
import '../providers/favourites.provider.dart';
import '../providers/grid-layout.provider.dart';
import '../services/currency.service.dart';

/**
 * This page lists the products marked favourite.
 */

class FavouritesPage extends StatefulWidget implements PageContent {
  @override
  _FavouritesPageState createState() => _FavouritesPageState();

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) {
    return _FavouritesPageState().buildAppBar(context);
  }

  @override
  Widget buildBody(BuildContext context) {
    return _FavouritesPageState().buildBody(context);
  }
}

class _FavouritesPageState extends State<FavouritesPage> {
  void navigateToDetailsPage(String id, CartProvider cartProvider) {
    final item =
        cartProvider.shopItems.firstWhere((element) => element['id'] == id);
    final nation = Locales.currentLocale(context)?.languageCode;
    final currencyService = CurrencyService.instance;
    final currency = currencyService.getCurrency(nation);
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.fade,
        child: ProductDetailsPage(
          product: ProductModel(
            id: item['id'],
            name: item['name'],
            material: item['material'],
            price: item['prices'][currency]['raw'].toString(),
            imageUrl: item['imageUrl'],
            colour: item['colour'],
            onTap: () {},
            onPressed: () {},
            imageHeight: 1,
            textSize: 1,
            buttonFontSize: 1,
            crossAxisCount: 1,
          ),
        ),
      ),
    );
  }

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
              iconTheme: IconThemeData(color: Colors.black),
              title: LocaleText('menu_favourites',
                  style: GoogleFonts.cabin(
                      fontWeight: FontWeight.bold, color: Colors.black)),
              actions: [
                IconButton(
                    icon: Icon(Icons.grid_view),
                    onPressed: () {
                      setState(() {
                        Provider.of<GridLayoutProvider>(context, listen: false)
                            .toggleCrossAxisCount('favourites');
                      });
                    }),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Consumer<CartProvider>(
                    builder: (context, cartProvider, child) {
                      return badges.Badge(
                        position: badges.BadgePosition.topEnd(top: -7, end: -7),
                        showBadge: cartProvider.cartItems.isNotEmpty,
                        badgeStyle: badges.BadgeStyle(
                          padding: EdgeInsets.all(7),
                          badgeColor: Colors.white,
                          shape: badges.BadgeShape.circle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        badgeContent: Text(
                          cartProvider.totalQuantity.toString(),
                          style: GoogleFonts.cabin(
                            color: Colors.black,
                          ),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.shopping_cart),
                          iconSize: 25,
                          onPressed: () => Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: Footer.CustomBottomMenu(
                                    page: Footer.Page.CART)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )));
  }

  Widget buildBody(BuildContext context) {
    final favouritesProvider = FavouritesProvider.of(context);
    final nation = Locales.currentLocale(context)?.languageCode;
    final currencyService = CurrencyService.instance;
    final currency = currencyService.getCurrency(nation);
    final crossAxisCount =
        Provider.of<GridLayoutProvider>(context).crossAxisCountFavourites;

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        final favouriteItems = cartProvider.shopItems
            .where((item) => favouritesProvider.favourites
                .any((favourite) => favourite == item['id']))
            .toList();
        if (favouriteItems.isEmpty) {
          return Center(child: LocaleText("no_favourites"));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: favouriteItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: crossAxisCount,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final item = favouriteItems[index];
              double imageHeight = crossAxisCount == 2 ? 120 : 310;
              double textSize = crossAxisCount == 2 ? 20 : 25;
              double buttonFontSize = crossAxisCount == 2 ? 20 : 30;

              return ProductModel(
                id: item['id'],
                name: item['name'],
                material: item['material'],
                price: item['prices'][currency]['raw'].toString(),
                imageUrl: item['imageUrl'],
                colour: item['colour'],
                onTap: () => navigateToDetailsPage(item['id'], cartProvider),
                onPressed: () {},
                imageHeight: imageHeight,
                textSize: textSize,
                buttonFontSize: buttonFontSize,
                crossAxisCount: crossAxisCount,
              );
            },
          ),
        );
      },
    );
  }
}
