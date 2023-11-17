import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled_app/models/firebase_helper.dart';
class NotificationPreference {
  static const NOTIFICATION_STATUS = "NOTIFICATIONSTATUS";

  setNotificationPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(NOTIFICATION_STATUS, value);
  }

  Future<bool> getNotificationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? value = prefs.getBool(NOTIFICATION_STATUS);
    if (value == null) {
      await setNotificationPreference(true);
      await FirebaseHelper.subscribeToTopic('new_post');
      return true;
    }
    return value;
  }
}
