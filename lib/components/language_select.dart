import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {


  @override
  Widget build(BuildContext context) {
   String? selectedLanguage = Locales.currentLocale(context)?.languageCode;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: LocaleText(
          'language_what',
          style: GoogleFonts.cabin(
            fontWeight: FontWeight.bold,
            color: Colors.black
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: Column(
          children: [
            RadioListTile(
              value: 'hu',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value as String;
                });
                Locales.change(context, value!);
              },
              title: const Text("Magyar"),
              activeColor: Colors.red,
            ),
            RadioListTile(
              value: 'en',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value as String;
                });
                Locales.change(context, value!);
              },
              title: const Text("English"),
              activeColor: Colors.red,
            ),
            RadioListTile(
              value: 'de',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value as String;
                });
                Locales.change(context, value!);
              },
              title: const Text("Deutsch"),
              activeColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
