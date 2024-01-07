import 'package:flutter/material.dart';
import 'package:untitled_app/controllers/following_controller.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled_app/models/users.dart';
import '../custom_widgets/searched_user_card.dart';
import '../custom_widgets/pagination.dart';

class Following extends StatelessWidget {
  final AppUser user;

  const Following({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;

    return ChangeNotifierProvider(
        create: (context) => FollowingController(context: context, rootUser: user),
        builder: (context, child) {
          // FollowingController controller =
          //     Provider.of<FollowingController>(context);

          // if (controller.followingList.isEmpty) {
          //   return const Center(
          //     child: SizedBox(
          //       width: 50,
          //       height: 50,
          //       child: CircularProgressIndicator(),
          //     ),
          //   );
          // } else {
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
                AppLocalizations.of(context)!.following,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Lato',
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            body: PaginationPage(
                getter: Provider.of<FollowingController>(context, listen: false)
                    .userGetter,
                card: searchPageBuilder,
                startAfterQuery: Provider.of<FollowingController>(context, listen: false)
                    .startAfterQuery),
            // Padding(
            //   padding: EdgeInsets.all(height * 0.02),
            //   child:

            //   Column(
            //     children: [
            //       Expanded(
            //         child: ListView.builder(
            //           itemCount: Provider.of<FollowingController>(context,
            //                   listen: true)
            //               .followingList
            //               .length,
            //           itemBuilder: (BuildContext context, int index) {
            //             return UserCard(
            //                 user: Provider.of<FollowingController>(context,
            //                         listen: true)
            //                     .followingList[index]);
            //           },
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          );
        });
  }
}
