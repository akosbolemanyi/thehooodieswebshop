import 'package:android_studio_projects/components/settings/theme-settings.dart';
import 'package:android_studio_projects/providers/theme.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../menus/custom-side-menu.dart' as Sidebar;
import 'language-settings.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nation = Locales.currentLocale(context)?.languageCode;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      drawer: Sidebar.CustomSideMenu(),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 15),
          child: Container(
            color: Colors.red,
            padding: EdgeInsets.only(top: 15),
            child: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              title: LocaleText(
                'menu_settings',
                style: GoogleFonts.cabin(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
              // backgroundColor: Colors.indigo.shade300,
            ),
          )),
      body: Column(
        children: [
          ListTile(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ThemePage(),
            )),
            title: const LocaleText('theme'),
            subtitle: themeProvider.themeMode == ThemeMode.dark
                ? LocaleText('dark_mode')
                : LocaleText('light_mode'),
            trailing: themeProvider.themeMode == ThemeMode.dark
                ? Icon(Icons.nightlight)
                : Icon(Icons.sunny),
            splashColor: Colors.indigo.shade200,
          ),
          ListTile(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SettingScreen(),
            )),
            title: const LocaleText("language"),
            subtitle: () {
              switch (nation) {
                case 'hu':
                  return const LocaleText('hungarian');
                case 'en':
                  return const LocaleText('english');
                case 'de':
                  return const LocaleText('german');
                case 'fr':
                  return const LocaleText('french');
                case 'es':
                  return const LocaleText('spanish');
                case 'pt':
                  return const LocaleText('portugal');
                case 'it':
                  return const LocaleText('italian');
                default:
                  return const LocaleText('english');
              }
            }(),
            trailing: () {
              switch (nation) {
                case 'hu':
                  return Image.asset(
                    'icons/flags/png100px/hu.png',
                    package: 'country_icons',
                    width: 25,
                  );
                case 'en':
                  return Image.asset(
                    'icons/flags/png100px/us.png',
                    package: 'country_icons',
                    width: 25,
                  );
                case 'de':
                  return Image.asset(
                    'icons/flags/png100px/de.png',
                    package: 'country_icons',
                    width: 25,
                  );
                case 'fr':
                  return Image.asset(
                    'icons/flags/png100px/fr.png',
                    package: 'country_icons',
                    width: 25,
                  );
                case 'es':
                  return Image.asset(
                    'icons/flags/png100px/es.png',
                    package: 'country_icons',
                    width: 25,
                  );
                case 'pt':
                  return Image.asset(
                    'icons/flags/png100px/pt.png',
                    package: 'country_icons',
                    width: 25,
                  );
                case 'it':
                  return Image.asset(
                    'icons/flags/png100px/it.png',
                    package: 'country_icons',
                    width: 25,
                  );
                default:
                  return Image.asset(
                    'icons/flags/png100px/us.png',
                    package: 'country_icons',
                    width: 25,
                  );
              }
            }(),
            splashColor: Colors.indigo.shade200,
          ),
        ],
      ),
    );
  }
}
