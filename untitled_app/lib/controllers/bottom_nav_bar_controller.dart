import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled_app/models/current_user.dart';
import 'package:untitled_app/utilities/locator.dart';

class NavBarController extends ChangeNotifier {
  late StatefulNavigationShell navigationShell;
  void goBranch(int index) {
    if (locator<CurrentUser>().getUID() == '') {
      return;
    }
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  bool enabled = true;
  disable() {
    enabled = false;
    notifyListeners();
  }

  enable() {
    enabled = true;
    notifyListeners();
  }
}
