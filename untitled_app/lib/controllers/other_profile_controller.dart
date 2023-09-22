import 'package:flutter/widgets.dart';
import '../models/post_handler.dart' show Post;
import '../models/current_user.dart';
import '../utilities/locator.dart';

class OtherProfileController extends ChangeNotifier {
  final BuildContext context;
  final Post? post;
  int likes = 0;
  List<dynamic> followers = const [];
  List<dynamic> following = const [];
  String username = "";
  String profileImage = "";
  String firstName = "";
  String lastName = "";
  String uid = "";
  String profileBio = "";
  late bool isFollowing;

  OtherProfileController({required this.context, required this.post}) {
    _init();
  }
  void _init() {
    if (post != null) {
      uid = post!.uid;
      firstName = post!.firstName;
      lastName = post!.lastName;
      likes = post!.userLikes;
      followers = post!.followers;
      following = post!.following;
      username = post!.username;
      profileImage = post!.profilePic;
      profileBio = post!.profileBio;
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
