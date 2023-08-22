import 'package:flutter/material.dart';
import 'package:untitled_app/utilities/navigation_service.dart';
import '../models/current_user.dart';
import '../views/edit_profile.dart';
import '../utilities/locator.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Post {
  final String author;
  final String time;
  final String title;
  final String body;
  final List<String> likes;
  Post(
      {required this.author,
      required this.time,
      required this.title,
      required this.body,
      required this.likes});
}

class ProfileController extends ChangeNotifier {
  // final BuildContext _context = NavigationService.navigatorKey.currentContext!;
  int likes = locator<CurrentUser>().likes;
  int followers = locator<CurrentUser>().followers;
  int following = locator<CurrentUser>().following;
  String username = locator<CurrentUser>().username;
  String profileImage = locator<CurrentUser>().profileImage;
  late List<Post> userPosts;

//not needed now
  ProfileController() {
    init(); // wait until AFTER object is created
  }

  Future<void> init() async {
    await locator<CurrentUser>().readUserData();
    List test = await locator<CurrentUser>().getUserPosts();
    userPosts = test
        .map(
          (doc) => Post(
              author: doc["author"] ?? '',
              time: doc["time"] ?? '',
              title: doc["title"] ?? '',
              body: doc["body"] ?? '',
              likes: doc["likes"] ?? []),
        )
        .toList();
    print('loaded');
    loadUserData();
  }

  editProfilePressed() {
    Navigator.push(
      NavigationService.navigatorKey.currentContext!,
      MaterialPageRoute(builder: (context) => const EditProfile()),
    ).then((value) {
      profileImage = locator<CurrentUser>().profileImage;
      notifyListeners();
      //await CachedNetworkImage.evictFromCache("test");
    });
  }

  // FIXME: currently not updating the information after i changed navigation bar to indexed stack will fix later
  loadUserData() async {
    likes = locator<CurrentUser>().likes;
    followers = locator<CurrentUser>().followers;
    following = locator<CurrentUser>().following;
    username = locator<CurrentUser>().username;
    profileImage = locator<CurrentUser>().profileImage;
    //print(username);
    notifyListeners();
  }
}
