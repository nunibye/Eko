import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/current_user.dart';
import '../../utilities/locator.dart';
import '../../models/post_handler.dart' show Post;

class PostCardController extends ChangeNotifier {
  BuildContext context;
  Post post;
  late int likes;
  late bool liked;
  PostCardController({required this.context, required this.post}) {
    liked = locator<CurrentUser>().checkIsLiked(post.postID);
    likes = post.likes;
    notifyListeners();
  }

  iconPressed() {
    if (post.uid != locator<CurrentUser>().getUID()) {
      context.goNamed("sub_profile", extra: post);
    }
  }

  likePressed() async {
    //TODO prevent user from spamming
    if (liked) {
      if (await locator<CurrentUser>().removeLike(post.postID)) {
        liked = false;
      }
      likes--;
    } else {
      if (await locator<CurrentUser>().addLike(post.postID)) {
        liked = true;
      }
      likes++;
    }
    notifyListeners();
  }
}
