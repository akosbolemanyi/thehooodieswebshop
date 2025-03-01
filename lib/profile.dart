import 'dart:io';
import 'package:android_studio_projects/components/custom-navigation-bar.dart';
import 'package:android_studio_projects/providers/theme_changer_provider.dart';
import 'package:android_studio_projects/shipping-address.dart';
import 'package:android_studio_projects/update-profile-page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'authentication/login.dart';
import 'components/navigation_drawer.dart' as sidebar;
import 'image_handler/user_image.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _uid = FirebaseAuth.instance.currentUser?.uid;
  File? imageXFile;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final themeChanger = Provider.of<ThemeChanger>(context);

    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(),
      drawer: const sidebar.NavigationDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: LocaleText(
          'menu_profile',
          style: GoogleFonts.cabin(
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
        ),
        // backgroundColor: Colors.indigo.shade300,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 25),
              GestureDetector(
                onTap: ()
                {
                  //_showImageDialog
                },
                child: UserImage(
                    onFileChanged: (imageUrl) {
                      setState(() {
                        FirebaseAuth.instance.currentUser!.updatePhotoURL(imageUrl);
                        FirebaseFirestore.instance.collection('users').doc(_uid).update({
                          "imageUrl": imageUrl
                        });
                      });
                    }
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Test Name',
                style: GoogleFonts.cabin(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                user.email!,
                style: GoogleFonts.abel(fontSize: 25),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return EditProfilePage();
                          }
                      ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow, side: BorderSide.none, shape: const StadiumBorder(),
                  ),
                  child: Text('Edit profile', style: GoogleFonts.akayaKanadaka(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ),
              const SizedBox(height: 25),
              const Divider(),
              const SizedBox(height: 25),

              // MENU
              ProfileMenuWidget(title: 'Profile details', icon: Icons.details, onPress: () =>
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ProfileDetailsPage();
                      }
                  ),
                  ),),
              ProfileMenuWidget(
                  title: 'Shipping address',
                  icon: Icons.local_shipping,
                  onPress: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          // TODO - A fizetés utáni oldal mezői nem kötelezőek. Nézd meg miért, avagy hogyan kell ezt megvalósítani!
                          return ShippingAddressPage();
                        }
                    ));
                  }),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(title: 'Logout', icon: Icons.logout_rounded, textColor: Colors.red, endIcon: false, onPress: () {}),
            ],
          )
        )
      )
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
}): super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    var iconColor = textColor != null ? textColor : themeChanger.themeMode == ThemeMode.dark ? Colors.yellow : Colors.blue;
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.blue.withOpacity(0.1),
        ),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title),
      trailing: endIcon ? Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: const Icon(Icons.arrow_circle_right, size: 18.0, color: Colors.grey),
      ): null,
    );
  }
}


















