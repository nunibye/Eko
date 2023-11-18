import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:untitled_app/models/feed_post_cache.dart';
import 'package:untitled_app/utilities/locator.dart';
import '../models/users.dart';

class CurrentUser extends AppUser {
  bool newActivity;
  String email;
  List<dynamic> likedPosts;
  bool stateIsLiking = false;
  bool stateIsFollowing = false;
  CurrentUser(
      {this.email = '', this.likedPosts = const [], this.newActivity = false});

//gets uid making sure it is current. idk if this is neccesary but it will be easy to remove.
  String getUID() {
    if (uid == '') {
      uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    }
    return uid;
  }

  Future signUp(password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      uid = FirebaseAuth.instance.currentUser!.uid;
      return ("success");
    } on FirebaseAuthException catch (e) {
      return (e.code);
    }
  }

  Future signIn(password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      uid = FirebaseAuth.instance.currentUser!.uid;
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

  Future<void> _readLikedPosts() async {
    final user = getUID();
    final data = await FirebaseFirestore.instance
        .collection("users")
        .doc(user)
        .collection("arrays")
        .doc("likes")
        .get();
    likedPosts = (data.exists) ? data["likes"] : [];
  }

  Future<void> readCurrentUserData() async {
    final user = getUID();
    final userData = await readUserData(user); //uses function from parent class
    if (userData != null) {
      email = userData["email"] ?? "";
      //print(userData["newActivty"] ?? false);
      newActivity = userData["newActivity"] ?? false;
    }
    await _readLikedPosts();
  }

//TODO consolidate liking/following functions
  bool checkIsFollowing(String otherUid) {
    return following.contains(otherUid);
  }

  Future<bool> addFollower(String otherUid) async {
    if (!stateIsFollowing) {
      stateIsFollowing = true;
      try {
        final firestore = FirebaseFirestore.instance;
        final user = getUID();
        await firestore.collection("users").doc(user).update({
          "profileData.following": FieldValue.arrayUnion([otherUid])
        });
        await firestore.collection("users").doc(otherUid).update({
          "profileData.followers": FieldValue.arrayUnion([user])
        });
        following.add(otherUid);
        stateIsFollowing = false;
        return true;
      } catch (e) {
        stateIsFollowing = false;
        return false;
      }
    } else {
      return false;
    }
  }

  Future<void> setNewActivity(bool value) async {
    final firestore = FirebaseFirestore.instance;
    final user = getUID();
    newActivity = value;
    await firestore
        .collection("users")
        .doc(user)
        .set({'newActivity': value}, SetOptions(merge: true));
  }

  Future<bool> removeFollower(String otherUid) async {
    if (!stateIsFollowing) {
      stateIsFollowing = true;
      try {
        final firestore = FirebaseFirestore.instance;
        final user = getUID();
        await firestore.collection("users").doc(user).update({
          "profileData.following": FieldValue.arrayRemove([otherUid])
        });
        await firestore.collection("users").doc(otherUid).update({
          "profileData.followers": FieldValue.arrayRemove([user])
        });
        following.remove(otherUid);
        stateIsFollowing = false;
        return true;
      } catch (e) {
        stateIsFollowing = false;
        return false;
      }
    } else {
      return false;
    }
  }

  bool checkIsLiked(String postID) {
    return likedPosts.contains(postID);
  }

  Future<bool> addLike(String postId, String? commentId) async {
    if (!stateIsLiking) {
      stateIsLiking = true;
      try {
        final firestore = FirebaseFirestore.instance;
        final user = getUID();
        await firestore
            .collection("users")
            .doc(user)
            .collection("arrays")
            .doc("likes")
            .update({
          "likes": FieldValue.arrayUnion([postId])
        });
        if (commentId == null) {
          await firestore
              .collection("posts")
              .doc(postId)
              .update({"likes": FieldValue.increment(1)});
          likedPosts.add(postId);
        } else {
          await firestore
              .collection("posts")
              .doc(postId)
              .collection('comments')
              .doc(commentId)
              .update({"likes": FieldValue.increment(1)});
          likedPosts.add(commentId);
        }

        stateIsLiking = false;
        return true;
      } catch (e) {
        stateIsLiking = false;
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> removeLike(String postId, String? commentId) async {
    if (!stateIsLiking) {
      stateIsLiking = true;
      try {
        final firestore = FirebaseFirestore.instance;
        final user = getUID();
        await firestore
            .collection("users")
            .doc(user)
            .collection("arrays")
            .doc("likes")
            .update({
          "likes": FieldValue.arrayRemove([postId])
        });
        if (commentId == null) {
          await firestore
              .collection("posts")
              .doc(postId)
              .update({"likes": FieldValue.increment(-1)});
          likedPosts.remove(postId);
        } else {
          await firestore
              .collection("posts")
              .doc(postId)
              .collection('comments')
              .doc(commentId)
              .update({"likes": FieldValue.increment(-1)});
          likedPosts.remove(commentId);
        }

        stateIsLiking = false;
        return true;
      } catch (e) {
        stateIsLiking = false;
        return false;
      }
    } else {
      return false;
    }
  }

  Future<File?> setPreviewProfileImage(
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
      return null;
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
      return null;
    }
    // if (await _uploadProfilePicture(File(cropedFile.path)) == "success") {
    //   return "success";
    // }
    return File(cropedFile.path);
  }

  Future<String> uploadProfilePicture(File profile) async {
    final firestore = FirebaseFirestore.instance;
    final user = getUID();
    await FirebaseStorage.instance
        .ref()
        .child("profile_pictures/$user/profile.jpg")
        .putFile(profile);
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child("profile_pictures/$user/profile.jpg");

      profilePicture = await ref.getDownloadURL();

      firestore
          .collection('users')
          .doc(user)
          .update({"profileData.profilePicture": profilePicture});
      return "success";
    } catch (e) {
      return "fail";
    }
  }

  // TODO: This will eventually need to upload all the data that changed as profile editing gets larger
  // Im thinking a 'save' and 'cancel' button pops up on the app bar is an edit is detected
  Future<String> uploadProfileBio(String bio) async {
    final firestore = FirebaseFirestore.instance;
    final user = getUID();
    try {
      await firestore
          .collection("users")
          .doc(user)
          .update({"profileData.bio": bio});
      return "success";
    } catch (e) {
      return "fail";
    }
  }

  Future<bool> isUsernameAvailable(String username) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> uploadProfileName(String name) async {
    final firestore = FirebaseFirestore.instance;
    final user = getUID();
    try {
      await firestore.collection("users").doc(user).update({"name": name});
      return "success";
    } catch (e) {
      return "fail";
    }
  }

  Future<String> uploadProfileUsername(String username) async {
    final firestore = FirebaseFirestore.instance;
    final user = getUID();
    try {
      await firestore
          .collection("users")
          .doc(user)
          .update({"username": username});
      return "success";
    } catch (e) {
      return "fail";
    }
  }

  Future<void> addUserDataToFirestore() async {
    final user = getUID();
    final firestore = FirebaseFirestore.instance;
    final userData = {
      'uid': user,
      'email': email,
      'username': username,
      'name': name,
      'profileData': {
        'bio': '',
        'followers': [],
        'following': [],
        'likes': 0,
        'profilePicture':
            "https://firebasestorage.googleapis.com/v0/b/untitled-2832f.appspot.com/o/profile_pictures%2Fdefault%2Fprofile.jpg?alt=media&token=2543c4eb-f991-468f-9ce8-68c576ffca7c",
      }
    };
    await firestore.collection('users').doc(user).set(userData);
    await firestore
        .collection('users')
        .doc(user)
        .collection("arrays")
        .doc("likes")
        .set({"likes": []});
  }

  clearVariables() {
    uid = '';
    name = '';
    likes = 0;
    bio = '';
    followers = const [];
    following = const [];
    username = '';
    email = '';
    likedPosts = const [];
    profilePicture =
        "https://firebasestorage.googleapis.com/v0/b/untitled-2832f.appspot.com/o/profile_pictures%2Fdefault%2Fprofile.jpg?alt=media&token=2543c4eb-f991-468f-9ce8-68c576ffca7c";
  }

  // FIXME: this will probably want to handle more? Do we clear caching? Is that necessary
  signOut() {
    locator<FeedPostCache>().clearCache();
    clearVariables();
    FirebaseAuth.instance.signOut();
  }

  deleteAccount() {
    FirebaseAuth.instance.currentUser?.delete();
    clearVariables();
  }
}
