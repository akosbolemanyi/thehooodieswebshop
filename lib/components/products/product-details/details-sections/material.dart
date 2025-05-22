import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import '../../../../models/product.model.dart';

/**
 * This widget contains the description of the given product in text form.
 */

class ProductMaterial extends StatelessWidget {
  const ProductMaterial({super.key, required this.product});

  final ProductModel product;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: LocaleText(
        product.material,
        style: const TextStyle(height: 1.5),
      ),
    );
  }
}
