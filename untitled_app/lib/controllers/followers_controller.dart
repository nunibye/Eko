import 'package:flutter/material.dart';
import 'package:untitled_app/utilities/locator.dart';
import 'package:untitled_app/models/users.dart';

class FollowersController extends ChangeNotifier {
  final BuildContext context;
  final List<dynamic> followers;
  List<AppUser> followersList = [];
  bool _isInitUserRunning = false; 

  FollowersController({
    required this.context,
    required this.followers,
  }){
    initUser();
  }

  Future <void> initUser() async {
  if (_isInitUserRunning) {
    return;
  }
  _isInitUserRunning = true;
  followersList.clear(); 
  for (var uid in followers) {
    AppUser user = AppUser();
    Map<String, dynamic>? userData = await user.readUserData(uid);
    if (userData != null) {
      followersList.add(AppUser.fromJson(userData));
    }
  }
  _isInitUserRunning = false;
  notifyListeners(); 
}

}
