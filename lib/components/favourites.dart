import 'package:android_studio_projects/abstract-classes/page-contact.dart';
import 'package:flutter/material.dart';
import 'package:android_studio_projects/provider/cart.provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../menu/custom-drawer.dart' as MyDrawer;
import '../model/product.model.dart';
import '../product-details/product-details.dart';
import '../provider/favourites.provider.dart';
import '../menu/custom-bottom-navigation-bar.dart' as OwnBar;

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
  int _crossAxisCount = 1;

  @override
  void initState() {
    super.initState();
  }

  void _toggleGridCount() {
    setState(() {
      _crossAxisCount = _crossAxisCount == 1 ? 2 : 1;
    });
  }

  void navigateToDetailsPage(int index, CartModel cartModel) {
    final item = cartModel.shopItems[index];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HoodieDetailsPage(
          hoodie: HoodieItemTile(
            id: item['id'],
            itemName: item['name'],
            itemPrice: item['sizes']['m']
                ['priceHuf'], // Alapértelmezett M méretű ár
            imagePath: item['imageUrl'],
            color: Colors.red,
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
              iconTheme: IconThemeData(color: Colors.black),
              title: Text('Favourites',
                  style: GoogleFonts.cabin(
                      fontWeight: FontWeight.bold, color: Colors.black)),
              actions: [
                IconButton(
                  icon: Icon(Icons.grid_view),
                  onPressed: _toggleGridCount,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Consumer<CartModel>(
                    builder: (context, cartModel, child) {
                      return badges.Badge(
                        position: badges.BadgePosition.topEnd(top: -5, end: -6),
                        showBadge: cartModel.cartItems.isNotEmpty,
                        badgeStyle: badges.BadgeStyle(
                          badgeColor: Colors.white,
                          shape: badges.BadgeShape.circle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        badgeContent: Text(cartModel.totalQuantity.toString()),
                        child: IconButton(
                          icon: Icon(Icons.shopping_cart),
                          iconSize: 25,
                          color: Colors.black,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    OwnBar.CustomBottomNavigationBar(
                                        page: OwnBar.Page.HOME)),
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
    final favouritesProvider = FavouriteProvider.of(context);

    return Consumer<CartModel>(
      builder: (context, cartModel, child) {
        // Filtering the shopItems to show only the items that are in the favourites list
        final favouriteItems = cartModel.shopItems
            .where((item) => favouritesProvider.favourites
                .any((favourite) => favourite == item['name']))
            .toList();

        if (favouriteItems.isEmpty) {
          return Center(child: Text("No favourite items yet."));
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: favouriteItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: _crossAxisCount,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              final item = favouriteItems[index];
              double imageHeight = _crossAxisCount == 2 ? 120 : 310;
              double textSize = _crossAxisCount == 2 ? 20 : 25;
              double buttonFontSize = _crossAxisCount == 2 ? 20 : 30;

              return HoodieItemTile(
                id: item['id'],
                itemName: item['name'],
                itemPrice: item['prices']['HUF']['raw']
                    .toString(), // Alapértelmezett M méretű ár
                imagePath: item['imageUrl'],
                color: Colors.white,
                onTap: () => navigateToDetailsPage(index, cartModel),
                onPressed: () {},
                imageHeight: imageHeight,
                textSize: textSize,
                buttonFontSize: buttonFontSize,
                crossAxisCount: _crossAxisCount,
              );
            },
          ),
        );
      },
    );
  }
}
