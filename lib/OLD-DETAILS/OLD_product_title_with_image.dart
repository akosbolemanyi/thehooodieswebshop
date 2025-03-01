import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../OLD-LOCAL-CONFIGURATIONS/OLD_hoodie_item_tile.dart';


class OldProductTitleWithImage extends StatelessWidget {
  const OldProductTitleWithImage({super.key, required this.hoodie});

  final OldHoodieItemTile hoodie;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            "Aristocratic Hand Bag",
            style: TextStyle(color: Colors.white),
          ),
          Text(
            hoodie.itemName,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: kDefaultPaddin),
          Row(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(text: "Price\n"),
                    TextSpan(
                      text: "\$${hoodie.itemPrice}",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: kDefaultPaddin),
              Expanded(
                child: Hero(
                  tag: 1,
                  child: Image.asset(
                    hoodie.imagePath,
                    height: 300,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
