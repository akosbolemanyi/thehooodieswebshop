import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/settings/language-settings.dart';
import '../components/settings/theme-settings.dart';
import '../utils/utils.dart';
import 'package:intl/intl.dart';

import 'email-verification.dart';

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
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
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
                'lastname',
                style: GoogleFonts.cabin(
                    color: Colors.grey.shade500, fontSize: 15),
              ),
              TextFormField(
                controller: lastnameController,
                textInputAction: TextInputAction.done,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => (value != null && value.length == 0)
                    ? Locales.string(context, 'field_cannot_be_empty')
                    : null,
              ),
              const SizedBox(height: 30),
              LocaleText(
                'firstname',
                style: GoogleFonts.cabin(
                    color: Colors.grey.shade500, fontSize: 15),
              ),
              TextFormField(
                controller: firstnameController,
                textInputAction: TextInputAction.done,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => (value != null && value.length == 0)
                    ? Locales.string(context, 'field_cannot_be_empty')
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
                validator: (value) => (value == null || value.isEmpty)
                    ? Locales.string(context, 'field_cannot_be_empty')
                    : null,
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
                validator: (email) =>
                    (email != null && !EmailValidator.validate(email))
                        ? Locales.string(context, 'not_valid_email')
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
                validator: (value) => (value != null && value.length < 6)
                    ? Locales.string(context, 'minimum_6')
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
                validator: (value) => (value == null || value.isEmpty)
                    ? Locales.string(context, 'field_cannot_be_empty')
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
                onPressed: () async => {signUp(context)},
              ),
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                    style: GoogleFonts.cabin(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 15),
                    text: Locales.string(context, 'have_account'),
                    children: [
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = widget.onClickedSignIn,
                          text: Locales.string(context, 'sign_in'),
                          style:
                              GoogleFonts.cabin(color: Colors.purple.shade400))
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
                color: Colors.black,
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
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future signUp(BuildContext context) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = FirebaseAuth.instance.currentUser;

      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'firstname': firstnameController.text.trim(),
        'lastname': lastnameController.text.trim(),
        'nickname': nicknameController.text.trim(),
        'birthday': birthDateController.text.trim(),
        'email': emailController.text.trim(),
        'imageUrl': imageUrl,
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VerifyEmailPage()),
      );
    } on FirebaseAuthException catch (error) {
      Utils.showSnackBar(
          '${Locales.string(context, 'sign_up_error')}\n${error.message.toString()}');
    } catch (error) {
      Utils.showSnackBar(Locales.string(context, 'error_is_on_our_side'));
      print(error.toString());
    }
  }
}
