import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_studio_projects/providers/theme.provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeProvider', () {
    test(
        'Should be ThemeMode-light, since no shared-preferences were initialized!',
        () async {
      SharedPreferences.setMockInitialValues({});
      final provider = ThemeProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.themeMode, ThemeMode.light);
    });

    test(
        'Should be ThemeMode.dark, since this will be set in shared-preferences beforehand!',
        () async {
      SharedPreferences.setMockInitialValues(
          {ThemeProvider.themeKey: ThemeMode.dark.index});
      final provider = ThemeProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      expect(provider.themeMode, ThemeMode.dark);
    });

    test(
        'Sets the ThemeMode to ThemeMode.dark after initializing with ThemeMode.light!',
        () async {
      final prefs = <String, Object>{};
      SharedPreferences.setMockInitialValues(prefs);

      final provider = ThemeProvider();
      await Future.delayed(const Duration(milliseconds: 100));

      provider.setTheme(ThemeMode.dark);
      await Future.delayed(const Duration(milliseconds: 100));

      final sharedPrefs = await SharedPreferences.getInstance();
      expect(sharedPrefs.getInt(ThemeProvider.themeKey), ThemeMode.dark.index);
      expect(provider.themeMode, ThemeMode.dark);
    });
  });
}
