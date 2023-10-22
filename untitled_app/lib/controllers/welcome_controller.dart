import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeController extends ChangeNotifier {
  final BuildContext context;

  WelcomeController({required this.context});

  void goToLogin() {
    (context).go('/login');
  }

  void goToSignUp() {
    (context).go('/signup');
  }
}
