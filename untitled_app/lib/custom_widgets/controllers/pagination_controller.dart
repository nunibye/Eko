import 'package:flutter/material.dart';
import 'package:untitled_app/models/feed_post_cache.dart';
import '../../utilities/locator.dart';

class PaginationGetterReturn {
  final bool end;
  final List<dynamic> payload;
  PaginationGetterReturn({required this.end, required this.payload});
}

class PaginationController extends ChangeNotifier {
  final Future<PaginationGetterReturn> Function(dynamic) getter;
  final dynamic Function(dynamic) startAfterQuery;
  final Function()? extraRefresh;
  final BuildContext context;
  int? cacheIndex;

  bool loading = false;
  bool end = false;
  final ScrollController scrollController = ScrollController();
  List<dynamic> items = [];

  PaginationController(
      {required this.extraRefresh,
      required this.getter,
      required this.context,
      required this.startAfterQuery,
      this.cacheIndex}) {
    init();
  }
  void init() async {
    scrollController.addListener(() => _onScroll());
    if (cacheIndex == null) {
      items = [];
      end = false;
    } else {
      items = List.from(locator<FeedPostCache>().postsList[cacheIndex!].posts);
      end = locator<FeedPostCache>().postsList[cacheIndex!].end;
    }
    if (items.isEmpty) {
      final returned = await getter(null); //should be passed null
      end = returned.end;
      items.addAll(returned.payload);
    }
    notifyListeners();
  }

  rebuildFunction() {
    notifyListeners();
  }

  Future<void> _onScroll() async {
    if (!end) {
      if (scrollController.position.maxScrollExtent -
              scrollController.position.pixels <=
          MediaQuery.sizeOf(context).height * 0.2) {
        if (loading == false) {
          loading = true;
          if (items.isNotEmpty) {
            final returned = await getter(
                startAfterQuery(items.last)); //should be passed startAfter
            end = returned.end;
            items.addAll(returned.payload);
            notifyListeners();
          }

          loading = false;
        }
      }
    }
  }

  Future<void> onRefresh() async {
    if (extraRefresh != null) {
      extraRefresh!();
    }
    end = false;
    items.clear();
    if (cacheIndex != null) {
      locator<FeedPostCache>().postsList[cacheIndex!].posts.clear();
      locator<FeedPostCache>().postsList[cacheIndex!].end = false;
    }
    final returned = await getter(null); //should be passed null
    end = returned.end;
    items.addAll(returned.payload);
    // if (cacheIndex != null) {
    //   locator<FeedPostCache>().postsList[cacheIndex!].end = returned.end;
    // }
    
    notifyListeners();
  }
}
