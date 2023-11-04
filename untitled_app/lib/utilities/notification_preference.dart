import 'package:shared_preferences/shared_preferences.dart';

class NotificationPreference {
  static const NOTIFICATION_STATUS = "NOTIFICATIONSTATUS";

  setNotificationPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(NOTIFICATION_STATUS, value);
  }

  Future<bool> getNotificationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(NOTIFICATION_STATUS) ?? true;
  }
}