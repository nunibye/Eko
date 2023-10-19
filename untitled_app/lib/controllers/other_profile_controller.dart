import 'package:flutter/widgets.dart';
import 'package:untitled_app/models/users.dart';
import '../models/current_user.dart';
import '../utilities/locator.dart';

class OtherProfileController extends ChangeNotifier {
  final BuildContext context;
  final AppUser? user;
  int likes = 0;
  List<dynamic> followers = const [];
  List<dynamic> following = const [];
  String username = "";
  String profileImage = "";

  String uid = "";
  String profileBio = "";
  String name = "";
  late bool isFollowing;

  OtherProfileController({required this.context, required this.user}) {
    _init();
  }
  void _init() {
    if (user != null) {
      uid = user!.uid;
      name = user!.name;
      
      likes = user!.likes;
      followers = user!.followers;
      following = user!.following;
      username = user!.username;
      profileImage = user!.profilePicture;
      profileBio = user!.bio;
      
    }
    isFollowing = locator<CurrentUser>().checkIsFollowing(uid);

    notifyListeners();
  }

  onFollowPressed() async {
    if (isFollowing) {
      if (await locator<CurrentUser>().removeFollower(uid)) {
        isFollowing = false;
      }
    } else {
      if (await locator<CurrentUser>().addFollower(uid)) {
        isFollowing = true;
      }
    }
    notifyListeners();
  }

  onPageRefresh() {
    //TODO Add code to pull user data from database
  }
}
