import 'package:flutter/material.dart';


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

  bool loading = false;
  bool end = false;
  final ScrollController scrollController = ScrollController();
  List<dynamic> items = [];

  PaginationController(
      {required this.extraRefresh,
      required this.getter,
      required this.context,
      required this.startAfterQuery}) {
    init();
  }
  void init() async {
    scrollController.addListener(() => _onScroll());
    if (items.isEmpty) {
      final returned = await getter(null); //should be passed null
      end = returned.end;
      items.addAll(returned.payload);
      
    }
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
    end = false;
    items = [];
    final returned = await getter(null); //should be passed null
    end = returned.end;
    items.addAll(returned.payload);
    if (extraRefresh != null) {
      extraRefresh!();
    }
  }
}
