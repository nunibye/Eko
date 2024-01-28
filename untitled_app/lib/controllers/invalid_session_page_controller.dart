import 'package:flutter/foundation.dart';
import 'package:untitled_app/models/current_user.dart';
import 'package:untitled_app/models/presence_manager.dart';

import '../utilities/locator.dart';

class InvalidSessionPageController extends ChangeNotifier {
  bool loading = false;
  Future<void> validate() async {
    if (!loading) {
      loading = true;
      notifyListeners();
      await locator<CurrentUser>().readCurrentUserData();
      await locator<PresenceManager>().updateSessionId();
      loading = false;
      notifyListeners();
    }
  }
}
