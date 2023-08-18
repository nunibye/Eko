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
  ImageProvider<Object>? profileImage;

  ProfileController() {
    init(); // wait until AFTER object is created
  }

  Future<void> init() async {
    await locator<CurrentUser>().readUserData();
    loadUserData();
  }

  loadUserData() async {
    likes = locator<CurrentUser>().likes;
    followers = locator<CurrentUser>().followers;
    following = locator<CurrentUser>().following;
    username = locator<CurrentUser>().username;
    String? profileImageUrl = await locator<CurrentUser>().getProfileImageUrl();
    if (profileImageUrl != null) {
      profileImage = NetworkImage(
          profileImageUrl); // FIXME!!! IS THIS LEGAL??? i way having trouble passing in a networkImage into here from model
    }
    notifyListeners();
  }
}
