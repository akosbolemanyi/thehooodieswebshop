import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  Color _myTitleColor = Colors.red;
  Color get myTitleColor => _myTitleColor;

  void toggleTTL () {
    final isTitleRed = _myTitleColor == Colors.red;

    if (isTitleRed) {
      _myTitleColor = Colors.indigo.shade300;
    } else {
      _myTitleColor = Colors.red;
    }
    notifyListeners();
  }
}