import 'package:untitled_app/localization/generated/app_localizations.dart';

import '../models/current_user.dart';
import 'package:flutter/material.dart';
import '../custom_widgets/warning_dialog.dart';
import '../utilities/locator.dart';
import "package:go_router/go_router.dart";

class LoginController extends ChangeNotifier {
  // BuildContext context;
  // LoginController(this.context);

  bool loggingIn = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  final BuildContext context;

  LoginController({required this.context});
  void _pop() {
    Navigator.of(context).pop();
  }

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _signUpFromAlert() {
    _pop();
    signUp();
  }

  void signUp() {
    hideKeyboard();
    context.go("/signup");
  }

  void previousPressed() {
    hideKeyboard();
    context.go("/");
  }

  forgotPasswordPressed(countryCode) async {
    hideKeyboard();
    locator<CurrentUser>().email = emailController.text;
    _handleError(await locator<CurrentUser>().forgotPassword(countryCode));
  }

  logInPressed() async {
    hideKeyboard();
    if (emailController.text == '') {
      emailFocus.requestFocus();
    } else if (passwordController.text == '') {
      passwordFocus.requestFocus();
    } else {
      locator<CurrentUser>().email = emailController.text;
      loggingIn = true;
      notifyListeners();

      _handleError(
          await locator<CurrentUser>().signIn(passwordController.text));

      loggingIn = false;
      notifyListeners(); //FIXME problems can apear here since it gets disposed
    }
  }

  void _handleError(String errorCode) {
    switch (errorCode) {
      case 'success':
        break;
      case 'invalid-email':
        showMyDialog(
            AppLocalizations.of(context)!.invalidEmailTittle,
            AppLocalizations.of(context)!.invalidEmailBody,
            [AppLocalizations.of(context)!.tryAgain],
            [_pop],
            context);
        break;
      case 'user-not-found':
        showMyDialog(
            AppLocalizations.of(context)!.userNotFoundTitle,
            AppLocalizations.of(context)!.userNotFoundBody,
            [
              AppLocalizations.of(context)!.signUp,
              AppLocalizations.of(context)!.tryAgain
            ],
            [_signUpFromAlert, _pop],
            context);
        break;
      case 'wrong-password':
        showMyDialog(
            AppLocalizations.of(context)!.wrongPasswordTittle,
            AppLocalizations.of(context)!.wrongPasswordBody,
            [AppLocalizations.of(context)!.tryAgain],
            [_pop],
            context);
        break;
      case 'user-disabled':
        showMyDialog(
            AppLocalizations.of(context)!.userDisabledTittle,
            AppLocalizations.of(context)!.userDisabledBody,
            [AppLocalizations.of(context)!.tryAgain],
            [_pop],
            context);
        break;
      default:
        showMyDialog(
            AppLocalizations.of(context)!.defaultErrorTittle,
            AppLocalizations.of(context)!.defaultErrorBody,
            [AppLocalizations.of(context)!.tryAgain],
            [_pop],
            context);
        break;
    }
  }
}
