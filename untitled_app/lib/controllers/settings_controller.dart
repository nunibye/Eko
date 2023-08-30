import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utilities/themes/dark_theme_provider.dart';

class SettingsController extends ChangeNotifier {
  final BuildContext context;

  SettingsController({
    required this.context,
  });
  
  bool getValue() {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return themeChange.darkTheme;
  }

  changeValue(value) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    themeChange.darkTheme = value;
  }
}
