import 'package:flutter/material.dart';
import '../utilities/constants.dart' as c;
import '../utilities/locator.dart';
import '../models/current_user.dart';

import '../custom_widgets/warning_dialog.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import "package:go_router/go_router.dart";
import 'dart:async';

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

  bool availableUsername = false;
  bool validUsername = false;
  bool isChecking = false;
  bool firstPage = true;
  bool lastPage = false;
  bool loggingIn = false;
  bool goodPassword = false;
  double passwordPercent = 0;
  Timer? _debounce;
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
    context.pop();
  }

  void _returnToWelcome() {
    _pop();
    context.go("/");
  }

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void keyboardGoToNextPage() async {
    await forwardPressed();
    Future.delayed(const Duration(milliseconds: 100),
        () => passwordFocus.requestFocus()); //waits for keyboard to close

    //focus1.requestFocus();
  }

  void _popAndGoBack() {
    _pop();
    backPressed();
    usernameFocus.requestFocus();
  }

  bool _handleError(String errorCode) {
    switch (errorCode) {
      case 'success':
        return true;
      case 'username-taken':
        showMyDialog(
            AppLocalizations.of(context)!.usernameTakenTitle,
            AppLocalizations.of(context)!.usernameTakenBody,
            [AppLocalizations.of(context)!.goBack],
            [_popAndGoBack],
            context);
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
    return false;
  }

  void onUsernameChanged(String s) {
    if (!s.trim().contains(RegExp(c.userNameReqs))) {
      validUsername = false;
      notifyListeners();
    } else {
      validUsername = true;
      isChecking = true;
      notifyListeners();
    }
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce =
        Timer(const Duration(milliseconds: c.searchPageDebounce), () async {
      if (s != '') {
        availableUsername = await locator<CurrentUser>()
            .isUsernameAvailable(usernameController.text.trim());

        isChecking = false;
        notifyListeners();
      }
    });
  }

  signUpPressed() async {
    hideKeyboard();

    if (passwordController.text == '') {
      passwordFocus.requestFocus();
    } else {
      //TODO delete || controller2.text == "password" before production
      if (goodPassword || passwordController.text == "password") {
        loggingIn = true;
        notifyListeners();
        locator<CurrentUser>().email = emailController.text.trim();
        locator<CurrentUser>().username = usernameController.text.trim();
        locator<CurrentUser>().name = nameController.text.trim();

        if (await locator<CurrentUser>()
            .isUsernameAvailable(usernameController.text.trim())) {
          if (_handleError(
              await locator<CurrentUser>().signUp(passwordController.text))) {
            locator<CurrentUser>().addUserDataToFirestore();
          }
        } else {
          _handleError("username-taken");
        }

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
      await pageController.previousPage(
          duration: const Duration(milliseconds: c.signUpAnimationDuration),
          curve: Curves.decelerate);
    } else {
      showMyDialog(
          AppLocalizations.of(context)!.exitCreateAccountTitle,
          AppLocalizations.of(context)!.exitCreateAccountBody,
          [
            AppLocalizations.of(context)!.goBack,
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
            !validUsername ||
            isChecking ||
            !availableUsername ||
            emailController.text == ""
        // ||dobController.text == ""
        )) {
      // Request focus for the empty field
      if (nameController.text == "") {
        nameFocus.requestFocus();
      } else if (!validUsername || isChecking || !availableUsername) {
        usernameFocus.requestFocus();
      } else if (emailController.text == "") {
        emailFocus.requestFocus();
      }
      // else {dobFocus.requestFocus();}
      return "done";
    }
    if (page == 0) {
      //_getPageData(page);
      //_setPageData(page + 1);
      await pageController.nextPage(
          duration: const Duration(milliseconds: c.signUpAnimationDuration),
          curve: Curves.decelerate);
    }
    return "done";
  }
}
