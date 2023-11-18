import 'package:flutter/material.dart';
 import 'package:untitled_app/utilities/locator.dart';
 import '../models/current_user.dart';
 import 'package:provider/provider.dart';
 import '../controllers/feed_controller.dart';

class RecentActivtiyController extends ChangeNotifier {
  BuildContext context;
  final String string = "str"; //remove
  RecentActivtiyController({required this.context}) {
    init();
  }
   init() async {
     await locator<CurrentUser>().setNewActivity(false);
     
   }
}
