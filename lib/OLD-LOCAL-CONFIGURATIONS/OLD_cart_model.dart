import 'package:flutter/material.dart';

class OldCartModel extends ChangeNotifier {
  final List _shopItemsDollar = [
    ["Darrow", "54.99", "assets/img/main.png", Colors.red],
    ["Old Shatterhand", "39.99", "assets/img/yellow.png", Colors.yellow],
    ["Luke Skywalker", "39.99", "assets/img/green.png", Colors.green],
    ["Thrawn", "32.99", "assets/img/blue.png", Colors.blue],
    ["Han Solo", "32.99", "assets/img/brown.png", Colors.brown]
  ];

  final List _shopItemsEuro = [
    ["Darrow", "50.99", "assets/img/main.png", Colors.red],
    ["Old Shatterhand", "37.99", "assets/img/yellow.png", Colors.yellow],
    ["Luke Skywalker", "37.99", "assets/img/green.png", Colors.green],
    ["Thrawn", "30.99", "assets/img/blue.png", Colors.blue],
    ["Han Solo", "30.99", "assets/img/brown.png", Colors.brown]
  ];

  final List _shopItemsHuf = [
    ["Darrow", "19990", "assets/img/main.png", Colors.red],
    ["Old Shatterhand", "14990", "assets/img/yellow.png", Colors.yellow],
    ["Luke Skywalker", "14990", "assets/img/green.png", Colors.green],
    ["Thrawn", "11990", "assets/img/blue.png", Colors.blue],
    ["Han Solo", "11990", "assets/img/brown.png", Colors.brown]
  ];

  final List _cartItemsDollar = [];
  final List _cartItemsEuro = [];
  final List _cartItemsHuf = [];

  get shopItemsDollar => _shopItemsDollar;
  get cartItemsDollar => _cartItemsDollar;
  get shopItemsEuro => _shopItemsEuro;
  get cartItemsEuro => _cartItemsEuro;
  get shopItemsHuf => _shopItemsHuf;
  get cartItemsHuf => _cartItemsHuf;

  void addItem(int index) {
    _cartItemsDollar.add(_shopItemsDollar[index]);
    _cartItemsEuro.add(_shopItemsEuro[index]);
    _cartItemsHuf.add(_shopItemsHuf[index]);
    notifyListeners();
  }

  void removeItem(int index) {
    _cartItemsDollar.removeAt(index);
    _cartItemsEuro.removeAt(index);
    _cartItemsHuf.removeAt(index);
    notifyListeners();
  }

  String totalPriceDollar() {
      double sumPrice = 0;
      for (int i = 0; i < _cartItemsDollar.length; i++) {
        sumPrice += double.parse(_cartItemsDollar[i][1]);
      }
      return sumPrice.toStringAsFixed(2);
  }

  String totalPriceEuro() {
    double sumPrice = 0;
    for (int i = 0; i < _cartItemsEuro.length; i++) {
      sumPrice += double.parse(_cartItemsEuro[i][1]);
    }
    return sumPrice.toStringAsFixed(2);
  }

  String totalPriceHuf() {
    int sumPrice = 0;
    for (int i = 0; i < _cartItemsHuf.length; i++) {
      sumPrice += int.parse(_cartItemsHuf[i][1]);
    }
    return sumPrice.toString();
  }
}