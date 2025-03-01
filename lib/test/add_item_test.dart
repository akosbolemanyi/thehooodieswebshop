import 'package:flutter_test/flutter_test.dart';
import '../OLD-LOCAL-CONFIGURATIONS/OLD_cart_model.dart';

// Teszt
void main() {
  test("Adding 1 item to the cart:", () {

    final cartModel = OldCartModel();
    final initialLength = cartModel.cartItemsHuf.length;

    // Itt: piros pulcsi hozzáadása, az a nulladik indexű.
    cartModel.addItem(0);

    expect(cartModel.cartItemsHuf.length, initialLength + 1);
    print("Default number of items in cart: " + initialLength.toString());
    print("After adding one item to the cart: " + cartModel.cartItemsHuf.length.toString());
  });
}