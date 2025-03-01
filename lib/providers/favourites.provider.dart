import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../components/SAVE-hoodie_item_tile.dart';

class FavouriteProvider extends ChangeNotifier {
  final List<String> _favourites = [];
  List<String> get favourites => _favourites;
  void toggleFavourite(HoodieItemTile hoodie) {
    if (_favourites.contains(hoodie.itemName)) {
      _favourites.remove(hoodie.itemName);
    } else {
      _favourites.add(hoodie.itemName);
    }
    notifyListeners();
  }

  bool isExist(HoodieItemTile hoodie) {
    final isExist = _favourites.contains(hoodie.itemName);
    return isExist;
  }

  static FavouriteProvider of(BuildContext context, { bool listen = true}) {
    return Provider.of<FavouriteProvider>(
      context,
      listen: listen,
    );
  }
}