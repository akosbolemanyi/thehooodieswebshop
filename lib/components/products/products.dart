import 'package:android_studio_projects/components/products/product-details/product-details.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../abstract-classes/page-content.dart';
import '../../menus/custom-side-menu.dart' as Sidebar;
import '../../menus/custom-bottom-menu.dart' as Footer;
import '../../models/product.model.dart';
import '../../providers/cart.provider.dart';
import '../../providers/theme.provider.dart';
import '../../services/currency.service.dart';

/**
 * This page lists all the products, with the options to search and filter them.
 */

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
  String? searchedFor;
  String? selectedColour;
  String? selectedSort;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var cartProvider = Provider.of<CartProvider>(context, listen: false);
      await cartProvider.fetchShopItems();
      _filteredItems = List.from(cartProvider.shopItems);
    });

    _searchController.addListener(() {
      updateList(_searchController.text);
    });
  }

  void updateList(String value) {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    List<dynamic> filtered = List.from(cartProvider.shopItems);
    final nation = Locales.currentLocale(context)?.languageCode;
    final currencyService = CurrencyService.instance;
    final currency = currencyService.getCurrency(nation);

    if (value.isNotEmpty) {
      filtered = filtered.where((item) {
        String itemName = item['name'].toLowerCase();
        return itemName.contains(value.toLowerCase());
      }).toList();
    }

    if (selectedColour != null) {
      filtered = filtered.where((item) {
        return item['colour'].toString().toLowerCase() ==
            selectedColour!.toLowerCase();
      }).toList();
    }

    if (selectedSort != null) {
      switch (selectedSort) {
        case 'price_asc':
          filtered.sort((a, b) => (a['prices'][currency]['raw'] as num)
              .compareTo(b['prices']['HUF']['raw'] as num));
          break;
        case 'price_desc':
          filtered.sort((a, b) => (b['prices'][currency]['raw'] as num)
              .compareTo(a['prices']['HUF']['raw'] as num));
          break;
        case 'abc_asc':
          filtered.sort((a, b) => a['name'].compareTo(b['name']));
          break;
        case 'abc_desc':
          filtered.sort((a, b) => b['name'].compareTo(a['name']));
      }
    }

    setState(() {
      _filteredItems = filtered;
    });
  }

  void openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LocaleText("filtering",
                  style: GoogleFonts.cabin(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    labelText: Locales.string(context, 'choose_colour')),
                value: selectedColour,
                onChanged: (value) {
                  setState(() => selectedColour = value);
                },
                items: [
                  DropdownMenuItem(
                      value: null, child: LocaleText("all_colours")),
                  ...["red", "blue", "brown", "green", "yellow"].map((color) {
                    return DropdownMenuItem(
                        value: color, child: LocaleText(color));
                  }).toList(),
                ],
              ),
              SizedBox(height: 16),
              LocaleText("sorting",
                  style: GoogleFonts.cabin(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                    labelText: Locales.string(context, 'sequence')),
                value: selectedSort,
                onChanged: (value) {
                  setState(() => selectedSort = value);
                },
                items: [
                  DropdownMenuItem(child: LocaleText('default')),
                  DropdownMenuItem(
                      value: "price_asc", child: LocaleText("price_asc")),
                  DropdownMenuItem(
                      value: "price_desc", child: LocaleText("price_desc")),
                  DropdownMenuItem(
                      value: "abc_asc", child: LocaleText("abc_asc")),
                  DropdownMenuItem(
                      value: "abc_desc", child: LocaleText("abc_desc")),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            themeProvider.themeMode == ThemeMode.dark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300),
                    onPressed: () => Navigator.pop(context),
                    child: LocaleText("cancel",
                        style: GoogleFonts.cabin(
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            themeProvider.themeMode == ThemeMode.dark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300),
                    onPressed: () {
                      Navigator.pop(context);
                      updateList(_searchController.text);
                    },
                    child: LocaleText("apply",
                        style: GoogleFonts.cabin(
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black)),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void navigateToDetailsPage(int index) {
    final item = _filteredItems[index];
    final nation = Locales.currentLocale(context)?.languageCode;
    final currencyService = CurrencyService.instance;
    final currency = currencyService.getCurrency(nation);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(
          product: ProductModel(
            id: item['id'],
            name: item['name'],
            description: item['description'] ??
                'The quality is the single most significant component of the perfect hoodie. '
                    'We do not believe in giving this task of manufacturing to other companies. '
                    'We wanted to create ourselves, and we finally can. We hope, you feel it too.',
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
        preferredSize: Size.fromHeight(kToolbarHeight + 15),
        child: Container(
            color: Colors.red,
            padding: EdgeInsets.only(top: 15),
            child: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              title: LocaleText('menu_products',
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
                            MaterialPageRoute(
                                builder: (context) => Footer.CustomBottomMenu(
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
    final nation = Locales.currentLocale(context)?.languageCode;
    final currencyService = CurrencyService.instance;
    final currency = currencyService.getCurrency(nation);

    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        if (cartProvider.shopItems.isEmpty) {
          return Center(child: CircularProgressIndicator(color: Colors.red));
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
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide.none),
                        hintText: Locales.string(context, 'searching'),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: openFilterSheet,
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
                    return ProductModel(
                      id: item['id'],
                      name: item['name'],
                      description: item['description'] ??
                          'The quality is the single most significant component of the perfect hoodie. '
                              'We do not believe in giving this task of manufacturing to other companies. '
                              'We wanted to create ourselves, and we finally can. We hope, you feel it too.',
                      price: item['prices'][currency]['raw'].toString(),
                      imageUrl: item['imageUrl'],
                      colour: item['colour'],
                      onTap: () => navigateToDetailsPage(index),
                      onPressed: () {},
                      imageHeight: _crossAxisCount == 2 ? 120 : 310,
                      textSize: _crossAxisCount == 2 ? 20 : 35,
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
