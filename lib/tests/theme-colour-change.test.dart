import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:android_studio_projects/providers/theme-colour.provider.dart';

void main() {
  group('ThemeColourProvider', () {
    test('toggleTTL should toggle between red and indigo and back', () {
      final themeProvider = ThemeColourProvider();

      final initialColor = themeProvider.myTitleColor;
      expect(initialColor, equals(Colors.red));

      themeProvider.toggleTTL();
      final toggledColor = themeProvider.myTitleColor;
      expect(toggledColor, equals(Colors.indigo.shade300));

      themeProvider.toggleTTL();
      final revertedColor = themeProvider.myTitleColor;
      expect(revertedColor, equals(Colors.red));
    });
  });
}
