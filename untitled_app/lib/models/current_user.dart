import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../models/users.dart';

class CurrentUser extends AppUser {
  String email;
  List<dynamic> likedPosts;

  CurrentUser({this.email = '', this.likedPosts = const []});

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
    }
    await _readLikedPosts();
  }

  bool checkIsFollowing(String otherUid) {
    return following.contains(otherUid);
  }

  Future<bool> addFollower(String otherUid) async {
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
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeFollower(String otherUid) async {
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
      return true;
    } catch (e) {
      return false;
    }
  }

  bool checkIsLiked(String postID) {
    return likedPosts.contains(postID);
  }

  Future<bool> addLike(String postId) async {
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
      await firestore
          .collection("posts")
          .doc(postId)
          .update({"likes": FieldValue.increment(1)});
      likedPosts.add(postId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeLike(String postId) async {
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
      await firestore
          .collection("posts")
          .doc(postId)
          .update({"likes": FieldValue.increment(-1)});
      likedPosts.remove(postId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> setProfileImage(
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

  Future<String> _uploadProfilePicture(File profile) async {
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

      profileImage = await ref.getDownloadURL();

      firestore
          .collection('users')
          .doc(user)
          .update({"profileData.profilePicture": profileImage});
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
      'name': {
        'firstName': firstName,
        'lastName': lastName,
      },
      'profileData': {
        'followers': [],
        'following': [],
        'likes': 0,
        'profilePicture':
            "https://firebasestorage.googleapis.com/v0/b/untitled-2832f.appspot.com/o/profile_pictures%2Fdefault%2Fprofile.jpg?alt=media&token=2543c4eb-f991-468f-9ce8-68c576ffca7c",
      }
    };
    await firestore.collection('users').doc(user).set(userData);
  }
}
