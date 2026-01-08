import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isLightMode => _themeMode == ThemeMode.light;

  void toggleTheme(bool isLight) {
    _themeMode = isLight ? ThemeMode.light : ThemeMode.dark;

    notifyListeners();
  }
}
