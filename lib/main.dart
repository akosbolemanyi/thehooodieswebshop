import 'dart:io';
import 'package:android_studio_projects/providers/cart.provider.dart';
import 'package:android_studio_projects/providers/favourites.provider.dart';
import 'package:android_studio_projects/providers/grid-layout.provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'providers/theme.provider.dart';
import 'providers/theme-colour.provider.dart';
import 'utils/utils.dart';
import 'package:flutter/services.dart';
import 'authentication/authentication.dart';
import 'authentication/email-verification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Locales.init(['hu', 'en', 'de', 'es', 'fr', 'pt', 'it']);
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
  runApp(
    DevicePreview(enabled: false, builder: (context) => App()),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeColourProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => FavouritesProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
          ChangeNotifierProvider(create: (_) => GridLayoutProvider()),
        ],
        child: Builder(builder: (BuildContext context) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return LocaleBuilder(
            builder: (locale) {
              return MaterialApp(
                title: 'Hooodies!',
                localizationsDelegates: Locales.delegates,
                supportedLocales: Locales.supportedLocales,
                locale: locale,
                scaffoldMessengerKey: Utils.messengerKey,
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                themeMode: themeProvider.themeMode,
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
              );
            },
          );
        }));
  }
}

class LoginApp extends StatefulWidget {
  const LoginApp({super.key});

  @override
  State<LoginApp> createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await precacheProductImages(context);
    });
  }

  Future<void> precacheProductImages(BuildContext context) async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('products').get();
    for (var result in querySnapshot.docs) {
      var product = result.data();
      print(product['imageUrl']);
      await precacheImage(
          CachedNetworkImageProvider(product['imageUrl']), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitDualRing(
                color: Colors.red,
                size: 40.0,
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong... Please restart the app!"),
            );
          } else if (snapshot.hasData) {
            return VerifyEmailPage();
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}
