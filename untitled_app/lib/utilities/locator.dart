import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:untitled_app/controllers/feed_controller.dart';
import 'package:untitled_app/custom_widgets/controllers/feed_builder_controller.dart';
import 'package:untitled_app/models/notification_service.dart';
import 'package:untitled_app/models/users.dart';
import 'package:untitled_app/utilities/router_notifier.dart';
import '../models/current_user.dart';
import '../models/post_handler.dart';
import '../controllers/bottom_nav_bar_controller.dart';
import '../models/feed_post_cache.dart';

final locator = GetIt.instance;
void setupLocator() {
  // void setupLocator() {
    locator.registerLazySingleton<AppUser>(() => AppUser());
  locator.registerLazySingleton<CurrentUser>(() => CurrentUser());
  locator.registerLazySingleton<PostsHandling>(() => PostsHandling());
  locator.registerSingleton<NavBarController>(NavBarController());
  locator.registerLazySingleton<FeedPostCache>(() => FeedPostCache());
  locator.registerSingleton<RouterNotifier>(RouterNotifier());
  locator.registerSingleton<NotificationService>(NotificationService());
  // locator.registerLazySingleton<FeedBuilderController>(() => FeedBuilderController(
  //   firestoreQuery: null,  // Provide the appropriate query here if needed
  //   refreshFunction: null, // Provide the appropriate refresh function here if needed
  //   context: context,         // Provide the appropriate context here if needed
  //   passedUser: null,       // Provide the appropriate user object here if needed
  //   index: null,            // Provide the appropriate index here if needed
  // ));
}
