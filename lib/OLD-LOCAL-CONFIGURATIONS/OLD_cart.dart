import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../components/navigation_drawer.dart' as sidebar;
import 'OLD_cart_model.dart';

class OldCartPage extends StatelessWidget {
  const OldCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nation = Locales.currentLocale(context)?.languageCode;
    return Scaffold(
        drawer: const sidebar.NavigationDrawer(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: LocaleText(
            'menu_cart',
            style: GoogleFonts.cabin(
                fontWeight: FontWeight.bold,
                color: Colors.black
            ),
          ),
          // backgroundColor: Colors.green,
        ),
        body: Consumer<OldCartModel>(builder: (context, value, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: value.cartItemsHuf.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            leading: Image.asset(
                              value.cartItemsHuf[index][2],
                              cacheHeight: 500,
                            ),
                            title: nation == 'hu' ? Text(value.cartItemsHuf[index][0], style: TextStyle(color: Colors.black)) : nation == 'en' ? Text(value.cartItemsDollar[index][0], style: TextStyle(color: Colors.black)) : Text(value.cartItemsEuro[index][0], style: TextStyle(color: Colors.black)),
                            subtitle: nation == 'hu' ?
                            Text("${value.cartItemsHuf[index][1]} Ft", style: TextStyle(color: Colors.black)) :
                            nation == 'en' ?
                            Text("\$${value.cartItemsDollar[index][1]}", style: TextStyle(color: Colors.black)) :
                            Text("\€ ${value.cartItemsEuro[index][1]}", style: TextStyle(color: Colors.black)),
                            trailing: IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.red,),
                                onPressed: () => Provider.of<OldCartModel>(context, listen: false)
                                    .removeItem(index)
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(36.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.only(top: 12, bottom: 12, left: 24, right: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LocaleText(
                            'total_price',
                            style: GoogleFonts.cabin(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            nation == 'hu' ?
                            "${value.totalPriceHuf()} Ft" :
                                nation == 'en' ?
                                "\$${value.totalPriceDollar()}" :
                                   "\€ ${value.totalPriceEuro()}",
                            style: GoogleFonts.cabin(
                                color: Colors.white,
                                fontSize: 18
                            ),
                          )
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green.shade100, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            LocaleText(
                              'pay_now',
                              style: GoogleFonts.cabin(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.green.shade100,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
        )
    );
  }
}

