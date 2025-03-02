import 'dart:async';
import 'package:android_studio_projects/menu/custom-bottom-navigation-bar.dart'
    as OwnBar;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/utils.dart';
import 'auth.dart';

class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;
  Timer? deletionTimer;

  @override
  void initState() {
    super.initState();

    // Check if the email is verified
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      // Start the 10-second deletion timer
      deletionTimer = Timer(Duration(seconds: 60), checkAndDeleteUser);

      // Periodically check for email verification
      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  Future checkAndDeleteUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !isEmailVerified) {
      try {
        // Delete user from Firebase Auth
        await user.delete();
        Utils.showSnackBar('User deleted due to unverified email.');

        // Optionally delete the user's data from Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();

        // Navigate back to the authentication page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => AuthPage(),
          ),
        );
      } catch (error) {
        Utils.showSnackBar('Error deleting user: $error');
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    deletionTimer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
      deletionTimer?.cancel();
      Utils.showSnackBar('Email successfully verified!');
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      // Utils.showSnackBar('Verification email sent to ${user.email}.');

      // Wait for 5 seconds
      await Future.delayed(Duration(seconds: 5));
    } catch (error) {
      print('Email cannot be send again yet. Try again in a minute!');
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? OwnBar.CustomBottomNavigationBar(page: OwnBar.Page.HOME) //HiddenDrawer
      : Scaffold(
          appBar: AppBar(
            title: Text(
              'Verify Email',
              style: GoogleFonts.cabin(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hooodies!",
                  style: GoogleFonts.lobster(fontSize: 50, color: Colors.red),
                ),
                const SizedBox(height: 24),
                Text(
                  'A verification mail has been sent to your email account.',
                  style: GoogleFonts.cabin(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  icon: Icon(Icons.email, size: 32),
                  label: Text(
                    'Resend email',
                    style: GoogleFonts.cabin(color: Colors.black, fontSize: 24),
                  ),
                  onPressed: sendVerificationEmail,
                ),
                const SizedBox(height: 8),
                TextButton(
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.cabin(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  onPressed: () {
                    checkAndDeleteUser();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AuthPage(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        );
}
