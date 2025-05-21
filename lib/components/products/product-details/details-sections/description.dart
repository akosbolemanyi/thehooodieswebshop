import 'package:flutter/material.dart';
import '../../../../models/product.model.dart';

/**
 * This widget contains the description of the given product in text form.
 */

class ProductDescription extends StatelessWidget {
  const ProductDescription({super.key, required this.product});

  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Text(
        'This hoodie is the benchmark of the company. It was designed by our finest designers. It is the flagship, since this was the first hoodie we ever dreamed. Rapid red color, the one that will definitely take your attention!',
        style: const TextStyle(height: 1.5),
      ),
    );
  }
}
