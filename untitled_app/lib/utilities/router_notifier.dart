import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/controllers/bottom_nav_bar_controller.dart';
import 'package:untitled_app/utilities/themes/dark_theme_provider.dart';
import '../models/version_control.dart';
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
    final onFeedPage = state.fullPath == '/feed/post/:id';
    final onProfilePage = state.fullPath == '/feed/sub_profile/:id';
    //print('redirect $loggedIn');
    if (locator<Version>().lessThanMin && !kIsWeb) {
      return '/update';
    } else if (!loggedIn && (onFeedPage || onProfilePage)) {
      Provider.of<DarkThemeProvider>(context, listen: false).toggleWelcome(false);
      return null;
    } else if (!loggedIn &&
        !(onSignUpPage ||
            onLoginPage ||
            onWelcomePage ||
            onAuthPage ||
            onDownloadPage)) {
              Provider.of<DarkThemeProvider>(context, listen: false).toggleWelcome(true);
      return '/';
    } else if (loggedIn && (onLoginPage || onSignUpPage || onWelcomePage)) {
      if (locator<CurrentUser>().username == '') {
        Provider.of<DarkThemeProvider>(context, listen: false).toggleWelcome(false);
        await locator<CurrentUser>().readCurrentUserData();
      }
      locator<NavBarController>().enable();
      return '/feed';
    }
    return null;
  }
}
