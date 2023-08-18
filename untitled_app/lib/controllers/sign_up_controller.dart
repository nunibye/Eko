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
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final pageController = PageController();

  bool firstPage = true;
  bool lastPage = false;
  bool loggingIn = false;
  void _pop() {
    Navigator.of(_context).pop();
  }

  void _returnToLogin() {
    _pop();
    _pop();
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
    if (controller1.text == '') {
      focus1.requestFocus();
    } else if (controller2.text == '') {
      focus2.requestFocus();
    } else {
      locator<CurrentUser>().email = controller1.text;
      loggingIn = true;
      notifyListeners();

      _handleError(await locator<CurrentUser>().signUp(controller2.text));

      loggingIn = false;
      notifyListeners();
    }
  }

  void backPressed() async {
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
            [AppLocalizations.of(_context)!.go, AppLocalizations.of(_context)!.stay],
            [_returnToLogin, _pop],
            _context);
    }
  }

  void forwardPressed() async {
    if (pageController.page! <= 1.0) {
      _getPageData(pageController.page!.toInt());
      await pageController.nextPage(
          duration: const Duration(milliseconds: c.signUpAnimationDuration),
          curve: Curves.decelerate);
      _setPageData(pageController.page!.toInt());
    }
  }

  _getPageData(int page) {
    switch (page) {
      case 0:
        locator<CurrentUser>().firstName = controller1.text;
        locator<CurrentUser>().lastName = controller2.text;
        break;
      case 1:
        locator<CurrentUser>().userName = controller1.text;
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
        notifyListeners();
        controller1.text = locator<CurrentUser>().firstName;
        controller2.text = locator<CurrentUser>().lastName;
        break;
      case 1:
        firstPage = false;
        lastPage = false;
        notifyListeners();
        controller1.text = locator<CurrentUser>().userName;
        break;
      case 2:
        lastPage = true;
        notifyListeners();
        controller1.text = locator<CurrentUser>().email;
        break;
    }
  }
}
