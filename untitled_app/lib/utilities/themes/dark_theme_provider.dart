import 'package:flutter/material.dart';
import '../themes/dark_theme_preference.dart';

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = true;

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
