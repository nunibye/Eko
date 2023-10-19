import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled_app/models/users.dart';
import '../models/search_model.dart';

class SearchPageController extends ChangeNotifier {
  final searchTextController = TextEditingController();

  bool isLoading = false;

  List<AppUser> hits = [];

  void onSearchTextChanged(String s) async {
    if (s != '') {
      isLoading = true;
      notifyListeners();
      hits = await SearchModel().hitsQuery(s);

      isLoading = false;
      notifyListeners();
    } else {
      hits = [];
      notifyListeners();
    }
  }
}
