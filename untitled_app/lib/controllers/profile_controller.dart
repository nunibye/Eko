import 'package:flutter/material.dart';
import 'package:untitled_app/navigation_service.dart';
import '../models/current_user.dart';

import 'package:provider/provider.dart';
import '../locator.dart';

class ProfileController extends ChangeNotifier {
  // final BuildContext _context = NavigationService.navigatorKey.currentContext!;
  int likes = 0;
  int followers = 0;
  int following = 0;
  String username = '';

  ProfileController() {
    loadUserData(); // Load user data when the ProfileController is created
  }

  loadUserData() async {
    likes = locator<CurrentUser>().likes;
    followers = locator<CurrentUser>().followers;
    following = locator<CurrentUser>().following;
    username = locator<CurrentUser>().username;
    notifyListeners();
  }
}
