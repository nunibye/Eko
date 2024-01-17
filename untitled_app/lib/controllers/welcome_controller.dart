import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/utilities/themes/dark_theme_provider.dart';

class WelcomeController extends ChangeNotifier {
  final BuildContext context;

  WelcomeController({required this.context});

  void goToLogin() {
    (context).push('/login');
    Provider.of<DarkThemeProvider>(context, listen: false).toggleWelcome(false);
  }

  void goToSignUp() {
    (context).push('/signup');
    Provider.of<DarkThemeProvider>(context, listen: false).toggleWelcome(false);
  }
}
