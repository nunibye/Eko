import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/current_user.dart';
import '../../utilities/locator.dart';
import '../../models/post_handler.dart' show Post;
//import '../../models/feed_post_cache.dart' show FeedPostCache;

class CommentCardController extends ChangeNotifier {
  BuildContext context;

  Post post;
  late int likes;
  late bool liked;
  bool liking = false;
  late bool isSelf;

  CommentCardController({required this.context, required this.post}) {
    liked = locator<CurrentUser>().checkIsLiked(post.postId);
    likes = post.likes;
    isSelf = post.author.uid == locator<CurrentUser>().getUID();

    notifyListeners();
  }

  avatarPressed() async {
    if (post.author.uid != locator<CurrentUser>().getUID()) {
      await context.push("/feed/sub_profile/${post.author.uid}",
          extra: post.author);
      //update post liked in sub menu
      final newvalue = locator<CurrentUser>().checkIsLiked(post.postId);
      if (liked != newvalue) {
        liked = newvalue;
        likes += newvalue ? 1 : -1;
      }
      notifyListeners();
    } else {
      context.go("/profile");
    }
  }

  tagPressed(String username) async {
    String? uid = await locator<CurrentUser>().getUidFromUsername(username);
    if (locator<CurrentUser>().getUID() == uid) {
      context.go("/profile");
    } else {
      context.push("/feed/sub_profile/$uid");
    }
  }

  likePressed() async {
    if (post.author.uid != locator<CurrentUser>().getUID()) {
      if (!liking) {
        liking = true;
        liked = locator<CurrentUser>()
            .checkIsLiked(post.postId); //prevent user from double likeing

        if (liked) {
          liked = false;
          //locator<FeedPostCache>().updateLikes(post.postId, -1);
          likes--;
          notifyListeners();
          //undo if it fails. maybe remove this
          if (!await locator<CurrentUser>()
              .removeLike(post.rootPostId!, post.postId)) {
            liked = true;
            //locator<FeedPostCache>().updateLikes(post.postId, 1);
            likes++;
            notifyListeners();
          }
        } else {
          liked = true;
          //locator<FeedPostCache>().updateLikes(post.postId, 1);
          likes++;
          notifyListeners();
          //undo if it fails
          if (!await locator<CurrentUser>()
              .addLike(post.rootPostId!, post.postId)) {
            liked = false;
            //locator<FeedPostCache>().updateLikes(post.postId, -1);
            likes--;
            notifyListeners();
          }
        }

        liking = false;
      }
    }
  }
}
