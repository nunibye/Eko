import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'bottom_nav_bar_controller.dart';
import '../utilities/locator.dart';

class ProfilePictureDetailController extends ChangeNotifier {
  final BuildContext context;
  ProfilePictureDetailController({required this.context});
  void backgroundPressed() {
    // locator<NavBarController>().enable();
    context.pop();
  }
}
