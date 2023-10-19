import 'package:flutter/material.dart';
import '../utilities/locator.dart';
import '../models/current_user.dart';

class EditProfileController extends ChangeNotifier {
  String profileImage = locator<CurrentUser>().profilePicture;
  String profileBio = locator<CurrentUser>().bio;

  final bioController = TextEditingController(text: locator<CurrentUser>().bio);
  final bioFocus = FocusNode();
  // int bioNewLines = '\n'.allMatches(locator<CurrentUser>().bio).length;
  // int bioBodyChars = locator<CurrentUser>().bio.length;

  final nameController =
      TextEditingController(text: locator<CurrentUser>().name);
  final nameFocus = FocusNode();
  // int bioNameBodyChars = locator<CurrentUser>().bioName.length;

  int titleChars = 0;
  bool showBioCounts = false;
  bool showBioNameCounts = false;

  editProfileImagePressed() async {
    //FIXME crashes if you exit before function finishes
    if (await locator<CurrentUser>().setProfileImage() == "success") {
      profileImage = locator<CurrentUser>().profilePicture;

      notifyListeners();
    } else {}
  }

  // updateCountsBio(String str) {
  //   bioBodyChars = str.length;
  //   bioNewLines = '\n'.allMatches(str).length;
  //   notifyListeners();
  // }

  // updateCountsBioName(String str) {
  //   bioNameBodyChars = str.length;
  //   notifyListeners();
  // }

  showCountsBio(bool show) {
    showBioCounts = show;
    if (!show) {
      bioFocus.unfocus();
    }
    notifyListeners();
  }

  showCountsName(bool show) {
    showBioNameCounts = show;
    if (!show) {
      nameFocus.unfocus();
    }
    notifyListeners();
  }

  saveBioData(String bio) async {
    // TODO: This will eventually need to upload all the data that changed as profile editing gets larger
    // Im thinking a 'save' and 'cancel' button pops up on the app bar is an edit is detected
    if (await locator<CurrentUser>().uploadProfileBio(bio) == "success") {
      locator<CurrentUser>().bio = bio;
      notifyListeners();
    } else {}
  }

  saveNameData(String bioName) async {
    if (await locator<CurrentUser>().uploadProfileBioName(bioName) ==
        "success") {
      locator<CurrentUser>().name = bioName;
      notifyListeners();
    } else {}
  }
}
