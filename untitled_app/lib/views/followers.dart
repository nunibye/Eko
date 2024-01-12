import 'package:flutter/material.dart';
import 'package:untitled_app/controllers/followers_controller.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../custom_widgets/searched_user_card.dart';
import '../custom_widgets/pagination.dart';
import 'package:untitled_app/models/users.dart';

class Followers extends StatelessWidget {
  final AppUser user;

  const Followers({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;

    return ChangeNotifierProvider(
        create: (context) =>
            FollowersController(context: context, rootUser: user),
        builder: (context, child) {
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
                  
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.all(height * 0.02),
              child: PaginationPage(
                  getter:
                      Provider.of<FollowersController>(context, listen: false)
                          .userGetter,
                  card: searchPageBuilder,
                  startAfterQuery:
                      Provider.of<FollowersController>(context, listen: false)
                          .startAfterQuery,
                  extraRefresh:
                      Provider.of<FollowersController>(context, listen: false)
                          .onRefresh),

              // Column(
              //   children: [
              //     Expanded(
              //       child: ListView.builder(
              //         itemCount: Provider.of<FollowersController>(context,
              //                 listen: true)
              //             .followersList
              //             .length,
              //         itemBuilder: (BuildContext context, int index) {
              //           return UserCard(
              //               user: Provider.of<FollowersController>(context,
              //                       listen: true)
              //                   .followersList[index]);
              //         },
              //       ),
              //     ),
              //   ],
              // ),
            ),
          );
        });
  }
}
