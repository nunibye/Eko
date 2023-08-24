import 'package:flutter/material.dart';
import 'package:untitled_app/utilities/navigation_service.dart';
import '../models/current_user.dart';
import '../views/edit_profile.dart';
import '../utilities/locator.dart';

class ProfileController extends ChangeNotifier {
  int likes = locator<CurrentUser>().likes;
  int followers = locator<CurrentUser>().followers;
  int following = locator<CurrentUser>().following;
  String username = locator<CurrentUser>().username;
  String profileImage = locator<CurrentUser>().profileImage;

  ProfileController() {
    init(); // wait until AFTER object is created
  }

  Future<void> init() async {
    loadUserData();
  }

  onPageRefresh() {
    loadUserData();
  }

  editProfilePressed() {
    Navigator.push(
      NavigationService.navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => const EditProfile()),
    ).then((value) {
      profileImage = locator<CurrentUser>().profileImage;
      notifyListeners();
    });
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
