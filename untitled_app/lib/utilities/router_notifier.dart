import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
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
      print('authcahnge $loggedIn');
      notifyListeners();
    });
  }

  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    final onLoginPage = state.fullPath == '/login';
    final onSignUpPage = state.fullPath == '/signup';
    final onWelcomePage = state.fullPath == '/welcome';
    print('redirect $loggedIn');
    if (!loggedIn && !(onSignUpPage || onLoginPage || onWelcomePage)) {
      return '/welcome';
    }
    else if (loggedIn && (onLoginPage || onSignUpPage || onWelcomePage)) {
      await locator<CurrentUser>().readCurrentUserData();
      
      return '/profile';
    }

    return null;
  }

  // void signOut(BuildContext context) async {
  //   loggedIn = false; // Set loggedIn to false before sign out
  //   notifyListeners();
  //   print(loggedIn);
  //   // Sign out the user
  //   await FirebaseAuth.instance.signOut();

  //   // Clear the entire navigation stack and redirect to login
  //   final goRouter = GoRouter.of(context);
  //   goRouter.go('/login');
  // }
}
