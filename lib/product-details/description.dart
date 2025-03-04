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
        'This hoodie is the benchmark of the company. It was designed by our finest designers. It is the flagship, since this was the first hoodie we ever dreamed. Rapid red color, the one that will definitely take your attention!',
        style: const TextStyle(height: 1.5),
      ),
    );
  }
}
