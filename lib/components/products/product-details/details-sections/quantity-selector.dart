import 'package:flutter/material.dart';
import '../../../../constants.dart';

class ProductQuantitySelector extends StatefulWidget {
  final Function(int) onQuantityChanged;

  const ProductQuantitySelector({super.key, required this.onQuantityChanged});

  @override
  State<ProductQuantitySelector> createState() =>
      _ProductQuantitySelectorState();
}

class _ProductQuantitySelectorState extends State<ProductQuantitySelector> {
  int numOfItems = 1;

  void updateQuantity(int value) {
    setState(() {
      numOfItems = value;
    });
    widget.onQuantityChanged(numOfItems);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 40,
          height: 32,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            onPressed: () {
              if (numOfItems > 1) {
                updateQuantity(numOfItems - 1);
              }
            },
            child: const Icon(
              Icons.remove,
              color: Colors.red,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0 / 2),
          child: Text(
            numOfItems.toString().padLeft(2, "0"),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(
          width: 40,
          height: 32,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            onPressed: () {
              updateQuantity(numOfItems + 1);
            },
            child: const Icon(Icons.add, color: Colors.green),
          ),
        ),
      ],
    );
  }
}
