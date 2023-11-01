import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:untitled_app/custom_widgets/controllers/feed_builder_controller.dart';
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

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      notificationService.postNotification(context, message);
      rebuildFunction();
      // String postID = message.data['postId'];
      // Access the postId from the data payload
      // Navigate to the specific post using the retrieved postID
      // context.go("/feed/post/$postID");
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

  getQueryFromIndex() {
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
