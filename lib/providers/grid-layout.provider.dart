import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GridLayoutProvider with ChangeNotifier {
  static const String keyProducts = 'cross_axis_count_products';
  static const String keyFavourites = 'cross_axis_count_favourites';

  int _crossAxisCountProducts = 1;
  int _crossAxisCountFavourites = 1;

  int get crossAxisCountProducts => _crossAxisCountProducts;
  int get crossAxisCountFavourites => _crossAxisCountFavourites;

  GridLayoutProvider() {
    _loadFromPrefs();
  }

  void toggleCrossAxisCount([String type = 'products']) {
    switch (type) {
      case 'favourites':
        _crossAxisCountFavourites = (crossAxisCountFavourites == 1) ? 2 : 1;
        _saveToPrefs(keyFavourites, _crossAxisCountFavourites);
        break;
      default:
        _crossAxisCountProducts = (_crossAxisCountProducts == 1) ? 2 : 1;
        _saveToPrefs(keyProducts, _crossAxisCountProducts);
    }

    notifyListeners();
  }

  void setCrossAxisCount(int count, [String type = 'products']) {
    switch (type) {
      case 'favourites':
        _crossAxisCountFavourites = count;
        _saveToPrefs(keyFavourites, count);
        break;
      default:
        _crossAxisCountProducts = count;
        _saveToPrefs(keyProducts, count);
    }
    notifyListeners();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _crossAxisCountProducts = prefs.getInt(keyProducts) ?? 1;
    _crossAxisCountFavourites = prefs.getInt(keyFavourites) ?? 1;
    notifyListeners();
  }

  Future<void> _saveToPrefs(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }
}
