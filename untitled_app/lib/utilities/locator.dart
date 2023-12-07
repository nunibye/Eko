import 'package:get_it/get_it.dart';
import 'package:untitled_app/models/notification_service.dart';
import 'package:untitled_app/utilities/router_notifier.dart';
import '../models/current_user.dart';
import '../models/post_handler.dart';
import '../controllers/bottom_nav_bar_controller.dart';
import '../models/feed_post_cache.dart';

final locator = GetIt.instance;
void setupLocator() {
  locator.registerLazySingleton<CurrentUser>(() => CurrentUser());
  locator.registerLazySingleton<PostsHandling>(() => PostsHandling());
  locator.registerSingleton<NavBarController>(NavBarController());
  locator.registerLazySingleton<FeedPostCache>(() => FeedPostCache());
  locator.registerSingleton<RouterNotifier>(RouterNotifier());
  locator.registerSingleton<NotificationService>(NotificationService());
}
