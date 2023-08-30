import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FeedController extends ChangeNotifier {
  int index = 2;
  Query<Map<String, dynamic>>? query = FirebaseFirestore.instance
      .collection("posts")
      .orderBy('time', descending: true);

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
