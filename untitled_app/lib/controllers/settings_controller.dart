import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/models/current_user.dart';
import 'package:untitled_app/utilities/locator.dart';
import '../utilities/themes/dark_theme_provider.dart';

class SettingsController extends ChangeNotifier {
  final BuildContext context;

  SettingsController({
    required this.context,
  });

  bool getValue() {
    final themeChange = Provider.of<DarkThemeProvider>(context, listen: false);
    return themeChange.darkTheme;
  }

  changeValue(value) {
    final themeChange = Provider.of<DarkThemeProvider>(context, listen: false);
    themeChange.darkTheme = value;
  }

  signOut() {
    // context.pop("poped");
    locator<CurrentUser>().signOut();
  }
}
