import 'package:flutter/material.dart';
import 'package:untitled_app/navigation_service.dart';
import '../models/current_user.dart';
import '../views/edit_profile.dart';
import '../locator.dart';

class ProfileController extends ChangeNotifier {
  // final BuildContext _context = NavigationService.navigatorKey.currentContext!;
  int likes = 0;
  int followers = 0;
  int following = 0;
  String username = '';
  String profileImage = locator<CurrentUser>().profileImage;

  ProfileController() {
    init(); // wait until AFTER object is created
  }

  Future<void> init() async {
    // await locator<CurrentUser>().readUserData();
    loadUserData();
  }

  editProfilePressed() {
    Navigator.push(
      NavigationService.navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => const EditProfile()),
    );
  }
  // FIXME: currently not updating the information after i changed navigation bar to indexed stack will fix later
  loadUserData() async {
    likes = locator<CurrentUser>().likes;
    followers = locator<CurrentUser>().followers;
    following = locator<CurrentUser>().following;
    username = locator<CurrentUser>().username;
    print(likes);
    notifyListeners();
  }
}
