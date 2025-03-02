import 'package:android_studio_projects/abstract-classes/page-contact.dart';
import 'package:android_studio_projects/model/product.model.dart';
import 'package:android_studio_projects/product-details/product-details.dart';
import 'package:android_studio_projects/provider/cart.provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'cart.dart';

class ProductsPage extends StatefulWidget implements PageContent {
  @override
  _ProductsPageState createState() => _ProductsPageState();

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) {
    return _ProductsPageState().buildAppBar(context);
  }

  @override
  Widget buildBody(BuildContext context) {
    return _ProductsPageState().buildBody(context);
  }
}

class _ProductsPageState extends State<ProductsPage> {
  int _crossAxisCount = 1;
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredItems = [];
  String? selectedColor;
  String? selectedSort;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var cartModel = Provider.of<CartModel>(context, listen: false);
      cartModel.fetchShopItems();
      _filteredItems =
          List.from(cartModel.shopItems); // Kezdeti lista betöltése
    });

    _searchController.addListener(() {
      updateList(_searchController.text); // Keresési szűrés
    });
  }

  // Frissíti a szűrt listát a keresési kulcs alapján
  void updateList(String value) {
    var cartModel = Provider.of<CartModel>(context, listen: false);

    setState(() {
      if (value.isEmpty) {
        _filteredItems = List.from(cartModel
            .shopItems); // Ha üres a keresési mező, visszatér minden elem
      } else {
        _filteredItems = cartModel.shopItems.where((item) {
          String itemName = item['name'].toLowerCase();
          return itemName.contains(value.toLowerCase());
        }).toList(); // Ha nem üres, akkor szűrjük a keresési kifejezés alapján
      }
    });
  }

  // Nyitja a szűrő ablakot
  void openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Szűrés és Rendezés",
                  style: GoogleFonts.cabin(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Színválasztás"),
                value: selectedColor,
                onChanged: (value) {
                  setState(() => selectedColor = value);
                },
                items: ["Piros", "Kék", "Fekete"].map((color) {
                  return DropdownMenuItem(value: color, child: Text(color));
                }).toList(),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Rendezés"),
                value: selectedSort,
                onChanged: (value) {
                  setState(() => selectedSort = value);
                },
                items: [
                  DropdownMenuItem(value: "asc", child: Text("ABC növekvő")),
                  DropdownMenuItem(value: "desc", child: Text("ABC csökkenő")),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Mégse"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Szűrés és rendezés logika ide jön
                    },
                    child: Text("Alkalmaz"),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  // Navigálás a termék részletes oldalára
  void navigateToDetailsPage(int index) {
    final item = _filteredItems[index];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HoodieDetailsPage(
          hoodie: HoodieItemTile(
            itemName: item['name'],
            itemPrice: item['sizes']['m']['priceHuf'],
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
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      title: Text('Products',
          style: GoogleFonts.cabin(
              fontWeight: FontWeight.bold, color: Colors.black)),
      actions: [
        IconButton(
          icon: Icon(Icons.grid_view),
          onPressed: () {
            setState(() {
              _crossAxisCount = _crossAxisCount == 1 ? 2 : 1;
            });
          },
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
                    MaterialPageRoute(builder: (context) => CartPage()),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    return Consumer<CartModel>(
      builder: (context, cartModel, child) {
        if (cartModel.shopItems.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.4),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none),
                        hintText: "Keresés...",
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: openFilterSheet, // Szűrés gomb
                  )
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  itemCount: _filteredItems.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _crossAxisCount,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    final item = _filteredItems[index];
                    return HoodieItemTile(
                      itemName: item['name'],
                      itemPrice: item['sizes']['m']['priceHuf'],
                      imagePath: item['imageUrl'],
                      color: Colors.white,
                      onTap: () => navigateToDetailsPage(
                          index), // Navigálás a részletes oldalra
                      onPressed: () {},
                      imageHeight: _crossAxisCount == 2 ? 120 : 310,
                      textSize: _crossAxisCount == 2 ? 20 : 25,
                      buttonFontSize: _crossAxisCount == 2 ? 20 : 30,
                      crossAxisCount: _crossAxisCount,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
