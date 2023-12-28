import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/custom_widgets/controllers/pagination_controller.dart';
import 'package:untitled_app/models/users.dart';
import 'package:untitled_app/utilities/locator.dart';
import '../models/search_model.dart';
import 'dart:async';
import '../utilities/constants.dart' as c;
import '../models/current_user.dart';
import 'bottom_nav_bar_controller.dart';

class SearchPageController extends ChangeNotifier {
  final searchTextController = TextEditingController();
  final BuildContext context;
  SearchPageController({required this.context});
  bool isLoading = false;
  String query = "";
  Timer? _debounce;

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<PaginationGetterReturn> getter(dynamic page) async {
    if (isLoading) {
      //forces loading animation
      return PaginationGetterReturn(end: false, payload: []);
    } else {
      page = page ?? 0;
      List<AppUser> list = await SearchModel().hitsQuery(query, page: page);
      //remove current user
      int offset = 0;//controls end logic
      for (int i = 0; i < list.length; i++) {
        if (list[i].uid == locator<CurrentUser>().getUID()) {
          list.removeAt(i);
          offset = 1;
          break;
        }
      }

      return PaginationGetterReturn(
          end: (list.length < (c.usersOnSearch - offset)), payload: list);
    }
  }

  dynamic startAfterQuery(dynamic lastUser) {
    lastUser as AppUser;
    if (lastUser.pageIndex == null) {
      return 0;
    } else {
      return lastUser.pageIndex! + 1;
    }
  }

  Future<bool> onWillPop() async {
    locator<NavBarController>().goBranch(0);
    return false;
  }

  void onSearchTextChanged(String s) async {
    isLoading = true;
    notifyListeners();

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(
      const Duration(milliseconds: c.searchPageDebounce),
      () async {
        query = s;
        isLoading = false;
        notifyListeners();
      },
    );
  }
}
