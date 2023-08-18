import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CurrentUser {
  String email;
  String firstName;
  String lastName;
  String userName;

  int likes;
  int followers;
  int following;
  String username;

  ImageProvider<Object>? profileImage;

  CurrentUser({
    this.email = '',
    this.firstName = '',
    this.userName = '',
    this.lastName = '',
    this.likes = 0,
    this.followers = 0,
    this.following = 0,
    this.username = '',
    this.profileImage, // TODO: we want caching
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
        username = userData['username'];
      }
    }
  }

// FIXME: theres got to be a better way?
  Future<String?> getProfileImageUrl() async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      var urlRef = FirebaseStorage.instance
          .ref()
          .child("profile_pictures/${user?.uid}/profile.jpg");
      var imageUrl = await urlRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      return null;
    }
  }
}
