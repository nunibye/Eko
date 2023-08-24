import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:untitled_app/utilities/navigation_service.dart';
import '../models/current_user.dart';
import 'package:flutter/material.dart';
import '../custom_widgets/login_dialog.dart';
import '../utilities/locator.dart';
import '../views/sign_up.dart';

class LoginController extends ChangeNotifier {
  // BuildContext context;
  // LoginController(this.context);

  bool loggingIn = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  final BuildContext _context = NavigationService.navigatorKey.currentContext!;
  void _pop() {
    Navigator.of(_context).pop();
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
    Navigator.push(
      _context,
      MaterialPageRoute(builder: (context) => SignUp()),
    ); //FIXME should we need to potomize this
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
      notifyListeners();  //FIXME problems can apear here since it gets disposed
    }
  }



  void _handleError(String errorCode) {
    switch (errorCode) {
      case 'success':
        break;
      case 'invalid-email':
        showMyDialog(
            AppLocalizations.of(_context)!.invalidEmailTittle,
            AppLocalizations.of(_context)!.invalidEmailBody,
            [AppLocalizations.of(_context)!.tryAgain],
            [_pop],
            _context);
        break;
      case 'user-not-found':
        showMyDialog(
            AppLocalizations.of(_context)!.userNotFoundTitle,
            AppLocalizations.of(_context)!.userNotFoundBody,
            [
              AppLocalizations.of(_context)!.signUp,
              AppLocalizations.of(_context)!.tryAgain
            ],
            [_signUpFromAlert, _pop],
            _context);
        break;
      case 'wrong-password':
        showMyDialog(
            AppLocalizations.of(_context)!.wrongPasswordTittle,
            AppLocalizations.of(_context)!.wrongPasswordBody,
            [AppLocalizations.of(_context)!.tryAgain],
            [_pop],
            _context);
        break;
      case 'user-disabled':
        showMyDialog(
            AppLocalizations.of(_context)!.userDisabledTittle,
            AppLocalizations.of(_context)!.userDisabledBody,
            [AppLocalizations.of(_context)!.tryAgain],
            [_pop],
            _context);
        break;
      default:
        showMyDialog(
            AppLocalizations.of(_context)!.defaultErrorTittle,
            AppLocalizations.of(_context)!.defaultErrorBody,
            [AppLocalizations.of(_context)!.tryAgain],
            [_pop],
            _context);
        break;
    }
  }
}
