import 'package:android_studio_projects/authentication/email-verification.dart';
import 'package:android_studio_projects/authentication/reset-password.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import '../components/settings/language-settings.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/settings/theme-settings.dart';
import '../utils/utils.dart';

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
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.emailAddress,
              validator: (email) =>
                  (email != null && !EmailValidator.validate(email))
                      ? Locales.string(context, 'not_valid_email')
                      : null,
            ),
            const SizedBox(height: 30),
            LocaleText(
              'password',
              style:
                  GoogleFonts.cabin(color: Colors.grey.shade500, fontSize: 15),
            ),
            TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.next,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    size: 25,
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
              child: LocaleText('forgot_password',
                  style: GoogleFonts.cabin(color: Colors.purple.shade400)),
              onTap: () => Navigator.of(context).push(PageTransition(
                type: PageTransitionType.fade,
                child: ForgotPasswordPage(),
              )),
            ),
            const SizedBox(height: 12),
            RichText(
              text: TextSpan(
                  style: GoogleFonts.cabin(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 15),
                  text: Locales.string(context, 'no_account'),
                  children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignUp,
                        text: Locales.string(context, 'sign_up'),
                        style: GoogleFonts.cabin(color: Colors.purple.shade400))
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
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: const SettingScreen()));
              },
              child: const Icon(
                Icons.language_rounded,
                color: Colors.black,
              ),
            ),
            Expanded(child: Container()),
            FloatingActionButton(
              heroTag: "btn2",
              backgroundColor: Colors.red.shade400,
              onPressed: () => {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: const ThemePage()))
              },
              child: const Icon(
                Icons.lightbulb_outline,
                color: Colors.black,
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
        PageTransition(type: PageTransitionType.fade, child: VerifyEmailPage()),
      );
    } catch (error) {
      Utils.showSnackBar(Locales.string(context, 'invalid_credentials'));
    }
  }
}
