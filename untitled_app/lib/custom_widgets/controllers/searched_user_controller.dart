import 'package:flutter/material.dart';
import 'package:untitled_app/models/users.dart';
import 'package:go_router/go_router.dart';

class SearchedUserController extends ChangeNotifier {
  final AppUser user;
  final BuildContext context;
  SearchedUserController({required this.user, required this.context});

  void onCardPressed() {
    context.pushNamed("sub_profile", extra: user);
  }
}
