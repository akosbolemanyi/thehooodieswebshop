import 'dart:io';
import 'package:android_studio_projects/components/profile/shipping-address-form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../authentication/authentication.dart';
import '../../image-management/user-image.dart';
import '../../providers/cart.provider.dart';
import '../../providers/favourites.provider.dart';
import '../../providers/theme.provider.dart';
import 'profile-form.dart';
import '../../menus/custom-side-menu.dart' as Sidebar;

/**
 * In this page, the user can see and set its data, including the profile picture.
 */

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _uid = FirebaseAuth.instance.currentUser?.uid;
  File? imageXFile;

  Future logOut(BuildContext context) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final favouritesProvider =
        Provider.of<FavouritesProvider>(context, listen: false);
    FirebaseAuth.instance.signOut();
    cartProvider.cartItems = [];
    favouritesProvider.favourites = [];
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AuthPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        drawer: Sidebar.CustomSideMenu(),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight + 15),
            child: Container(
              color: Colors.red,
              padding: EdgeInsets.only(top: 15),
              child: AppBar(
                iconTheme: IconThemeData(color: Colors.black),
                title: LocaleText(
                  'menu_profile',
                  style: GoogleFonts.cabin(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                // backgroundColor: Colors.indigo.shade300,
              ),
            )),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 3.0,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Colors.white
                                : Colors.black,
                          )),
                      child: UserImage(onFileChanged: (imageUrl) {
                        setState(() {
                          FirebaseAuth.instance.currentUser!
                              .updatePhotoURL(imageUrl);
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(_uid)
                              .update({"imageUrl": imageUrl});
                        });
                      }),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.only(left: 45.0, right: 45.0),
                      child: Divider(
                        thickness: 1.0,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      textAlign: TextAlign.center,
                      "Bolemányi Ákos",
                      style: GoogleFonts.lobster(
                          fontSize: 35, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      textAlign: TextAlign.center,
                      user.email!,
                      style: GoogleFonts.cabin(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 20),
                    // MENU
                    ProfileMenuItem(
                      title: 'Profile details',
                      icon: Icons.account_circle_rounded,
                      onPress: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return ProfileForm(isReadOnly: true);
                        }),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    ProfileMenuItem(
                        title: 'Shipping address',
                        icon: Icons.local_shipping,
                        onPress: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ShippingAddressForm();
                          }));
                        }),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    ProfileMenuItem(
                        title: 'Logout',
                        icon: Icons.logout_rounded,
                        textColor: Colors.red,
                        endIcon: false,
                        onPress: () {
                          logOut(context);
                        }),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                  ],
                ))));
  }
}

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    var iconColor = textColor != null
        ? textColor
        : themeProvider.themeMode == ThemeMode.dark
            ? Colors.yellow
            : Colors.blue.shade700;
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title,
          style: GoogleFonts.cabin(
              fontWeight: FontWeight.w400,
              fontSize: 17,
              color: textColor ??
                  (themeProvider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black))),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(Icons.arrow_forward_ios_outlined,
                  size: 18.0, color: Colors.grey),
            )
          : null,
    );
  }
}
