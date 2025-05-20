import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/utils.dart';
import 'authentication.dart';
import '../menus/custom-bottom-menu.dart' as Footer;

/**
 * Dedicated page, where the user will be navigated to if the registered email isn't verified yet.
 */
class VerifyEmailPage extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      isEmailVerified = user.emailVerified;
    }

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      Utils.showSnackBar(
          'Verification email sent to this address: ${user.email}');

      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = false);
    } catch (error) {
      print('Email cannot be send again yet. Try again a bit later!');
    }
  }

  Future cancelVerification(BuildContext context) async {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => AuthPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? Footer.CustomBottomMenu(page: Footer.Page.HOME) //HiddenDrawer
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
                  icon: Icon(
                    Icons.email,
                    size: 32,
                    color: Colors.red,
                  ),
                  label: Text(
                    'Resend email',
                    style: GoogleFonts.cabin(color: Colors.black, fontSize: 24),
                  ),
                  onPressed: () => {
                    canResendEmail
                        ? sendVerificationEmail
                        : Utils.showSnackBar(
                            'Cannot resend email yet. Please, try again a few seconds later!')
                  },
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
                    cancelVerification(context);
                  },
                )
              ],
            ),
          ),
        );
}
