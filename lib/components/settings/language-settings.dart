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
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 10),
          child: Container(
            color: Colors.red,
            padding: EdgeInsets.only(top: 10),
            child: AppBar(
              leading: IconButton(
                icon:
                    Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              iconTheme: IconThemeData(color: Colors.black),
              title: LocaleText(
                'language_what',
                style: GoogleFonts.cabin(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          )),
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
              title: Text(
                "Magyar",
                style: GoogleFonts.cabin(
                  fontSize: 20,
                ),
              ),
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
              title: Text(
                "English",
                style: GoogleFonts.cabin(
                  fontSize: 20,
                ),
              ),
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
              title: Text(
                "Deutsch",
                style: GoogleFonts.cabin(
                  fontSize: 20,
                ),
              ),
              activeColor: Colors.red,
            ),
            RadioListTile(
              value: 'es',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value as String;
                });
                Locales.change(context, value!);
              },
              title: Text(
                "Español",
                style: GoogleFonts.cabin(
                  fontSize: 20,
                ),
              ),
              activeColor: Colors.red,
            ),
            RadioListTile(
              value: 'fr',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value as String;
                });
                Locales.change(context, value!);
              },
              title: Text(
                "Français",
                style: GoogleFonts.cabin(
                  fontSize: 20,
                ),
              ),
              activeColor: Colors.red,
            ),
            RadioListTile(
              value: 'pt',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value as String;
                });
                Locales.change(context, value!);
              },
              title: Text(
                "Português",
                style: GoogleFonts.cabin(
                  fontSize: 20,
                ),
              ),
              activeColor: Colors.red,
            ),
            RadioListTile(
              value: 'it',
              groupValue: selectedLanguage,
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value as String;
                });
                Locales.change(context, value!);
              },
              title: Text(
                "Italiano",
                style: GoogleFonts.cabin(
                  fontSize: 20,
                ),
              ),
              activeColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
