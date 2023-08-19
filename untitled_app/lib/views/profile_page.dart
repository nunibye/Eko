import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../custom_widgets/profile_page_top.dart';
import '../controllers/profile_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileController(), // Provide the ViewModel
      child: ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Provider.of<ProfileController>(context);
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: MediaQuery.sizeOf(context).width * 0.26,child: ClipOval(
                  
                  child: CachedNetworkImage(
                                imageUrl: Provider.of<ProfileController>(
                                        context,
                                        listen: true)
                                    .profileImage,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                ),),
                const SizedBox(height: 10),
                Text(
                  Provider.of<ProfileController>(context, listen: true).username,
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 1,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfilePageTopNumberDisplay(
                  number: Provider.of<ProfileController>(context, listen: true).likes,
                  label: AppLocalizations.of(context)!.likes),
              ProfilePageTopNumberDisplay(
                  number: Provider.of<ProfileController>(context, listen: true).followers,
                  label: AppLocalizations.of(context)!.followers),
              ProfilePageTopNumberDisplay(
                  number: Provider.of<ProfileController>(context, listen: true).following,
                  label: AppLocalizations.of(context)!.following),
            ],
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
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    onPressed: () => profileController.editProfilePressed(), // why does this break if i change to Provider.of<ProfileController>(context)?
                    child: Text(
                      AppLocalizations.of(context)!.editProfile,
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 1,
                        fontWeight: FontWeight.normal,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
