import 'package:flutter/material.dart';
import '../locator.dart';
import '../models/current_user.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditProfileController extends ChangeNotifier {
  String profileImage = locator<CurrentUser>().profileImage;

  editProfilePressed() async {
    if (await locator<CurrentUser>().setProfileImage() == "success") {
      await CachedNetworkImage.evictFromCache(locator<CurrentUser>().profileImage);
      profileImage = locator<CurrentUser>().profileImage;
      notifyListeners();
    }
  }
}
