import 'package:android_studio_projects/authentication/reset-password.dart';
import 'package:android_studio_projects/components/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../settings/language-settings.dart';
import '../settings/theme-settings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/utils.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nation = Locales.currentLocale(context)?.languageCode;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 130),
            Text(
              "Hooodies!",
              style: GoogleFonts.lobster(fontSize: 50, color: Colors.red),
            ),
            const SizedBox(height: 10),
            LocaleText(
              'sign_in_motto',
              textAlign: TextAlign.center,
              style: GoogleFonts.cabin(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            LocaleText(
              'email',
              style:
                  GoogleFonts.cabin(color: Colors.grey.shade500, fontSize: 15),
            ),
            TextFormField(
              controller: emailController,
              cursorColor: Colors.black,
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.emailAddress,
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
            const SizedBox(height: 30),
            LocaleText(
              'password',
              style:
                  GoogleFonts.cabin(color: Colors.grey.shade500, fontSize: 15),
            ),
            TextField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.grey.shade300,
              ),
              icon: const Icon(Icons.lock_open, size: 32, color: Colors.black),
              label: LocaleText(
                'sign_in',
                style: GoogleFonts.cabin(fontSize: 24, color: Colors.black),
              ),
              onPressed: signIn,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              child: Text('Forgot password?',
                  style: GoogleFonts.cabin(
                      decoration: TextDecoration.underline,
                      color: Colors.purple)),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ForgotPasswordPage(),
              )),
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                  style: GoogleFonts.cabin(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 15),
                  text: nation == 'hu'
                      ? "Nincs még fiókod?  "
                      : nation == 'en'
                          ? "Don't have an account?  "
                          : "Hast du noch kein Konto?  ",
                  children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignUp,
                        text: nation == 'hu'
                            ? "Regisztrálj!"
                            : nation == 'en'
                                ? "Sign up!"
                                : "Register!",
                        style: GoogleFonts.cabin(
                            decoration: TextDecoration.underline,
                            color: Colors.purple))
                  ]),
            )
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "btn1",
              backgroundColor: Colors.red.shade400,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SettingScreen()));
              },
              child: const Icon(
                Icons.language_rounded,
              ),
            ),
            Expanded(child: Container()),
            FloatingActionButton(
              heroTag: "btn2",
              backgroundColor: Colors.red.shade400,
              onPressed: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ThemePage()))
              },
              child: const Icon(
                Icons.lightbulb_outline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future signIn() async {
    try {
      // Bejelentkezés a Firebase segítségével
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = userCredential.user;

      if (user != null) {
        if (!user.emailVerified) {
          // Ha az email nincs verifikálva, küldjön egy ellenőrző emailt
          await user.sendEmailVerification();

          // Kiírunk egy üzenetet a felhasználónak
          Utils.showSnackBar(
              "Email verification sent! Please verify your email.");

          // Ütemezze a felhasználó törlését 24 órán belül
          Future.delayed(const Duration(hours: 24), () async {
            try {
              // Ellenőrizzük, hogy az email még mindig nincs verifikálva
              final currentUser = FirebaseAuth.instance.currentUser;
              await currentUser?.reload();
              if (currentUser != null && !currentUser.emailVerified) {
                // Törlés a Firebase Authentication-ből
                await currentUser.delete();

                // Törlés a Firestore-ból (ha van mentett adata)
                final userDoc = FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid);
                await userDoc.delete();

                print("User deleted after 24 hours due to unverified email.");
              }
            } catch (e) {
              print("Error during user deletion: $e");
            }
          });
        } else {
          // Ha az email verifikálva van, menjen a főoldalra
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => HomePage()),
          );
        }
      }
    } catch (error) {
      Utils.showSnackBar(error.toString());
    }
  }
}
