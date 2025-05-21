import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';

import '../services/currency.service.dart';
import '../utils/utils.dart';

class CartProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _shopItems = [];

  bool _isLoading = false;
  Future<void> fetchShopItems() async {
    if (_isLoading) return;
    _isLoading = true;
    try {
      _shopItems = [];
      final querySnapshot = await _firestore.collection('products').get();
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
    } finally {
      _isLoading = false;
    }
  }

  List<Map<String, dynamic>> _cartItems = [];
  List<Map<String, dynamic>> _orderItems = [];
  List<Map<String, dynamic>> get shopItems => _shopItems;
  List<Map<String, dynamic>> get cartItems => _cartItems;
  List<Map<String, dynamic>> get orderItems => _orderItems;

  void addItem(int index, String selectedSize, int quantity) {
    var selectedItem = _shopItems[index];

    int cartIndex = _cartItems.indexWhere(
      (item) =>
          item['id'] == selectedItem['id'] && item['size'] == selectedSize,
    );
    if (cartIndex != -1) {
      _cartItems[cartIndex]['quantity'] += quantity;
    } else {
      _cartItems.add({
        ...selectedItem,
        'size': selectedSize,
        'inStock': selectedItem['sizes'][selectedSize]['inStock'],
        'quantity': quantity,
      });
    }

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
        'price': selectedItem['prices']['HUF']['raw'].toString(),
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

  String sumPrice(String nation) {
    final currencyService = CurrencyService.instance;
    final currency = currencyService.getCurrency(nation);
    double sum = 0;
    for (var item in _cartItems) {
      sum += double.tryParse(item['prices'][currency]['raw'].toString())! *
          item['quantity'];
    }
    final decimal = nation == 'hu' ? 0 : 2;
    return sum.toStringAsFixed(decimal);
  }
}
