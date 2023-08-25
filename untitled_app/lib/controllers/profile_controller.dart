import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/current_user.dart';
import 'bottom_nav_bar_controller.dart';
//import '../views/edit_profile.dart';
import '../utilities/locator.dart';
import '../models/post_handler.dart';

class ProfileController extends ChangeNotifier {
  int likes = locator<CurrentUser>().likes;
  int followers = locator<CurrentUser>().followers;
  int following = locator<CurrentUser>().following;
  String username = locator<CurrentUser>().username;
  String profileImage = locator<CurrentUser>().profileImage;
  final BuildContext context;

  ProfileController({
    required this.context,
  });
  onPageRefresh() {
    loadUserData();
  }

  editProfilePressed() async {
    locator<NavBarController>().disable();
    await context.push("/profile/edit_profile");
    locator<NavBarController>().enable();
    profileImage = locator<CurrentUser>().profileImage;
    notifyListeners();
  }

  String getUID() {
    
      return locator<CurrentUser>().getUID();

  }

  // FIXME: currently not updating the information after i changed navigation bar to indexed stack will fix later
  void loadUserData() async {
    await locator<CurrentUser>().readCurrentUserData();
    likes = locator<CurrentUser>().likes;
    followers = locator<CurrentUser>().followers;
    following = locator<CurrentUser>().following;
    username = locator<CurrentUser>().username;
    profileImage = locator<CurrentUser>().profileImage;
    //print(username);
    notifyListeners();
  }
}
