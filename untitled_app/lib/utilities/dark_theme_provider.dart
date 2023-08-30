import 'package:flutter/material.dart';
import '../utilities/dark_theme_preference.dart';

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  DarkThemeProvider() {
    _loadDarkThemeFromPrefs(); // Initialize _darkTheme during construction
  }

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }

  Future<void> _loadDarkThemeFromPrefs() async {
    _darkTheme = await darkThemePreference.getTheme();
    notifyListeners();
  }
}
