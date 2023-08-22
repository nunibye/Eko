import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class CurrentUser {
  String email;
  String firstName;
  String lastName;

  int likes;
  int followers;
  int following;
  String username;

  String profileImage;

  CurrentUser({
    this.email = '',
    this.firstName = '',
    this.lastName = '',
    this.likes = 0,
    this.followers = 0,
    this.following = 0,
    this.username = '',
    this.profileImage =
        'https://firebasestorage.googleapis.com/v0/b/untitled-2832f.appspot.com/o/profile_pictures%2Fdefault%2Fprofile.jpg?alt=media&token=2543c4eb-f991-468f-9ce8-68c576ffca7c', // TODO: we want caching
  });

  Future signUp(password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return ("success");
    } on FirebaseAuthException catch (e) {
      return (e.code);
    }
  }

  Future signIn(password) async {
    try {
      print("sigh2");
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("sigh1");
      return ("success");
    } on FirebaseAuthException catch (e) {
      return (e.code);
    }
  }

  Future forgotPassword(countryCode) async {
    await FirebaseAuth.instance.setLanguageCode(countryCode);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return ("success");
    } on FirebaseAuthException catch (e) {
      return (e.code);
    }
  }

  Future readUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('users')
          .where("uid", isEqualTo: user.uid)
          .get(); // Get the user's document based on their UID
      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        likes = userData['profileData']['followers']; // exmaple map querey
        followers = userData['profileData']['following']; // exmaple map querey
        following = userData['profileData']['likes'];
        profileImage = userData['profileData']['profilePicture'];
        username = userData['username'];
        print(likes);
      }
    }
  }

  setProfileImage(
      {ImageSource source = ImageSource.gallery,
      int imageQuality = 100,
      imageHeight = 300.0}) async {
    final ImagePicker imagePicker = ImagePicker();
    final ImageCropper imageCropper = ImageCropper();
    XFile? pickedFile;
    CroppedFile? cropedFile;
    pickedFile = await imagePicker.pickImage(
      source: source,
    ); //maxHeight: imageHeight,imageQuality: imageQuality
    if (pickedFile == null) {
      return "fail";
    }

    cropedFile = await imageCropper.cropImage(
        sourcePath: pickedFile.path,
        cropStyle: CropStyle.circle,
        maxHeight: 300,
        maxWidth: 300,
        aspectRatio: const CropAspectRatio(ratioX: 150, ratioY: 150),
        uiSettings: [
          AndroidUiSettings(
            showCropGrid: false,
            hideBottomControls: true,
          ),
          IOSUiSettings() //TODO make this look good
        ]);
    if (cropedFile == null) {
      return "fail";
    }
    if (await _uploadProfilePicture(File(cropedFile.path)) == "success") {
      return "success";
    }
    return "fail";
  }

  _uploadProfilePicture(File profile) async {
    final firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth
        .instance.currentUser!; //FIXME Move somewhere where we can save data
    await FirebaseStorage.instance
        .ref()
        .child("profile_pictures/${user.uid}/profile.jpg")
        .putFile(profile);
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child("profile_pictures/${user.uid}/profile.jpg");

      profileImage = await ref.getDownloadURL();

      firestore
          .collection('users')
          .doc(user.uid)
          .update({"profileData.profilePicture": profileImage});
      return "success";
    } catch (e) {
      return "fail";
    }
  }

  Future<void> addUserDataToFirestore() async {
    final user = FirebaseAuth
        .instance.currentUser; //FIXME Move somewhere where we can save data
    final firestore = FirebaseFirestore.instance;
    final userData = {
      'uid': user!.uid,
      'email': email,
      'username': username,
      'name': {
        'firstName': firstName,
        'lastName': lastName,
      },
      'profileData': {
        'followers': 0,
        'following': 0,
        'likes': 0,
        'profilePicture':
            "https://firebasestorage.googleapis.com/v0/b/untitled-2832f.appspot.com/o/profile_pictures%2Fdefault%2Fprofile.jpg?alt=media&token=2543c4eb-f991-468f-9ce8-68c576ffca7c",
      }
    };
    await firestore.collection('users').doc(user.uid).set(userData);
  }

  Future<List<Map<String, dynamic>>> getUserPosts() async {
    List<Map<String, dynamic>> postsList = [];
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('posts')
          .doc(user.uid)
          .collection('posts')
          .orderBy('time', descending: true)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        postsList = querySnapshot.docs.map((doc) => doc.data()).toList();
      }
    }
    
    return postsList;
  }
}
