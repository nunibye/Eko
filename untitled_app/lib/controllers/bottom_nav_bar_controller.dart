import 'package:flutter/foundation.dart';

class NavBarController extends ChangeNotifier {
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
