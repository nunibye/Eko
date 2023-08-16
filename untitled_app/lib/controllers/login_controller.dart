import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/current_user.dart';
import 'package:flutter/material.dart';

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

  logInPressed() {
    print("test");
    if (emailController.text == '') {
      emailFocus.requestFocus();
    } else if (passwordController.text == '') {
      passwordFocus.requestFocus();
    } else {
      model.email = emailController.text;
      model.password = passwordController.text;
      loggingIn = true;
      notifyListeners();
      model.signIn();
      //loggingIn = false;
    }
  }

  // Future<void> _showMyDialog(
  //     String title, String line1, String button1, bool signUp) async {
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
}
