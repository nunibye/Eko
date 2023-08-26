import 'package:get_it/get_it.dart';
import '../models/current_user.dart';
import '../models/post_handler.dart';
import '../controllers/bottom_nav_bar_controller.dart';

final locator = GetIt.instance;
void setupLocator() {
  locator.registerSingleton<CurrentUser>(CurrentUser());
  locator.registerLazySingleton<PostsHandling>(() => PostsHandling());
  locator.registerSingleton<NavBarController>(NavBarController());
}