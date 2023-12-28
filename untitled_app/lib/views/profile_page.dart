import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/custom_widgets/post_loader.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../custom_widgets/profile_page_header.dart';
import '../controllers/profile_controller.dart';
import '../custom_widgets/pagination.dart';
import '../custom_widgets/post_card.dart';
import '../utilities/constants.dart' as c;
import 'package:flutter/services.dart';
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Theme.of(context).colorScheme.background,
     // set Status bar color in Android devices
    statusBarIconBrightness: (Theme.of(context).brightness == Brightness.dark) ? Brightness.light:Brightness.dark, // set Status bar icons color in Android devices
    statusBarBrightness: Theme.of(context).brightness, // set Status bar icon color in iOS
  )
); 
    return ChangeNotifierProvider(
      create: (context) => ProfileController(context: context),
      builder: (context, child) {
        return WillPopScope(
            onWillPop: () =>
                Provider.of<ProfileController>(context, listen: false)
                    .onWillPop(),
            child: Scaffold(
              body: PaginationPage(
                  getter: Provider.of<ProfileController>(context, listen: false)
                      .getProfilePosts,
                  card: profilePostCardBuilder,
                  startAfterQuery:
                      Provider.of<ProfileController>(context, listen: false)
                          .getTimeFromPost,
                  header: const _Header(),
                  initialLoadingWidget: const PostLoader(),
                  extraRefresh:
                      Provider.of<ProfileController>(context, listen: false)
                          .onPageRefresh),
            ));
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<ProfileController>(
          builder: (context, profileController, _) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Row(
                  children: [
                    Text(
                      "@${profileController.user.username}",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    const Spacer(),
                    IconButton(
                      color: Theme.of(context).colorScheme.onBackground,
                      onPressed: () =>
                          Provider.of<ProfileController>(context, listen: false)
                              .settingsButtonPressed(),
                      icon: const Icon(
                        Icons.settings_outlined,
                        
                        size: 25,
                        weight: 10,
                      ),
                    ),
                  ],
                ),
              ),
              ProfileHeader(
                username: profileController.user.username,
                profilePic: profileController.user.profilePicture,
                likes: profileController.user.likes,
                following: profileController.user.following,
                followers: profileController.user.followers,
                profileBio: profileController.user.bio,
                name: profileController.user.name,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.1,
                child: TextButton(
                  style: TextButton.styleFrom(
                    side: BorderSide(
                        width: 2,
                        color: Theme.of(context).colorScheme.onBackground),
                  ),
                  onPressed: () =>
                      Provider.of<ProfileController>(context, listen: false)
                          .editProfilePressed(),
                  child: Text(
                    AppLocalizations.of(context)!.editProfile,
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 1,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: Theme.of(context).colorScheme.outline,
          height: c.dividerWidth,
        ),
      ],
    );
  }
}
