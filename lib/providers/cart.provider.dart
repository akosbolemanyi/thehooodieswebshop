import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

class CartProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _shopItems = [];

  Future<void> fetchShopItems() async {
    try {
      final querySnapshot = await _firestore.collection('products').get();

      _shopItems = [];
      var i = 0;
      for (var result in querySnapshot.docs) {
        var productData = result.data();

        String productId = result.id;
        String productName = productData['name'] ?? 'N/A';
        String imageUrl = productData['imageUrl'] ?? '';
        String colour = productData['colour'] ?? '';
        Map<String, dynamic> sizes = {};
        Map<String, dynamic> prices = {};

        var sizeCollection = await _firestore
            .collection('products')
            .doc(productId)
            .collection('sizes')
            .get();

        var priceCollection = await _firestore
            .collection('products')
            .doc(productId)
            .collection('prices')
            .get();

        for (var sizeDoc in sizeCollection.docs) {
          sizes[sizeDoc.id] = sizeDoc.data();
        }

        for (var priceDoc in priceCollection.docs) {
          prices[priceDoc.id] = priceDoc.data();
        }

        _shopItems.add({
          'id': productId,
          'name': productName,
          'imageUrl': imageUrl,
          'colour': colour,
          'sizes': sizes,
          'prices': prices,
        });
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  List<Map<String, dynamic>> get shopItems => _shopItems;

  List<Map<String, dynamic>> _cartItems = [];
  List<Map<String, dynamic>> get cartItems => _cartItems;
  List<Map<String, dynamic>> orderItems = [];

  // Frissített addItem metódus (most már mennyiséggel együtt)
  void addItem(int index, String selectedSize, int quantity) {
    var selectedItem = _shopItems[index];

    int existingIndex = _cartItems.indexWhere(
      (item) =>
          item['id'] == selectedItem['id'] && item['size'] == selectedSize,
    );
    if (existingIndex != -1) {
      _cartItems[existingIndex]['quantity'] += quantity; // Mennyiség növelése
    } else {
      _cartItems.add({
        ...selectedItem,
        'size': selectedSize,
        'priceHuf': selectedItem['prices']['HUF']['raw'].toString(),
        'priceEuro': selectedItem['prices']['EUR']['raw'].toString(),
        'priceDollar': selectedItem['prices']['USD']['raw'].toString(),
        'inStock': selectedItem['sizes'][selectedSize]['inStock'],
        'quantity': quantity, // Kezdeti mennyiség
      });
    }

    // TODO - The below one is more useful, change the cart to use this as well!
    int orderIndex = orderItems.indexWhere(
      (item) =>
          item['productId'] == selectedItem['id'] &&
          item['size'] == selectedSize,
    );
    if (orderIndex != -1) {
      orderItems[orderIndex]['quantity'] += quantity; // Increase quantity
    } else {
      orderItems.add({
        ...selectedItem,
        'productId': selectedItem['id'],
        'size': selectedSize,
        'price': selectedItem['prices']['HUF']['raw'],
        'quantity': quantity,
      });
    }

    notifyListeners();
  }

  void increaseQuantity(int index) {
    var item = _cartItems[index];
    int currentQuantity = item['quantity'] ?? 0;
    int stockQuantity = item['inStock']; // Készlet

    if (currentQuantity < stockQuantity) {
      _cartItems[index]['quantity'] += 1;
      notifyListeners();
    } else {
      // Ha a kosárban lévő mennyiség már elérte a készletet
      Utils.showSnackBar("Nincs elég készlet!");
    }
  }

  void decreaseQuantity(int index) {
    if (_cartItems[index]['quantity'] > 1) {
      _cartItems[index]['quantity'] -= 1;
    } else {
      _cartItems.removeAt(index);
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  int get totalQuantity {
    int total = 0;
    for (var item in _cartItems) {
      total += item['quantity'] as int;
    }
    return total;
  }

  String totalPriceDollar() {
    double sumPrice = 0;
    print('\n\n\nDOLLAR: ${_cartItems}\n\n\n');
    for (var item in _cartItems) {
      print(item['prices']['USD']['raw']);
      sumPrice += double.tryParse(item['prices']['USD']['raw'].toString())! *
          item['quantity'];
    }
    return sumPrice.toStringAsFixed(2);
  }

  String totalPriceEuro() {
    double sumPrice = 0;
    // print('\n\n\nEURO: ${_cartItems}\n\n\n');
    for (var item in _cartItems) {
      print(item['prices']['EUR']['raw']);
      sumPrice += double.tryParse(item['prices']['EUR']['raw'].toString())! *
          item['quantity'];
    }
    return sumPrice.toStringAsFixed(2);
  }

  String totalPriceHuf() {
    double sumPrice = 0;
    print('\n\n\nHUF: ${_cartItems}\n\n\n');
    for (var item in _cartItems) {
      print(item['prices']['HUF']['raw']);
      sumPrice += double.tryParse(item['prices']['HUF']['raw'].toString())! *
          item['quantity'];
    }
    return sumPrice.floor().toString();
  }
}
