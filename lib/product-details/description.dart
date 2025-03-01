import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../model/product.model.dart';

class Description extends StatelessWidget {
  const Description({super.key, required this.hoodie});

  final HoodieItemTile hoodie;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin),
      child: Text(
        'descriőptiondx.fsddfsdsds',
        style: const TextStyle(height: 1.5),
      ),
    );
  }
}
