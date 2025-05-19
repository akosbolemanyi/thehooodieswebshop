import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../models/product.model.dart';

class FavouritesProvider extends ChangeNotifier {
  final List<String> _favourites = [];
  List<String> get favourites => _favourites;
  void toggleFavourite(ProductModel product) {
    if (_favourites.contains(product.itemName)) {
      _favourites.remove(product.itemName);
    } else {
      _favourites.add(product.itemName);
    }
    notifyListeners();
  }

  bool isExist(ProductModel product) {
    final isExist = _favourites.contains(product.itemName);
    return isExist;
  }

  static FavouritesProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavouritesProvider>(
      context,
      listen: listen,
    );
  }
}
