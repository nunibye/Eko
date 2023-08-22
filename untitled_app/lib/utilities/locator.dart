import 'package:get_it/get_it.dart';
import '../models/current_user.dart';
import '../models/posts.dart';

final locator = GetIt.instance;
void setupLocator() {
  locator.registerSingleton<CurrentUser>(CurrentUser());
  locator.registerSingleton<PostsHandling>(PostsHandling());
}
