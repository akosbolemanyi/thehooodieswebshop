import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import '../settings/language-settings.dart';
import '../settings/theme-settings.dart';
import '../utils/utils.dart';
import 'package:intl/intl.dart';

class SignUpWidget extends StatefulWidget {
  final VoidCallback onClickedSignIn;

  const SignUpWidget({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  _SignUpWidgetState createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final nicknameController = TextEditingController();
  final birthDateController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  String imageUrl = '';

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
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //----------------------------------------------------------------------------------------------------
              const SizedBox(height: 40),
              Text(
                "Hooodies!",
                style: GoogleFonts.lobster(fontSize: 50, color: Colors.red),
              ),
              LocaleText(
                'sign_up_motto',
                textAlign: TextAlign.center,
                style: GoogleFonts.cabin(
                    fontSize: 32, fontWeight: FontWeight.bold),
              ),
              //----------------------------------------------------------------------------------------------------
              const SizedBox(height: 40),
              LocaleText(
                'firstname',
                style: GoogleFonts.cabin(
                    color: Colors.grey.shade500, fontSize: 15),
              ),
              TextFormField(
                controller: firstNameController,
                textInputAction: TextInputAction.done,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => (value != null &&
                        nation == 'hu' &&
                        value.length == 0)
                    ? "A mező nem lehet üres."
                    : (value != null && nation == 'en' && value.length == 0)
                        ? "Field cannot be empty."
                        : (value != null && nation == 'de' && value.length == 0)
                            ? "Das Feld darf nicht leer sein."
                            : null,
              ),
              const SizedBox(height: 30),
              LocaleText(
                'lastname',
                style: GoogleFonts.cabin(
                    color: Colors.grey.shade500, fontSize: 15),
              ),
              TextFormField(
                controller: lastNameController,
                textInputAction: TextInputAction.done,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => (value != null &&
                        nation == 'hu' &&
                        value.length == 0)
                    ? "A mező nem lehet üres."
                    : (value != null && nation == 'en' && value.length == 0)
                        ? "Field cannot be empty."
                        : (value != null && nation == 'de' && value.length == 0)
                            ? "Das Feld darf nicht leer sein."
                            : null,
              ),
              const SizedBox(height: 30),
              LocaleText(
                'nickname_optional',
                style: GoogleFonts.cabin(
                    color: Colors.grey.shade500, fontSize: 15),
              ),
              TextFormField(
                controller: nicknameController,
                textInputAction: TextInputAction.done,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 30),
              LocaleText(
                'birthday',
                style: GoogleFonts.cabin(
                    color: Colors.grey.shade500, fontSize: 15),
              ),
              TextFormField(
                controller: birthDateController,
                readOnly: true,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                    locale: Locale(nation!),
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      birthDateController.text = formattedDate;
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    if (nation == 'hu') return "A születési dátum kötelező.";
                    if (nation == 'en') return "Birth date is required.";
                    if (nation == 'de') return "Geburtsdatum ist erforderlich.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              LocaleText(
                'email',
                style: GoogleFonts.cabin(
                    color: Colors.grey.shade500, fontSize: 15),
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
                style: GoogleFonts.cabin(
                    color: Colors.grey.shade500, fontSize: 15),
              ),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                obscureText: !isPasswordVisible,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => (value != null &&
                        !EmailValidator.validate(value) &&
                        nation == 'hu' &&
                        value.length < 6)
                    ? "Adjon meg minimum 6 karaktert."
                    : (value != null &&
                            !EmailValidator.validate(value) &&
                            nation == 'en' &&
                            value.length < 6)
                        ? "Enter minimum 6 characters."
                        : (value != null &&
                                !EmailValidator.validate(value) &&
                                nation == 'de' &&
                                value.length < 6)
                            ? "Geben Sie mindestens 6 Zeichen ein."
                            : null,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),
              LocaleText(
                'password_again',
                style: GoogleFonts.cabin(
                    color: Colors.grey.shade500, fontSize: 15),
              ),
              TextFormField(
                controller: confirmPasswordController,
                textInputAction: TextInputAction.done,
                obscureText: !isPasswordVisible,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    if (nation == 'hu') return "A mező nem lehet üres.";
                    if (nation == 'en') return "Field cannot be empty.";
                    if (nation == 'de') return "Das Feld darf nicht leer sein.";
                  }
                  if (value != passwordController.text) {
                    if (nation == 'hu') return "A jelszavak nem egyeznek.";
                    if (nation == 'en') return "Passwords do not match.";
                    if (nation == 'de')
                      return "Die Passwörter stimmen nicht überein.";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  minimumSize: const Size.fromHeight(50),
                ),
                icon:
                    const Icon(Icons.lock_open, size: 32, color: Colors.black),
                label: LocaleText(
                  'sign_up',
                  style: GoogleFonts.cabin(fontSize: 24, color: Colors.black),
                ),
                onPressed: signUp,
              ),
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                    style: GoogleFonts.cabin(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 15),
                    text: nation == 'hu'
                        ? "Van már fiókod?  "
                        : nation == 'en'
                            ? "Already have an account?  "
                            : "Hast du schon ein Konto?  ",
                    children: [
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickedSignIn,
                          text: nation == 'hu'
                              ? "Bejelentkezés"
                              : nation == 'en'
                                  ? "Sign in"
                                  : "Anmeldung",
                          style: GoogleFonts.cabin(
                              decoration: TextDecoration.underline,
                              color: Colors.purple))
                    ]),
              ),
              const SizedBox(height: 100),
            ],
          ),
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

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      // Felhasználó létrehozása a Firebase Authentication rendszerében
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Verifikációs email elküldése
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      // Az új felhasználó adatainak mentése a Firestore-ba
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'nickname': nicknameController.text.trim(),
        'birthday': birthDateController.text.trim(),
        'email': emailController.text.trim(),
        'imageUrl': imageUrl,
      });

      Utils.showSnackBar('Verification email sent. Please verify your email.');
    } on FirebaseAuthException catch (error) {
      // Hiba esetén megjelenítjük az üzenetet
      Utils.showSnackBar(error.message ?? 'An error occurred');
    } catch (error) {
      Utils.showSnackBar('An unexpected error occurred: $error');
      print(error.toString());
    }
  }
}
