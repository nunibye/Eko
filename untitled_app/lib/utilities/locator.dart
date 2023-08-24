import 'package:get_it/get_it.dart';
import '../models/current_user.dart';
import '../models/post_handler.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';

final locator = GetIt.instance;
void setupLocator(context) {
  locator.registerSingleton<CurrentUser>(CurrentUser());
  locator.registerSingleton<PostsHandling>(PostsHandling());
  locator.registerSingleton<AppLocalizations>(AppLocalizations.of(context)!);
}
