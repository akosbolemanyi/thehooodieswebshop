import 'package:flutter/material.dart';

/**
 * This mocked provider is intended to test the local functionality of the cart
 * operations, without the Firebase and Firestore dependencies.
 */
class MockedCartProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _shopItems = [];

  List<Map<String, dynamic>> _cartItems = [];
  List<Map<String, dynamic>> _orderItems = [];

  List<Map<String, dynamic>> get shopItems => _shopItems;
  List<Map<String, dynamic>> get cartItems => _cartItems;
  List<Map<String, dynamic>> get orderItems => _orderItems;

  set cartItems(List<Map<String, dynamic>> value) {
    _cartItems = value;
  }

  void loadMockShopItems() {
    _shopItems = [
      {
        'id': 'p1',
        'name': 'Product 1',
        'imageUrl': 'url1',
        'colour': 'red',
        'material': 'cotton',
        'sizes': {
          'S': {'inStock': 10},
          'M': {'inStock': 5},
        },
        'prices': {
          'HUF': {'raw': 1000},
          'USD': {'raw': 3},
        },
      },
      {
        'id': 'p2',
        'name': 'Product 2',
        'imageUrl': 'url2',
        'colour': 'blue',
        'material': 'polyester',
        'sizes': {
          'L': {'inStock': 2},
        },
        'prices': {
          'HUF': {'raw': 2000},
          'USD': {'raw': 6},
        },
      },
    ];
    notifyListeners();
  }

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

    int orderIndex = _orderItems.indexWhere(
      (item) =>
          item['productId'] == selectedItem['id'] &&
          item['size'] == selectedSize,
    );
    if (orderIndex != -1) {
      _orderItems[orderIndex]['quantity'] += quantity;
    } else {
      _orderItems.add({
        ...selectedItem,
        'productId': selectedItem['id'],
        'size': selectedSize,
        'price': selectedItem['prices']['HUF']['raw'].toString(),
        'quantity': quantity,
      });
    }

    notifyListeners();
  }

  void increaseQuantity(int index, BuildContext context) {
    var item = _cartItems[index];
    int currentQuantity = item['quantity'] ?? 0;
    int stockQuantity = item['inStock'];

    if (currentQuantity < stockQuantity) {
      _cartItems[index]['quantity'] += 1;
      notifyListeners();
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
    final currency = _getCurrency(nation);
    double sum = 0;
    for (var item in _cartItems) {
      sum += double.tryParse(item['prices'][currency]['raw'].toString())! *
          item['quantity'];
    }
    final decimal = nation == 'hu' ? 0 : 2;
    return sum.toStringAsFixed(decimal);
  }

  String _getCurrency(String nation) {
    switch (nation) {
      case 'hu':
        return 'HUF';
      case 'en':
        return 'USD';
      default:
        return 'EUR';
    }
  }
}
