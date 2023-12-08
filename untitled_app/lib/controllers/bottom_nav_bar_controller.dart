import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

class NavBarController extends ChangeNotifier {
  late StatefulNavigationShell navigationShell;
  void goBranch(int index) {
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
