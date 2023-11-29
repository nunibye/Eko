import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled_app/models/notification_service.dart';
import 'package:untitled_app/utilities/locator.dart';
import '../models/current_user.dart';
import 'package:go_router/go_router.dart';
import '../models/post_handler.dart';
import '../custom_widgets/controllers/pagination_controller.dart'
    show PaginationGetterReturn;

class FeedController extends ChangeNotifier {
  int index = 2;
  bool rebuild;
  Query<Map<String, dynamic>>? query = FirebaseFirestore.instance
      .collection("posts")
      .orderBy('time', descending: true);
  final BuildContext context;
  bool newActivity = false;

  FeedController({required this.context, required this.rebuild}) {
    NotificationService notificationService = NotificationService();
    if (rebuild) {
      rebuildFunction();
    }
    checkNewActivity();
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
  void checkNewActivity() {
    newActivity = locator<CurrentUser>().newActivity;
  }

  void rebuildFunction() {
    notifyListeners();
  }

  void onTabPressed(int newIndex) {
    index = newIndex;
    getQueryFromIndex();
    notifyListeners();
  }

  void onNotificationButtonPressed() {
    context.push('/feed/recent').then((v) async {
      checkNewActivity();
      notifyListeners();
    });
  }

  void onRefresh() {
    if (index == 0) {
      locator<PostsHandling>().feedChunks.clear();
    }
  }

  Future<PaginationGetterReturn> getPosts(dynamic time) {
    return locator<PostsHandling>().getFeedPosts(time, query, index);
  }

  dynamic getTimeFromPost(dynamic post) {
    if (index != 1) {
      return locator<PostsHandling>().getTimeFromPost(post);
    } else {
      return (post as Post).likes;
    }
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
