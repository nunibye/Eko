import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import '../models/current_user.dart';
import '../utilities/locator.dart';

class RootPageController extends ChangeNotifier {
  var auth = FirebaseAuth.instance.authStateChanges();
  loggedIn() {
    locator<CurrentUser>().readUserData();
  }
}
