import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/current_user.dart';
import '../../utilities/locator.dart';
import '../../models/post_handler.dart' show Post;
import '../../models/feed_post_cache.dart' show FeedPostCache;

class PostCardController extends ChangeNotifier {
  BuildContext context;
  Post post;
  late int likes;
  late bool liked;
  bool liking = false;
  PostCardController({required this.context, required this.post}) {
    liked = locator<CurrentUser>().checkIsLiked(post.postID);
    likes = post.likes;

    notifyListeners();
  }

  iconPressed() async {
    if (post.uid != locator<CurrentUser>().getUID()) {
      await context.pushNamed("sub_profile", extra: post);
      //update post liked in sub menu
      final newvalue = locator<CurrentUser>().checkIsLiked(post.postID);
      if (liked != newvalue) {
        liked = newvalue;
        likes += newvalue ? 1 : -1;
      }
      notifyListeners();
    } else {
      context.go("/profile");
    }
  }

  likePressed() async {
    if (post.uid != locator<CurrentUser>().getUID()) {
      if (!liking) {
        liking = true;
        liked = locator<CurrentUser>()
            .checkIsLiked(post.postID); //prevent user from double likeing

        if (liked) {
          liked = false;
          locator<FeedPostCache>().updateLikes(post.postID, -1);
          likes--;
          //undo if it fails. maybe remove this
          if (!await locator<CurrentUser>().removeLike(post.postID)) {
            liked = true;
            locator<FeedPostCache>().updateLikes(post.postID, 1);
            likes++;
          }
        } else {
          liked = true;
          locator<FeedPostCache>().updateLikes(post.postID, 1);
          likes++;
          //undo if it fails
          if (!await locator<CurrentUser>().addLike(post.postID)) {
            liked = false;
            locator<FeedPostCache>().updateLikes(post.postID, -1);
            likes--;
          }
        }
        notifyListeners();
        liking = false;
      }
    }
  }
}
