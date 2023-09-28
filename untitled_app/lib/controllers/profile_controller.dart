import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled_app/models/users.dart' show AppUser;
import '../models/current_user.dart';
import 'bottom_nav_bar_controller.dart';
//import '../views/edit_profile.dart';
import '../utilities/locator.dart';

class ProfileController extends ChangeNotifier {
  int likes = locator<CurrentUser>().likes;
  List<dynamic> followers = locator<CurrentUser>().followers;
  List<dynamic> following = locator<CurrentUser>().following;
  String username = locator<CurrentUser>().username;
  String profileImage = locator<CurrentUser>().profileImage;
  String firstName = locator<CurrentUser>().firstName;
  String lastName = locator<CurrentUser>().lastName;
  String profileBio = locator<CurrentUser>().bio;
  String bioName = locator<CurrentUser>().bioName;
  final BuildContext context;
  late AppUser user;

  ProfileController({
    required this.context,
  }) {
    initUser();
  }
  onPageRefresh() {
    loadUserData();
  }

//FIXME maybe move to a standard class format for more reusablity
  initUser() {
    user = AppUser(
      uid: getUID(),
      firstName: firstName,
      lastName: lastName,
      username: username,
      profileImage: profileImage,
      bio: profileBio,
      bioName: bioName,
    );
  }

  editProfilePressed() async {
    locator<NavBarController>().disable();
    await context.push("/profile/edit_profile");

    locator<NavBarController>().enable();
    profileImage = locator<CurrentUser>().profileImage;
    profileBio = locator<CurrentUser>().bio;
    bioName = locator<CurrentUser>().bioName;
    user.profileImage = profileImage;
    user.bio = profileBio;
    user.bioName = bioName;
    notifyListeners();
  }

  settingsButtonPressed() async {
    locator<NavBarController>().disable();
    await context.push('/profile/user_settings');
    locator<NavBarController>().enable();
  }

  String getUID() {
    return locator<CurrentUser>().getUID();
  }

  void loadUserData() async {
    await locator<CurrentUser>().readCurrentUserData();
    likes = locator<CurrentUser>().likes;
    followers = locator<CurrentUser>().followers;
    following = locator<CurrentUser>().following;
    username = locator<CurrentUser>().username;
    profileImage = locator<CurrentUser>().profileImage;
    profileBio = locator<CurrentUser>().bio;
    initUser();
    //print(username);
    notifyListeners();
  }
}
