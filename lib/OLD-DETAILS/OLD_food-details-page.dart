import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../OLD-LOCAL-CONFIGURATIONS/OLD_hoodie_item_tile.dart';
import '../constants.dart';
import 'OLD_add_to_cart.dart';
import 'OLD_color_and_size.dart';
import 'OLD_counter_with_fav_btn.dart';
import 'OLD_description.dart';
import 'OLD_product_title_with_image.dart';

class OldHoodieDetailsPage extends StatelessWidget {
  final OldHoodieItemTile hoodie;

  const OldHoodieDetailsPage({super.key, required this.hoodie});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: hoodie.color,
      appBar: AppBar(
        backgroundColor: hoodie.color,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset('assets/icons/back.svg',
          color: Colors.white,
        ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          IconButton(
            icon: SvgPicture.asset('assets/icons/search.svg'),
            onPressed: () {},
          ),
          IconButton(
            icon: SvgPicture.asset('assets/icons/cart.svg'),
            onPressed: () {},
          ),
          SizedBox(width: kDefaultPaddin / 2)
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.3),
                    padding: EdgeInsets.only(
                      top: size.height * 0.12,
                      left: kDefaultPaddin,
                      right: kDefaultPaddin,
                    ),
                    // height: 500,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Column(
                      children: <Widget>[
                        OldColorAndSize(hoodie: hoodie),
                        const SizedBox(height: kDefaultPaddin / 2),
                        OldDescription(hoodie: hoodie),
                        const SizedBox(height: kDefaultPaddin / 2),
                        const OldCounterWithFavBtn(),
                        const SizedBox(height: kDefaultPaddin / 2),
                        OldAddToCart(hoodie: hoodie)
                      ],
                    ),
                  ),
                  OldProductTitleWithImage(hoodie: hoodie)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}