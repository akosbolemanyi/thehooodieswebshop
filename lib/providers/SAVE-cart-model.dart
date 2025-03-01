import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../authentication/utils.dart';

class CartModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _shopItems = [];

  Future<void> fetchShopItems() async {
    try {
      final querySnapshot = await _firestore.collection('products').get();

      _shopItems = [];
      for (var result in querySnapshot.docs) {
        var productData = result.data();
        String productId = result.id;

        String productName = productData['name'] ?? 'N/A';
        String imageUrl = productData['imageUrl'] ?? '';
        Map<String, dynamic> sizes = {};

        // Méretek betöltése a "sizes" alkollekcióból
        var sizeCollection = await _firestore
            .collection('products')
            .doc(productId)
            .collection('sizes')
            .get();

        for (var sizeDoc in sizeCollection.docs) {
          sizes[sizeDoc.id] = sizeDoc.data();
        }

        _shopItems.add({
          'id': productId,
          'name': productName,
          'imageUrl': imageUrl,
          'sizes': sizes, // Méretek és áraik
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

  // Frissített addItem metódus (most már mennyiséggel együtt)
  void addItem(int index, String selectedSize, int quantity) {
    var selectedItem = _shopItems[index];

    int existingIndex = _cartItems.indexWhere(
          (item) => item['id'] == selectedItem['id'] && item['size'] == selectedSize,
    );

    print('SelectedItem: ' + selectedItem.toString() + " | " + selectedSize);

    if (existingIndex != -1) {
      _cartItems[existingIndex]['quantity'] += quantity; // Mennyiség növelése
    } else {
      _cartItems.add({
        ...selectedItem,
        'size': selectedSize,
        'priceHuf': selectedItem['sizes'][selectedSize]['priceHuf'],
        'priceEuro': selectedItem['sizes'][selectedSize]['priceEuro'],
        'priceDollar': selectedItem['sizes'][selectedSize]['priceDollar'],
        'onStock': selectedItem['sizes'][selectedSize]['onStock'],
        'quantity': quantity, // Kezdeti mennyiség
      });
    }

    notifyListeners();
  }

  void increaseQuantity(int index) {
    var item = _cartItems[index];
    int currentQuantity = item['quantity'] ?? 0;
    int stockQuantity = item['onStock']; // Készlet

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
    for (var item in _cartItems) {
      sumPrice += double.tryParse(item['priceDollar'].toString())! * item['quantity'];
    }
    return sumPrice.toStringAsFixed(2);
  }

  String totalPriceEuro() {
    double sumPrice = 0;
    for (var item in _cartItems) {
      sumPrice += double.tryParse(item['priceEuro'].toString())! * item['quantity'];
    }
    return sumPrice.toStringAsFixed(2);
  }

  String totalPriceHuf() {
    double sumPrice = 0;
    for (var item in _cartItems) {
      sumPrice += double.tryParse(item['priceHuf'].toString())! * item['quantity'];
    }
    return sumPrice.floor().toString();
  }
}
