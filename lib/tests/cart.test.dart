import 'package:flutter_test/flutter_test.dart';
import 'mocked-cart.provider.dart';

void main() {
  late MockedCartProvider cartProvider;

  setUp(() {
    cartProvider = MockedCartProvider();
    cartProvider.loadMockShopItems();
  });
  group('MockedCartProvider', () {
    test('Default cart quantity should be zero!', () {
      expect(cartProvider.cartItems, isEmpty);
      expect(cartProvider.totalQuantity, 0);
    });

    test('The product added to cart should be seen!', () {
      cartProvider.addItem(0, 'S', 2);

      expect(cartProvider.cartItems.length, 1);
      expect(cartProvider.cartItems[0]['id'], 'p1');
      expect(cartProvider.cartItems[0]['size'], 'S');
      expect(cartProvider.cartItems[0]['quantity'], 2);
    });

    test('Should increase quantity if same product is added!', () {
      cartProvider.addItem(0, 'S', 2);
      cartProvider.addItem(0, 'S', 3);

      expect(cartProvider.cartItems.length, 1);
      expect(cartProvider.cartItems[0]['quantity'], 5);
    });

    test('Should decrease quantity if same product is added!', () {
      cartProvider.addItem(0, 'S', 3);
      cartProvider.decreaseQuantity(0);

      expect(cartProvider.cartItems[0]['quantity'], 2);
    });

    test(
        'Should delete item overall from cart if decreasing last product quantity!',
        () {
      cartProvider.addItem(0, 'S', 1);
      cartProvider.decreaseQuantity(0);

      expect(cartProvider.cartItems.length, 0);
    });

    test('Should calculate quantity of same products correctly!', () {
      cartProvider.addItem(0, 'S', 2);
      cartProvider.addItem(0, 'M', 3);

      expect(cartProvider.totalQuantity, 5);
    });

    test('Should calculate the total price correctly!', () {
      cartProvider.addItem(0, 'S', 2);
      cartProvider.addItem(1, 'L', 1);

      expect(cartProvider.sumPrice('hu'), '4000');
    });
  });
}
