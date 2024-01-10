import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled_app/models/version_control.dart';
import 'locator.dart';
import '../models/current_user.dart';

class RouterNotifier extends ChangeNotifier {
  bool loggedIn = false;

  RouterNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event != null) {
        loggedIn = true;
      } else {
        loggedIn = false;
      }
      //print('authcahnge $loggedIn');
      notifyListeners();
    });
  }

  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    final onLoginPage = state.fullPath == '/login';
    final onSignUpPage = state.fullPath == '/signup';
    final onAuthPage = state.fullPath == '/auth';
    final onWelcomePage = state.fullPath == '/';
    final onDownloadPage = state.fullPath == '/download';
    //print('redirect $loggedIn');
    if (locator<Version>().lessThanMin && !kIsWeb) {
      return '/update';
    } else if (!loggedIn &&
        !(onSignUpPage ||
            onLoginPage ||
            onWelcomePage ||
            onAuthPage ||
            onDownloadPage)) {
      return '/';
    } else if (loggedIn && (onLoginPage || onSignUpPage || onWelcomePage)) {
      if (locator<CurrentUser>().username == '') {
        await locator<CurrentUser>().readCurrentUserData();
      }

      return '/feed';
    }

    return null;
  }
}
