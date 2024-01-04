import 'package:flutter/material.dart';
import 'package:untitled_app/controllers/followers_controller.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../custom_widgets/searched_user_card.dart';

class Followers extends StatelessWidget {
  final List<dynamic> followers;

  const Followers({required this.followers, super.key});

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.sizeOf(context).height;

    return ChangeNotifierProvider(
      create: (context) =>
          FollowersController(context: context, followers: followers),
      builder: (context, child) {
        FollowersController controller =
            Provider.of<FollowersController>(context);

        if (controller.followersList.isEmpty) {
          return const Center(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded,
                    color: Theme.of(context).colorScheme.onBackground),
                onPressed: () => context.pop("poped"),
              ),
              backgroundColor: Theme.of(context).colorScheme.background,
              title: Text(
                AppLocalizations.of(context)!.followers,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Lato',
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(height * 0.02),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: Provider.of<FollowersController>(context,
                              listen: true)
                          .followersList
                          .length,
                      itemBuilder: (BuildContext context, int index) {
                        return UserCard(
                            user: Provider.of<FollowersController>(context,
                                    listen: true)
                                .followersList[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
