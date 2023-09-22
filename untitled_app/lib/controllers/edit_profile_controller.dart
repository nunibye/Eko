import 'package:flutter/material.dart';
import '../utilities/locator.dart';
import '../models/current_user.dart';

class EditProfileController extends ChangeNotifier {
  String profileImage = locator<CurrentUser>().profileImage;
  String profileBio = locator<CurrentUser>().bio;

  final bioController = TextEditingController(text: locator<CurrentUser>().bio);
  final bioFocus = FocusNode();
  int bioNewLines = '\n'.allMatches(locator<CurrentUser>().bio).length;
  int bioBodyChars = locator<CurrentUser>().bio.length;
  int titleChars = 0;
  bool showBioCounts = false;

  editProfileImagePressed() async {
    //FIXME crashes if you exit before function finishes
    if (await locator<CurrentUser>().setProfileImage() == "success") {
      profileImage = locator<CurrentUser>().profileImage;

      notifyListeners();
    } else {}
  }

  updateCountsBody(String str) {
    bioBodyChars = str.length;
    bioNewLines = '\n'.allMatches(str).length;
    notifyListeners();
  }

  showCountsBody(bool show) {
    print(bioNewLines);
    showBioCounts = show;
    if (!show) {
      bioFocus.unfocus();
    }
    notifyListeners();
  }

  saveProfileData(String bio) async {
    // TODO: This will eventually need to upload all the data that changed as profile editing gets larger
    // Im thinking a 'save' and 'cancel' button pops up on the app bar is an edit is detected
    if (await locator<CurrentUser>().uploadProfileBio(bio) == "success") {
      locator<CurrentUser>().bio = bio;
      notifyListeners();
    } else {
    }
  }
}
