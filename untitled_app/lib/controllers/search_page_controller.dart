import 'package:flutter/material.dart';
import 'package:untitled_app/models/users.dart';
import 'package:untitled_app/utilities/locator.dart';
import '../models/search_model.dart';
import 'dart:async';
import '../utilities/constants.dart' as c;
import '../models/current_user.dart';
import 'bottom_nav_bar_controller.dart';

class SearchPageController extends ChangeNotifier {
  final searchTextController = TextEditingController();

  bool isLoading = false;

  List<AppUser> hits = [];
  Timer? _debounce;

  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  // void onSearchTextChanged(String s) async {
  //   if (s != '') {
  //     isLoading = true;
  //     notifyListeners();
  //     if (_debounce?.isActive ?? false) _debounce!.cancel();
  //     _debounce = Timer(const Duration(seconds: 1), () async {

  //       hits = await SearchModel().hitsQuery(s);
  //       print("searched");
  //       isLoading = false;
  //       notifyListeners();
  //     });
  //   } else {
  //     hits = [];
  //     print("reset");
  //     notifyListeners();
  //   }
  // }

  Future<bool> onWillPop() async {
    locator<NavBarController>().goBranch(0);
    return false;
  }

  void onSearchTextChanged(String s) async {
    if (s == '') {
      hits = [];

      isLoading = false;
      notifyListeners();
    } else {
      isLoading = true;
      notifyListeners();
    }
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce =
        Timer(const Duration(milliseconds: c.searchPageDebounce), () async {
      if (s != '') {
        hits = await SearchModel().hitsQuery(s);
        hits.removeWhere(
            (element) => element.uid == locator<CurrentUser>().getUID());
        isLoading = false;
        notifyListeners();
      }
    });
  }
}
