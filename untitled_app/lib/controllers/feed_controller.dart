import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:untitled_app/custom_widgets/controllers/feed_builder_controller.dart';
import 'bottom_nav_bar_controller.dart';
import '../utilities/locator.dart';
import 'package:untitled_app/models/notification_service.dart';
// import 'package:untitled_app/utilities/locator.dart';

class FeedController extends ChangeNotifier {
  int index = 2;
  bool rebuild;
  Query<Map<String, dynamic>>? query = FirebaseFirestore.instance
      .collection("posts")
      .orderBy('time', descending: true);
  final BuildContext context;

  FeedController({required this.context, required this.rebuild}) {
    if (rebuild) {
      rebuildFunction();
    }
    NotificationService notificationService = NotificationService();
    
    // Handling the initial message received when the app is launched from dead (killed state)
    // When the app is killed and a new notification arrives when user clicks on it
    // It gets the data to which screen to open
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        notificationService.postNotification(context, message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      notificationService.postNotification(context, message);
      rebuildFunction();
    });
  }

  void rebuildFunction() {
    notifyListeners();
  }

  void onTabPressed(int newIndex) {
    index = newIndex;
    getQueryFromIndex();
    notifyListeners();
  }
  void onNotificationButtonPressed(){
    context.push('/feed/recent');
  }

  void getQueryFromIndex() {
    switch (index) {
      case 0:
        query = null;
        break;
      case 1:
        query = FirebaseFirestore.instance
            .collection("posts")
            .orderBy('likes', descending: true);
        break;
      case 2:
        query = FirebaseFirestore.instance
            .collection("posts")
            .orderBy('time', descending: true);
        break;
      case 3:
        query = FirebaseFirestore.instance
            .collection("posts")
            .orderBy('time', descending: false);
        break;
      default:
        query = null;
        break;
    }
  }
}
