import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class CurrentUser {
  String email;
  String firstName;
  String lastName;
  String userName;

  int likes;
  int followers;
  int following;
  String username;

  String profileImage;

  CurrentUser({
    this.email = '',
    this.firstName = '',
    this.userName = '',
    this.lastName = '',
    this.likes = 0,
    this.followers = 0,
    this.following = 0,
    this.username = '',
    this.profileImage =
        'https://static.vecteezy.com/system/resources/thumbnails/009/734/564/small_2x/default-avatar-profile-icon-of-social-media-user-vector.jpg', // TODO: we want caching
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
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      readUserData(); // atm this works when user logs in it loads the data, will inevitably change this
      return ("success");
    } on FirebaseAuthException catch (e) {
      return (e.code);
    }
  }

  Future forgotPassword(countryCode) async {
    await FirebaseAuth.instance.setLanguageCode(countryCode);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      readUserData(); // atm this works when user logs in it loads the data, will inevitably change this
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
        username = userData['username'];
        print(likes);
      }
    }
  }

  setProfileImage(
      {ImageSource source = ImageSource.gallery,
      int imageQuality = 100,
      imageHeight = 150.0}) async {
    final ImagePicker imagePicker = ImagePicker();
    final ImageCropper imageCropper = ImageCropper();
    XFile? pickedFile;
    CroppedFile? cropedFile;
    pickedFile = await imagePicker.pickImage(
        maxHeight: imageHeight, source: source, imageQuality: imageQuality);
    if (pickedFile == null) {
      return "fail";
    }

    cropedFile = await imageCropper.cropImage(
        sourcePath: pickedFile.path,
        cropStyle: CropStyle.circle,
        aspectRatio: const CropAspectRatio(ratioX: 300, ratioY: 300),
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
    if (_uploadProfilePicture(File(cropedFile.path)) == "success") {
      return "success";
    }
    return "fail";
  }

  _uploadProfilePicture(File profile) async {
    final user = FirebaseAuth
        .instance.currentUser; //FIXME Move somewhere where we can save data
    await FirebaseStorage.instance
        .ref()
        .child("profile_pictures/${user?.uid}/profile.jpg")
        .putFile(profile);
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child("profile_pictures/${user!.uid}/profile.jpg");
      profileImage = await ref.getDownloadURL();
      return "success";
    } catch (e) {
      return "fail";
    }
  }

// FIXME: theres got to be a better way?
//   Future<String?> getProfileImageUrl() async {
//     final user = FirebaseAuth.instance.currentUser;

//     try {
//       var urlRef = FirebaseStorage.instance
//           .ref()
//           .child("profile_pictures/${user?.uid}/profile.jpg");
//       var imageUrl = await urlRef.getDownloadURL();
//       return imageUrl;
//     } catch (e) {
//       return null;
//     }
//   }
}
