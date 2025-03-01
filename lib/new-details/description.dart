import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../components/SAVE-hoodie_item_tile.dart';

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
