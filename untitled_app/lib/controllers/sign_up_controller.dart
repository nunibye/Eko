import 'package:flutter/material.dart';
import '../utilities/constants.dart' as c;
import '../utilities/locator.dart';
import '../models/current_user.dart';

import '../custom_widgets/login_dialog.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import "package:go_router/go_router.dart";

// TODO add presubmission error checking
class SignUpController extends ChangeNotifier {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final dobController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final nameFocus = FocusNode();
  final usernameFocus = FocusNode();
  final dobFocus = FocusNode();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  final passwordConfirmFocus = FocusNode();

  final pageController = PageController();
  final BuildContext context;

  bool firstPage = true;
  bool lastPage = false;
  bool loggingIn = false;
  bool goodPassword = false;
  double passwordPercent = 0;
  List<String> passed = ["❌", "❌", "❌", "❌", "❌", "❌"];

  SignUpController({required this.context});

  passwordChanged() {
    passed = ["❌", "❌", "❌", "❌", "❌", "❌"];
    int points = 0;
    String pass1 = passwordController.text;
    String pass2 = passwordConfirmController.text;
    if ((pass1).length >= 7 && (pass1).length <= 32) {
      points++;
      passed[0] = "✅";
    }
    if (pass1.contains(RegExp(r'[a-z]'))) {
      points++;
      passed[1] = "✅";
    }
    if (pass1.contains(RegExp(r'[A-Z]'))) {
      points++;
      passed[2] = "✅";
    }

    if (pass1.contains(RegExp(r'[0-9]'))) {
      points++;
      passed[3] = "✅";
    }
    if (!pass1.contains(RegExp(r'^[A-Za-z0-9]*$'))) {
      points++;
      passed[4] = "✅";
    }
    if (pass1 == pass2 && pass1 != "") {
      points++;
      passed[5] = "✅";
    }
    goodPassword = (points == 6);
    if (pass1 != '') {
      passwordPercent = points / 6;
    } else {
      passwordPercent = 0;
    }
    notifyListeners();
  }

  void _pop() {
    Navigator.of(context).pop();
  }

  void _returnToWelcome() {
    _pop();
    context.go("/welcome");
  }

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void keyboardGoToNextPage() async {
    await forwardPressed();
    Future.delayed(const Duration(milliseconds: 100),
        () => nameFocus.requestFocus()); //waits for keyboard to close

    //focus1.requestFocus();
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
      case 'weak-password':
        showMyDialog(
            AppLocalizations.of(context)!.weakPasswordTitle,
            AppLocalizations.of(context)!.weakPasswordBody,
            [AppLocalizations.of(context)!.tryAgain],
            [_pop],
            context);
        break;
      case 'email-already-in-use':
        showMyDialog(
            AppLocalizations.of(context)!.emailAlreadyInUseTitle,
            AppLocalizations.of(context)!.emailAlreadyInUseBody,
            [
              AppLocalizations.of(context)!.logIn,
              AppLocalizations.of(context)!.tryAgain
            ],
            [_returnToWelcome, _pop],
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

  signUpPressed() async {
    hideKeyboard();

    if (passwordController.text == '') {
      passwordFocus.requestFocus();
    } else {
      //TODO delete || controller2.text == "password" before production
      if (goodPassword || passwordController.text == "password") {
        locator<CurrentUser>().email = emailController.text;
        loggingIn = true;
        notifyListeners();
        _handleError(
            await locator<CurrentUser>().signUp(passwordController.text));
        locator<CurrentUser>().addUserDataToFirestore();
        loggingIn = false;
        notifyListeners();
      } else {
        _handleError("weak-password");
      }
    }
  }

  void backPressed() async {
    hideKeyboard();
    if (pageController.page != 0.0) {
      _getPageData(pageController.page!.toInt());
      await pageController.previousPage(
          duration: const Duration(milliseconds: c.signUpAnimationDuration),
          curve: Curves.decelerate);
      _setPageData(pageController.page!.toInt());
    } else {
      showMyDialog(
          AppLocalizations.of(context)!.exitCreateAccountTitle,
          AppLocalizations.of(context)!.exitCreateAccountBody,
          [
            AppLocalizations.of(context)!.go,
            AppLocalizations.of(context)!.stay
          ],
          [_returnToWelcome, _pop],
          context);
    }
  }

  forwardPressed() async {
    hideKeyboard();
    int page = pageController.page!.toInt();
    if (page == 0 &&
        (nameController.text == "" ||
            usernameController.text == "" ||
            emailController.text == "" ||
            dobController.text == "")) {
      // Request focus for the empty field
      if (nameController.text == "") {
        nameFocus.requestFocus();
      } else if (usernameController.text == "") {
        usernameFocus.requestFocus();
      } else if (emailController.text == "") {
        emailFocus.requestFocus();
      } else {
        dobFocus.requestFocus();
      }
      return "done";
    }
    if (page == 0) {
      _getPageData(page);
      _setPageData(page + 1);
      await pageController.nextPage(
          duration: const Duration(milliseconds: c.signUpAnimationDuration),
          curve: Curves.decelerate);
    }
    return "done";
  }

  _getPageData(int page) {
    switch (page) {
      case 0:
        locator<CurrentUser>().name = nameController.text;
        locator<CurrentUser>().username = usernameController.text;
        locator<CurrentUser>().email = emailController.text;
        break;
      case 1:
        break;
    }
  }

  _setPageData(int page) {
    switch (page) {
      case 0:
        firstPage = true;
        lastPage = false;

        nameController.text = locator<CurrentUser>().name;
        usernameController.text = locator<CurrentUser>().username;
        emailController.text = locator<CurrentUser>().email;

        notifyListeners();
        break;
      case 1:
        firstPage = false;
        lastPage = true;

        passwordController.text = "";
        passwordConfirmController.text = "";
        notifyListeners();
        break;
    }
  }
}
