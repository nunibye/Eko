import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/controllers/bottom_nav_bar_controller.dart';
import 'package:untitled_app/models/feed_post_cache.dart';
import 'package:untitled_app/utilities/firebase_options.dart';
import 'package:untitled_app/utilities/locator.dart';
import 'package:untitled_app/controllers/feed_controller.dart';

class NotificationService extends ChangeNotifier {
  NotificationService() {
    initializeNotification();
  }
// class NotificationService {
//   const NotificationService._();

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    'high_importance_channel',
    'high_importance_channel',
    description: 'description',
    importance: Importance.max,
    playSound: true,
  );

  static NotificationDetails _notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _androidChannel.id,
        _androidChannel.name,
        channelDescription: _androidChannel.description,
        importance: Importance.max,
        priority: Priority.max,
        playSound: true,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(),
    );
  }

  static Future<void> initializeNotification() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    await _notificationsPlugin.initialize(
      const InitializationSettings(
          android: androidInitializationSettings,
          iOS: DarwinInitializationSettings()),
    );
  }

  static void onMessage(RemoteMessage message) {
    // Extract custom data from the FCM message
    RemoteNotification? notification = message.notification;
    AndroidNotification? androidNotification = message.notification?.android;
    AppleNotification? appleNotification = message.notification?.apple;

    if (notification == null) return;

    if (androidNotification != null || appleNotification != null) {
      _notificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        _notificationDetails(),
      );
    }
  }

  static void onMessageOpenedApp(BuildContext context, RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? androidNotification = message.notification?.android;
    AppleNotification? appleNotification = message.notification?.apple;

    if (notification == null) return;

    if (androidNotification != null || appleNotification != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(notification.title ?? 'No Title'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(notification.body ?? 'No body'),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<void> postNotification(
      BuildContext context, RemoteMessage message) async {
    String postID = message.data['postId'];
    locator<FeedPostCache>().clearCache(); // not refreshing
    context.go("/feed/post/$postID");
    locator<NavBarController>().enable(); // this seems odd. idk is it
  }
}
