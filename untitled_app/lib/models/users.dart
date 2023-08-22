import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String firstName;
  String lastName;
  String username;
  String profileImage;
  User({
    this.firstName = "",
    this.lastName = "",
    this.username = "",
    this.profileImage = "",
  });
  getUserFromUID(String uid) async {
    final userRef = FirebaseFirestore.instance.collection("users");
    final data = await userRef.doc(uid).get();//FIXME need exception handleing
    final userData = data.data();
    if (userData != null) {
      profileImage = userData['profileData']['profilePicture'];
      username = userData['username'];
      firstName = userData['name']['firstName'];
      lastName = userData['name']['lastName'];
    }
  }
}
