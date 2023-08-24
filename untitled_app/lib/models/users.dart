import 'package:cloud_firestore/cloud_firestore.dart';
import '../utilities/locator.dart';
import '../models/current_user.dart';

class AppUser {
  String firstName;
  String lastName;
  String username;
  String profileImage;
  int likes;
  int followers;
  int following;

  AppUser({
    this.firstName = '',
    this.lastName = '',
    this.likes = 0,
    this.followers = 0,
    this.following = 0,
    this.username = '',
    this.profileImage =
        "https://firebasestorage.googleapis.com/v0/b/untitled-2832f.appspot.com/o/profile_pictures%2Fdefault%2Fprofile.jpg?alt=media&token=2543c4eb-f991-468f-9ce8-68c576ffca7c",
  });

  Future<Map<String, dynamic>?> readUserData(String uid,
      {bool checkCurrentUser = false}) async {


    //checks if post author is the current user because then data can be saved by not getting there info. Must have toggle so that profile doesn't try to save data.
    if (checkCurrentUser) {
      if (uid == locator<CurrentUser>().getUID()) {

        profileImage = locator<CurrentUser>().profileImage;
        followers = locator<CurrentUser>().followers;
        following = locator<CurrentUser>().following;
        likes = locator<CurrentUser>().likes;
        username = locator<CurrentUser>().username;
        firstName = locator<CurrentUser>().firstName;
        lastName = locator<CurrentUser>().firstName;
        return null;
      }
    }
    final userRef = FirebaseFirestore.instance.collection("users");
    final data = await userRef.doc(uid).get(); //FIXME need exception handleing
    final userData = data.data();
    if (userData != null) {
    
      profileImage = userData['profileData']['profilePicture'];
      followers = userData['profileData']['followers'];
      following = userData['profileData']['following'];
      likes = userData['profileData']['likes'];
      username = userData['username'];
      firstName = userData['name']['firstName'];
      lastName = userData['name']['lastName'];
    }
    return userData;
  }
}
