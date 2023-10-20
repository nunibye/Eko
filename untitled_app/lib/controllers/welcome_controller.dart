import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeController extends ChangeNotifier {
  final BuildContext context;

  WelcomeController({required this.context});

  void onLoginButtonPressed() {
    goToLogin();
  }

  void onCreateAccountButtonPressed() {
    goToSignUp();
  }

  void goToLogin() {
    GoRouter.of(context).go('/login');
  }

  void goToSignUp() {
    GoRouter.of(context).go('/signup');
  }
}
