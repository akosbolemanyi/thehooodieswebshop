import 'package:android_studio_projects/provider/theme-changer.provider.dart';
import 'package:android_studio_projects/settings/language-settings.dart';
import 'package:android_studio_projects/settings/theme-settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nation = Locales.currentLocale(context)?.languageCode;
    final themeChanger = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: LocaleText(
          'menu_settings',
          style: GoogleFonts.cabin(
              fontWeight: FontWeight.bold, color: Colors.black),
        ),
        // backgroundColor: Colors.indigo.shade300,
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ThemePage(),
            )),
            title: const LocaleText('theme'),
            subtitle: themeChanger.themeMode == ThemeMode.dark
                ? LocaleText('dark_mode')
                : LocaleText('light_mode'),
            trailing: themeChanger.themeMode == ThemeMode.dark
                ? Icon(Icons.nightlight)
                : Icon(Icons.sunny),
            splashColor: Colors.indigo.shade200,
          ),
          ListTile(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SettingScreen(),
            )),
            title: const LocaleText("language"),
            subtitle: nation == 'hu'
                ? LocaleText('hungarian')
                : nation == 'en'
                    ? LocaleText('english')
                    : LocaleText('german'),
            trailing: nation == 'hu'
                ? Image.asset('icons/flags/png100px/hu.png',
                    package: 'country_icons', width: 25)
                : nation == 'en'
                    ? Image.asset('icons/flags/png100px/us.png',
                        package: 'country_icons', width: 25)
                    : Image.asset('icons/flags/png100px/de.png',
                        package: 'country_icons', width: 25),
            splashColor: Colors.indigo.shade200,
          ),
        ],
      ),
    );
  }
}
