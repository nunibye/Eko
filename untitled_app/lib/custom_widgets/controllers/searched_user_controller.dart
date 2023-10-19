import 'package:flutter/material.dart';
import '../../models/search_model.dart' show SearchedItem;

class SearchedUserController extends ChangeNotifier {
  final SearchedItem user;
  final BuildContext context;
  SearchedUserController({required this.user, required this.context});

  void onCardPressed() {}
}
