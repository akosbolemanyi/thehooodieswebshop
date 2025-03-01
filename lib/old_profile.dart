import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
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

    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              // UserImage(onFileChanged: (String imageUrl) {
              //   Image.network(pic!);
              // },),
              const SizedBox(height: 10),
              LocaleText(
                'signed_in_as',
                style: GoogleFonts.cabin(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                user.email!,
                style: GoogleFonts.cabin(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    icon: const Icon(Icons.arrow_back, size: 32, color: Colors.black),
                    label: LocaleText(
                      'sign_out',
                      style: GoogleFonts.cabin(
                        fontSize: 24,
                        color: Colors.black
                      ),
                    ),
                    onPressed: () {
                      // Sign Out
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const LoginApp()),
                      );
                    }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
