import 'package:flutter_test/flutter_test.dart';

import '../OLD-LOCAL-CONFIGURATIONS/OLD_cart_model.dart';

// Teszt
void main() {
  test("Removing 1 item from the cart:", () {

    final cartModel = OldCartModel();
    // Itt: piros pulcsi hozzáadása, az a nulladik indexű
    cartModel.addItem(0);
    final initialLength = cartModel.cartItemsHuf.length;

    // Utolsó elem eltávolítása.
    cartModel.removeItem(initialLength - 1);

    expect(cartModel.cartItemsHuf.length, initialLength - 1);
    print("Default number of items in cart: " + initialLength.toString());
    print("After removing one item from the cart: " + cartModel.cartItemsHuf.length.toString());
  });
}