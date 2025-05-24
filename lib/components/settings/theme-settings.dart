import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/theme.provider.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
                'theme',
                style: GoogleFonts.cabin(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RadioListTile<ThemeMode>(
              title: LocaleText(
                'light_mode',
                style: GoogleFonts.cabin(
                  fontSize: 20,
                ),
              ),
              value: ThemeMode.light,
              groupValue: themeProvider.themeMode,
              onChanged: themeProvider.setTheme,
              activeColor: Colors.red,
            ),
            RadioListTile<ThemeMode>(
              title: LocaleText(
                'dark_mode',
                style: GoogleFonts.cabin(
                  fontSize: 20,
                ),
              ),
              value: ThemeMode.dark,
              groupValue: themeProvider.themeMode,
              onChanged: themeProvider.setTheme,
              activeColor: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
