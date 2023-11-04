import 'package:flutter/material.dart';
import 'package:untitled_app/utilities/notification_preference.dart';

class NotificationProvider with ChangeNotifier {
  NotificationPreference notificationPreference = NotificationPreference();
  bool _notificationEnabled = true;

  NotificationProvider() {
    _loadNotificationPrefs(); // Initialize _notificationEnabled during construction
  }

  bool get notificationEnabled => _notificationEnabled;

  set notificationEnabled(bool value) {
    _notificationEnabled = value;
    notificationPreference.setNotificationPreference(value);
    notifyListeners();
  }

  Future<void> _loadNotificationPrefs() async {
    _notificationEnabled =
        await notificationPreference.getNotificationPreference();
    notifyListeners();
  }
}
