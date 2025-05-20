import 'package:android_studio_projects/utils/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';

import 'authentication.dart';

/**
 * From authentication, when the user wants to change the account's password, the application will navigate here.
 */
class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nation = Locales.currentLocale(context)?.languageCode;
    return Scaffold(
        appBar: AppBar(
          title: LocaleText(
            'verify_email',
            style: GoogleFonts.cabin(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hooodies!",
                    style: GoogleFonts.lobster(fontSize: 50, color: Colors.red),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Receive an email to reset your password!',
                    style: GoogleFonts.cabin(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  LocaleText(
                    'email',
                    style: GoogleFonts.cabin(
                        color: Colors.grey.shade500, fontSize: 15),
                  ),
                  TextFormField(
                    controller: emailController,
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) => (email != null &&
                            !EmailValidator.validate(email) &&
                            nation == 'hu')
                        ? "Érvényes e-mail címet adjon meg."
                        : (email != null &&
                                !EmailValidator.validate(email) &&
                                nation == 'en')
                            ? "Enter a valid email."
                            : (email != null &&
                                    !EmailValidator.validate(email) &&
                                    nation == 'de')
                                ? "Geben Sie eine gültige E-Mail-Adresse ein."
                                : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    icon: Icon(Icons.email, size: 32, color: Colors.red),
                    label: Text(
                      'Resend email',
                      style:
                          GoogleFonts.cabin(color: Colors.black, fontSize: 24),
                    ),
                    onPressed: resetPassword,
                  ),
                ],
              )),
        ));
  }

  Future resetPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(child: CircularProgressIndicator(color: Colors.red)),
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Utils.showSnackBar('Reset-password email has been sent!');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AuthPage(),
        ),
      );
    } catch (error) {
      Utils.showSnackBar(error.toString());
    }
  }
}
