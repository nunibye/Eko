import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/locator.dart';
import 'package:untitled_app/models/current_user.dart';
import '../views/feed_page.dart';
import '../views/compose_page.dart';
import '../views/profile_page.dart';
import '../views/search_page.dart';

class BottomNavBarController extends ChangeNotifier {
  int currentIndex = 0;

  void changePage(int index) {
    currentIndex = index;
    notifyListeners();
  }

  Widget getPage() {
    switch (currentIndex) {
      case 0:
        return FeedPage();
      case 1:
        return SearchPage();
      case 2:
        return ComposePage();
      case 3:
        return ProfilePage();
      default:
        return Placeholder(); // TODO: Handle invalid index
    }
  }
}
