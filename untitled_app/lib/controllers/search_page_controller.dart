import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled_app/models/users.dart';
import '../models/search_model.dart';
import 'dart:async';
import '../utilities/constants.dart' as c;

class SearchPageController extends ChangeNotifier {
  final searchTextController = TextEditingController();

  bool isLoading = false;

  List<AppUser> hits = [];
  Timer? _debounce;

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

        isLoading = false;
        notifyListeners();
      }
    });
  }
}
