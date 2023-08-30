import 'package:untitled_app/models/post_handler.dart' show Post;

class Cache {
  List<Post> posts;
  bool end;
  Cache({required this.posts, required this.end});
}

class FeedPostCache {
  List<Cache> postsList = List.generate(4, (index) => Cache(posts: [], end: false));
}
