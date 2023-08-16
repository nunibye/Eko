import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:untitled_app/navigation_service.dart';
import '../models/current_user.dart';
import 'package:flutter/material.dart';
import '../custom_widgets/login_dialog.dart';

class LoginController extends ChangeNotifier {
  // BuildContext context;
  // LoginController(this.context);
  CurrentUser model = CurrentUser();
  bool loggingIn = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  final BuildContext _context = NavigationService.navigatorKey.currentContext!;
  void _pop() {
    Navigator.of(_context).pop();
  }

  void _signUp() {
    Navigator.of(_context).pop(); //FIXME should go to sign up
  }

  forgotPasswordPressed(countryCode) async {
    model.email = emailController.text;
    _handleError(await model.forgotPassword(countryCode));
  }

  logInPressed() async {
    if (emailController.text == '') {
      emailFocus.requestFocus();
    } else if (passwordController.text == '') {
      passwordFocus.requestFocus();
    } else {
      model.email = emailController.text;
      model.password = passwordController.text;
      loggingIn = true;
      notifyListeners();

      _handleError(await model.signIn());

      loggingIn = false;
      notifyListeners();
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
            [_signUp, _pop],
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
      case 'too-many-requests':
        showMyDialog(
            AppLocalizations.of(_context)!.tooManyRequestsTittle,
            AppLocalizations.of(_context)!.tooManyRequestsBody,
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
      case 'channel-error':
        showMyDialog(
            AppLocalizations.of(_context)!.defaultErrorTittle,
            AppLocalizations.of(_context)!.channelErrorBody,
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
