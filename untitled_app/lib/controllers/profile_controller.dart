import 'package:flutter/material.dart';
import 'package:untitled_app/utilities/navigation_service.dart';
import '../models/current_user.dart';
import '../views/edit_profile.dart';
import '../utilities/locator.dart';
import '../models/posts.dart';

class ProfileController extends ChangeNotifier {
  // final BuildContext _context = NavigationService.navigatorKey.currentContext!;
  int likes = locator<CurrentUser>().likes;
  int followers = locator<CurrentUser>().followers;
  int following = locator<CurrentUser>().following;
  String username = locator<CurrentUser>().username;
  String profileImage = locator<CurrentUser>().profileImage;
  List<Post> userPosts = [
    Post(
        username: "",
        profilePic: locator<CurrentUser>().profileImage,
        time: "",
        title: "",
        body: "",
        likes: 3)
  ];

//not needed now
  ProfileController() {
    init(); // wait until AFTER object is created
  }

  Future<void> init() async {
    loadUserData();
    fetchUserPosts();
  }

  fetchUserPosts() async {
    List test = await locator<CurrentUser>().getUserPosts();
    userPosts = test
        .map(
          (doc) => Post(
              profilePic: locator<CurrentUser>().profileImage,
              username: locator<CurrentUser>().username,
              time: doc["time"] ?? '',
              title: doc["title"] ?? '',
              body: doc["body"] ?? '',
              likes: doc["likes"].length ?? 0),
        )
        .toList();
    notifyListeners();
  }

  editProfilePressed() {
    Navigator.push(
      NavigationService.navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => const EditProfile()),
    ).then((value) {
      profileImage = locator<CurrentUser>().profileImage;
      notifyListeners();
      //FIXME move this
      fetchUserPosts();
      //await CachedNetworkImage.evictFromCache("test");
    });
  }

  // FIXME: currently not updating the information after i changed navigation bar to indexed stack will fix later
  loadUserData() async {
    await locator<CurrentUser>().readUserData();
    likes = locator<CurrentUser>().likes;
    followers = locator<CurrentUser>().followers;
    following = locator<CurrentUser>().following;
    username = locator<CurrentUser>().username;
    profileImage = locator<CurrentUser>().profileImage;
    //print(username);
    notifyListeners();
  }
}
