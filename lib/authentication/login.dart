import 'dart:io';
import 'package:android_studio_projects/constants.dart';
import 'package:android_studio_projects/provider/favourites.provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import '../provider/cart.provider.dart';
import '../provider/theme-changer.provider.dart';
import '../provider/theme.provider.dart';
import '../utils/utils.dart';
import 'package:flutter/services.dart';

import 'auth.dart';
import 'email-verification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Locales.init(['hu', 'en', 'de']);
  Stripe.publishableKey = stripePublishableKey;

  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyDcXj8EWWB_rngaDOzZIhC7QLnguyvAHzE',
              appId: '1:331949612021:android:8b0ee595f4d7d1915e1ebc',
              messagingSenderId: '331949612021',
              projectId: 'myfirstmobileapp-c8750',
              storageBucket: "myfirstmobileapp-c8750.appspot.com"))
      : await Firebase.initializeApp();

  String? userId = await FirebaseAuth.instance.currentUser?.uid;
  var userData =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  ThemeMode themeMode =
      userData['themeMode'] == 'dark' ? ThemeMode.dark : ThemeMode.light;
  String languageCode = userData['languageCode'] ?? 'hu';
  print('This is the theme-mode: $themeMode');
  print('This is the language-code: $languageCode');
  runApp(
    DevicePreview(
        enabled: false,
        builder: (context) =>
            MyApp(themeMode: themeMode, languageCode: languageCode)),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final ThemeMode themeMode;
  final String languageCode;

  const MyApp({super.key, required this.themeMode, required this.languageCode});
  static const String title = 'Firebase Auth';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => ThemeChanger()),
          ChangeNotifierProvider(create: (_) => FavouriteProvider()),
          ChangeNotifierProvider(create: (_) => CartModel()),
        ],
        child: Builder(builder: (BuildContext context) {
          return LocaleBuilder(
            builder: (locale) {
              var userLocale = Locale(languageCode);
              return ChangeNotifierProvider(
                create: (context) => CartModel()..fetchShopItems(),
                child: MaterialApp(
                  title: 'Hooodies!',
                  localizationsDelegates: Locales.delegates,
                  supportedLocales: Locales.supportedLocales,
                  locale: userLocale ?? locale,
                  scaffoldMessengerKey: Utils.messengerKey,
                  navigatorKey: navigatorKey,
                  debugShowCheckedModeBanner: false,
                  themeMode: themeMode,
                  theme: ThemeData(
                    brightness: Brightness.light,
                    primarySwatch: Colors.red,
                    primaryColorLight: Colors.red,
                    appBarTheme: AppBarTheme(backgroundColor: Colors.red),
                  ),
                  darkTheme: ThemeData(
                    brightness: Brightness.dark,
                    appBarTheme: AppBarTheme(
                      backgroundColor: Colors.red,
                    ),
                  ),
                  home: const LoginApp(),
                ),
              );
            },
          );
        }));
  }
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Mayday!"));
            } else if (snapshot.hasData) {
              return VerifyEmailPage();
            } else {
              return AuthPage();
            }
          }),
    );
  }
}
