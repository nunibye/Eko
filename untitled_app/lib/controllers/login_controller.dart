import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

  forgotPasswordPressed(countryCode) {
    model.email = emailController.text;
    model.forgotPassword(countryCode);
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

      _handleLogInError(await model.signIn());

      loggingIn = false;
      notifyListeners();
    }
  }

  _handleLogInError(errorCode) {
    BuildContext context = NavigationService.navigatorKey.currentContext!;
    switch (errorCode) {
      case 'invalid-email':
        showMyDialog(
            AppLocalizations.of(context)!.invalidEmailTittle,
            AppLocalizations.of(context)!.invalidEmailBody,
            [AppLocalizations.of(context)!.tryAgain],
            [Navigator.of(context).pop()], context);
        break;
      case 'user-not-found':
        _showMyDialog(
            AppLocalizations.of(context)!.userNotFoundTitle,
            AppLocalizations.of(context)!.userNotFoundBody,
            AppLocalizations.of(context)!.tryAgain,
            true);
        break;
      case 'wrong-password':
        _showMyDialog(
            AppLocalizations.of(context)!.wrongPasswordTittle,
            AppLocalizations.of(context)!.wrongPasswordBody,
            AppLocalizations.of(context)!.tryAgain,
            false);
        break;
      case 'too-many-requests':
        _showMyDialog(
            AppLocalizations.of(context)!.tooManyRequestsTittle,
            AppLocalizations.of(context)!.tooManyRequestsBody,
            AppLocalizations.of(context)!.tryAgain,
            false);
        break;
      case 'user-disabled':
        _showMyDialog(
            AppLocalizations.of(context)!.userDisabledTittle,
            AppLocalizations.of(context)!.userDisabledBody,
            AppLocalizations.of(context)!.tryAgain,
            false);
        break;
      default:
        _showMyDialog(
            AppLocalizations.of(context)!.defaultErrorTittle,
            AppLocalizations.of(context)!.defaultErrorBody,
            AppLocalizations.of(context)!.tryAgain,
            false);
        break;
    }
  }
}

 //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(title),
  //         content: SingleChildScrollView(
  //           child: Text(line1),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text(button1),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           if (signUp)
  //             TextButton(
  //               child: Text(AppLocalizations.of(context)!.signUp),
  //               onPressed: () {
  //                 Navigator.of(context).pop(); //TODO fix this
  //               },
  //             ),
  //         ],
  //       );
  //     },
  //   );
  // }