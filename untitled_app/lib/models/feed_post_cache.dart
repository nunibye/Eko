import 'package:untitled_app/models/post_handler.dart' show Post;

class Cache {
  List<Post> posts;
  bool end;
  Cache({required this.posts, required this.end});
}

class FeedPostCache {
  List<Cache> postsList =
      List.generate(4, (index) => Cache(posts: [], end: false));

  clearCache() {
    postsList = List.generate(4, (index) => Cache(posts: [], end: false));
  }

  //TODO review, considor other solutions
  updateLikes(String id, int offset) {
    for (Cache element in postsList) {
      for (Post post in element.posts) {
        if (post.postId == id) {
          post.likes += offset;
          break; //assumes each post is only in each list one time
        }
      }
    }
  }
}
