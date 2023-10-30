import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

class NotificationService {
  const NotificationService._();
  

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
    String? postId = message.data['postId'];
    print(postId);
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
    // // Extract authorID from the notification data
    // String? postID = message.data['postID'];

    // // Navigate to the specific post using named routes

    //   print("here");
    //   context.push("/feed/post/$postID");

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
  // static void onMessageOpenedApp(BuildContext? context, RemoteMessage message) async {
  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? androidNotification = message.notification?.android;
  //   AppleNotification? appleNotification = message.notification?.apple;

  //   if (notification == null) return;

  //   if ((androidNotification != null || appleNotification != null) &&
  //       context != null) {
  //     // showDialog(
  //     //   context: context,
  //     //   builder: (_) => AlertDialog(
  //     //     title: Text(notification.title ?? 'No Title'),
  //     //     content: SingleChildScrollView(
  //     //       child: Column(
  //     //         crossAxisAlignment: CrossAxisAlignment.start,
  //     //         children: [
  //     //           Text(notification.body ?? 'No body'),
  //     //         ],
  //     //       ),
  //     //     ),
  //     //   ),
  //     // );
  //     // Extract postID from the notification data
  //     String? postID = message.data['postID'];
  //     print("here");
  //     // Navigate to the specific post using named routes if context is not null
  //     context.go("/feed/post/$postID");
  //   }
  // }
}
