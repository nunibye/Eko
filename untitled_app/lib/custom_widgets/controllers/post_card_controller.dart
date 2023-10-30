import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/current_user.dart';
import '../../utilities/locator.dart';
import '../../models/post_handler.dart';
import '../../models/feed_post_cache.dart' show FeedPostCache;
import 'package:share_plus/share_plus.dart';

class PostCardController extends ChangeNotifier {
  BuildContext context;
  Post post;
  int comments = 0;
  late int likes;
  late bool liked;
  bool liking = false;
  bool sharing = false;
  PostCardController({required this.context, required this.post}) {
    _init();
  }
  _init() async {
    liked = locator<CurrentUser>().checkIsLiked(post.postId);
    likes = post.likes;
    comments = await locator<PostsHandling>().countComments(post.postId);

    notifyListeners();
  }
//FIXME could be optomized
  postPressed(){
    context.push("/feed/post/${post.postId}", extra: post).then((v) async{
      comments = await locator<PostsHandling>().countComments(post.postId);
      notifyListeners();
    });
  }

  avatarPressed() async {
    if (post.author.uid != locator<CurrentUser>().getUID()) {
      await context.pushNamed("sub_profile", extra: post.author);
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

  sharePressed() async {
    if (!sharing) {
      sharing = true;
      await Share.shareWithResult(
          'Check out my post on Echo: https://untitled-2832f.web.app/feed/post/${post.postId}');
      sharing = false;
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
          locator<FeedPostCache>().updateLikes(post.postId, -1);
          likes--;
          notifyListeners();
          //undo if it fails. maybe remove this
          if (!await locator<CurrentUser>().removeLike(post.postId)) {
            liked = true;
            locator<FeedPostCache>().updateLikes(post.postId, 1);
            likes++;
            notifyListeners();
          }
        } else {
          liked = true;
          locator<FeedPostCache>().updateLikes(post.postId, 1);
          likes++;
          notifyListeners();
          //undo if it fails
          if (!await locator<CurrentUser>().addLike(post.postId)) {
            liked = false;
            locator<FeedPostCache>().updateLikes(post.postId, -1);
            likes--;
            notifyListeners();
          }
        }

        liking = false;
      }
    }
  }
}
