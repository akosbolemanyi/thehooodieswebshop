import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../models/product.model.dart';

class FavouritesProvider extends ChangeNotifier {
  List<String> _favourites = [];
  List<String> get favourites => _favourites;
  set favourites(List<String> value) {
    _favourites = value;
  }

  FavouritesProvider() {
    _loadFavouritesFromDatabase();
  }

  Future<void> _loadFavouritesFromDatabase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data();
      if (data != null && data['favourites'] != null) {
        _favourites = List<String>.from(data['favourites']);
        notifyListeners();
      }
    }
  }

  Future<void> toggleFavourite(ProductModel product) async {
    final user = FirebaseAuth.instance.currentUser!;
    if (_favourites.contains(product.id)) {
      _favourites.remove(product.id);
    } else {
      _favourites.add(product.id);
    }
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'favourites': _favourites,
    });
    notifyListeners();
  }

  bool isExist(ProductModel product) {
    final isExist = _favourites.contains(product.id);
    return isExist;
  }

  static FavouritesProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavouritesProvider>(
      context,
      listen: listen,
    );
  }
}
