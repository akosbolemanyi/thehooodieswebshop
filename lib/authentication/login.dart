import 'package:android_studio_projects/authentication/email-verification.dart';
import 'package:android_studio_projects/authentication/reset-password.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/settings/language-settings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/settings/theme-settings.dart';
import '../utils/utils.dart';
import '../menus/custom-bottom-menu.dart' as Footer;

/**
 * This is the login page, where with an email and password combination, the user can sign in.
 */
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
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VerifyEmailPage()),
      );
    } catch (error) {
      Utils.showSnackBar(error.toString());
    }
  }
}
