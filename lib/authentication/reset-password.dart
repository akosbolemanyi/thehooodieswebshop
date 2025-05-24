import 'package:android_studio_projects/utils/utils.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../providers/theme.provider.dart';
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight + 10),
            child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.only(top: 10),
                child: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  backgroundColor: Colors.transparent,
                  iconTheme: IconThemeData(color: Colors.black),
                  title: LocaleText(
                    'back',
                    style: GoogleFonts.cabin(fontWeight: FontWeight.bold),
                  ),
                ))),
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
                  LocaleText(
                    'password_email_received',
                    style: GoogleFonts.cabin(
                        fontWeight: FontWeight.bold, fontSize: 24),
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
                    decoration: InputDecoration(
                      isDense: true,
                    ),
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        (email != null && !EmailValidator.validate(email))
                            ? Locales.string(context, 'not_valid_email')
                            : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    icon: Icon(Icons.email, size: 32, color: Colors.red),
                    label: LocaleText(
                      'request_email',
                      style:
                          GoogleFonts.cabin(fontSize: 24, color: Colors.black),
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
      builder: (context) => Center(
        child: SpinKitDualRing(
          color: Colors.red,
          size: 40.0,
        ),
      ),
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Utils.showSnackBar('Reset-password email has been sent!', 'information');
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          child: AuthPage(),
        ),
      );
    } catch (error) {
      Utils.showSnackBar(
          '${Locales.string(context, 'reset_password_request_error')}\n${error.toString()}');
    }
  }
}
