import 'package:flutter/material.dart';
import 'package:untitled_app/utilities/locator.dart';
import 'package:untitled_app/models/users.dart';

class FollowingController extends ChangeNotifier {
  final BuildContext context;
  final List<dynamic> following;
  List<AppUser> followingList = [];
  bool _isInitUserRunning = false; 

  FollowingController({
    required this.context,
    required this.following,
  }){
    initUser();
  }

  Future <void> initUser() async {
  if (_isInitUserRunning) {
    return;
  }
  _isInitUserRunning = true;
  followingList.clear(); 
  for (var uid in following) {
    AppUser user = AppUser();
    Map<String, dynamic>? userData = await user.readUserData(uid);
    if (userData != null) {
      followingList.add(AppUser.fromJson(userData));
    }
  }
  _isInitUserRunning = false;
  notifyListeners(); 
}

}
