import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../OLD-LOCAL-CONFIGURATIONS/OLD_hoodie_item_tile.dart';

class OldDescription extends StatelessWidget {
  const OldDescription({super.key, required this.hoodie});

  final OldHoodieItemTile hoodie;
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
