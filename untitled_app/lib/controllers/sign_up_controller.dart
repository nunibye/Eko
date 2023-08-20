import 'dart:ffi';

import 'package:flutter/material.dart';
import '../constants.dart' as c;
import '../locator.dart';
import '../models/current_user.dart';
import '../navigation_service.dart';
import '../custom_widgets/login_dialog.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';

// TODO add presubmission error checking
class SignUpController extends ChangeNotifier {
  final BuildContext _context = NavigationService.navigatorKey.currentContext!;

  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  final controller3 = TextEditingController();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final pageController = PageController();

  bool firstPage = true;
  bool lastPage = false;
  bool loggingIn = false;
  bool goodPassword = false;
  double passwordPercent = 0;
  List<String> passed = ["❌", "❌", "❌", "❌", "❌", "❌"];

  passwordChanged() {
    passed = ["❌", "❌", "❌", "❌", "❌", "❌"];
    int points = 0;
    String pass1 = controller2.text;
    String pass2 = controller3.text;
    if ((pass1).length >= 7 && (pass1).length <= 32) {
      points++;
      passed[0] = "✅";
    }
    if (pass1.contains(RegExp(r'[a-z]'))) {
      points++;
      passed[2] = "✅";
    }
    if (pass1.contains(RegExp(r'[A-Z]'))) {
      points++;
      passed[1] = "✅";
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
    Navigator.of(_context).pop();
  }

  void _returnToLogin() {
    _pop();
    _pop();
  }

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void keyboardGoToNextPage() async {
    await forwardPressed();
    Future.delayed(const Duration(milliseconds: 100), () => focus1.requestFocus()); //waits for keyboard to close

    //focus1.requestFocus();
  }

  void _handleError(String errorCode) {
    switch (errorCode) {
      case 'success':
        _pop();
        break;
      case 'invalid-email':
        showMyDialog(
            AppLocalizations.of(_context)!.invalidEmailTittle,
            AppLocalizations.of(_context)!.invalidEmailBody,
            [AppLocalizations.of(_context)!.tryAgain],
            [_pop],
            _context);
        break;
      case 'weak-password':
        showMyDialog(
            AppLocalizations.of(_context)!.weakPasswordTitle,
            AppLocalizations.of(_context)!.weakPasswordBody,
            [AppLocalizations.of(_context)!.tryAgain],
            [_pop],
            _context);
        break;
      case 'email-already-in-use':
        showMyDialog(
            AppLocalizations.of(_context)!.emailAlreadyInUseTitle,
            AppLocalizations.of(_context)!.emailAlreadyInUseBody,
            [
              AppLocalizations.of(_context)!.logIn,
              AppLocalizations.of(_context)!.tryAgain
            ],
            [_returnToLogin, _pop],
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

  signUpPressed() async {
    hideKeyboard();

    if (controller1.text == '') {
      focus1.requestFocus();
    } else if (controller2.text == '') {
      focus2.requestFocus();
    } else {
      //TODO delete || controller2.text == "password" before production
      if (goodPassword || controller2.text == "password") {
        locator<CurrentUser>().email = controller1.text;
        loggingIn = true;
        notifyListeners();

        _handleError(await locator<CurrentUser>().signUp(controller2.text));
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
          AppLocalizations.of(_context)!.exitCreateAccountTitle,
          AppLocalizations.of(_context)!.exitCreateAccountBody,
          [
            AppLocalizations.of(_context)!.go,
            AppLocalizations.of(_context)!.stay
          ],
          [_returnToLogin, _pop],
          _context);
    }
  }

  forwardPressed() async {
    hideKeyboard();
    int page = pageController.page!.toInt();
    if (controller1.text == "") {
      focus1.requestFocus();
      return "done";
    }
    if (controller2.text == "" && page == 0) {
      focus2.requestFocus();
      return "done";
    }
    if (page <= 1) {
      _getPageData(page);
      _setPageData(page + 1);
      await pageController.nextPage(
          duration: const Duration(milliseconds: c.signUpAnimationDuration),
          curve: Curves.decelerate);

      // _setPageData(page);
    }
    return "done";
  }

  _getPageData(int page) {
    switch (page) {
      case 0:
        locator<CurrentUser>().firstName = controller1.text;
        locator<CurrentUser>().lastName = controller2.text;
        break;
      case 1:
        locator<CurrentUser>().username = controller1.text;
        break;
      case 2:
        locator<CurrentUser>().email = controller1.text;
        break;
    }
  }

  _setPageData(int page) {
    switch (page) {
      case 0:
        firstPage = true;

        controller1.text = locator<CurrentUser>().firstName;
        controller2.text = locator<CurrentUser>().lastName;
        notifyListeners();
        break;
      case 1:
        firstPage = false;
        lastPage = false;

        controller1.text = locator<CurrentUser>().username;
        controller2.text = "";
        controller3.text = "";
        notifyListeners();
        break;
      case 2:
        lastPage = true;

        controller1.text = locator<CurrentUser>().email;
        controller2.text = "";
        controller3.text = "";
        notifyListeners();
        break;
    }
  }
}
