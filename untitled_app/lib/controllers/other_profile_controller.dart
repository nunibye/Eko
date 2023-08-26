import 'package:flutter/widgets.dart';
import '../models/post_handler.dart' show Post;

class OtherProfileController extends ChangeNotifier {
  final BuildContext context;
  final Post? post;
  int likes = 0;
  int followers = 0;
  int following = 0;
  String username = "";
  String profileImage = "";
  String uid = "";

  OtherProfileController({required this.context, required this.post}) {
    if (post != null) {
      uid = post!.uid;
      likes = post!.userLikes;
      followers = post!.followers;
      following = post!.following;
      username = post!.username;
      profileImage = post!.profilePic;
    }
  }

  onPageRefresh() {}
}
