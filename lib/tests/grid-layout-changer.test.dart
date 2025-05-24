import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/grid-layout.provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GridLayoutProvider', () {
    test('The default value should be one!', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = GridLayoutProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.crossAxisCountProducts, 1);
      expect(provider.crossAxisCountFavourites, 1);
    });

    test('It should load the set 2-2 values from shared-preferences!',
        () async {
      SharedPreferences.setMockInitialValues({
        GridLayoutProvider.keyProducts: 2,
        GridLayoutProvider.keyFavourites: 2,
      });
      final provider = GridLayoutProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.crossAxisCountProducts, 2);
      expect(provider.crossAxisCountFavourites, 2);
    });

    test('It should successfully toggle the products grid value from 1 to 2!',
        () async {
      SharedPreferences.setMockInitialValues({});
      final provider = GridLayoutProvider();
      await Future.delayed(const Duration(milliseconds: 100));
      final original = provider.crossAxisCountProducts;
      provider.toggleCrossAxisCount();

      expect(provider.crossAxisCountProducts, original == 1 ? 2 : 1);
    });

    test('It should successfully toggle the favourites grid value from 1 to 2!',
        () async {
      SharedPreferences.setMockInitialValues({});
      final provider = GridLayoutProvider();
      await Future.delayed(const Duration(milliseconds: 100));
      final original = provider.crossAxisCountFavourites;
      provider.toggleCrossAxisCount('favourites');

      expect(provider.crossAxisCountFavourites, original == 1 ? 2 : 1);
    });

    test('It should set the values explicitly to 2-2!', () async {
      SharedPreferences.setMockInitialValues({});
      final provider = GridLayoutProvider();
      await Future.delayed(const Duration(milliseconds: 100));
      provider.setCrossAxisCount(2); // products
      provider.setCrossAxisCount(1, 'favourites');

      expect(provider.crossAxisCountProducts, 2);
      expect(provider.crossAxisCountFavourites, 1);
    });
  });
}
