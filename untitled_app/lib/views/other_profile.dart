import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled_app/custom_widgets/loading_spinner.dart';
import 'package:untitled_app/custom_widgets/shimmer_loaders.dart'
    show FeedLoader;
import 'package:untitled_app/custom_widgets/profile_page_header.dart';
import 'package:untitled_app/models/users.dart' show AppUser;
import 'package:untitled_app/utilities/themes/dark_theme_provider.dart';
import '../controllers/other_profile_controller.dart';
import 'package:provider/provider.dart';
import '../custom_widgets/pagination.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import '../custom_widgets/post_card.dart';
import '../utilities/constants.dart' as c;

class OtherProfile extends StatelessWidget {
  final AppUser? user;
  final String id;
  const OtherProfile({super.key, required this.user, required this.id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          OtherProfileController(context: context, passedUser: user, id: id),
      builder: (context, child) {
        return PopScope(
          canPop: Provider.of<OtherProfileController>(context, listen: false)
              .isLoggedIn(),
          child: Scaffold(
            body: Provider.of<OtherProfileController>(context, listen: true)
                        .loadedUser ==
                    null
                ? const Center(child: LoadingSpinner())
                : PaginationPage(
                    appbar: Provider.of<OtherProfileController>(context,
                                    listen: true)
                                .loadedUser ==
                            null
                        ? null
                        : SliverAppBar(
                            floating: true,
                            pinned: false,
                            scrolledUnderElevation: 0.0,
                            centerTitle: false,
                            leadingWidth: !Provider.of<OtherProfileController>(
                                        context,
                                        listen: false)
                                    .isLoggedIn()
                                ? 100
                                : null,
                            leading: Provider.of<OtherProfileController>(
                                        context,
                                        listen: false)
                                    .isLoggedIn()
                                ? IconButton(
                                    icon: Icon(Icons.arrow_back_ios_rounded,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground),
                                    onPressed: () => context.pop("popped"))
                                : TextButton(
                                    onPressed: () {
                                      context.go('/');
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!.signIn)),
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            title: Provider.of<OtherProfileController>(
                                        context,
                                        listen: false)
                                    .isLoggedIn() ? Text(
                              "@${Provider.of<OtherProfileController>(context, listen: true).loadedUser!.username}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ) : null,
                            actions: [
                              PopupMenuButton<void Function()>(
                    itemBuilder: (context) {
                      return [
                        if (!Provider.of<OtherProfileController>(context, listen: false).getBlocked())
                          PopupMenuItem(
                            height: 25,
                            value: () => Provider.of<OtherProfileController>(
                                    context,
                                    listen: false)
                                .showBlock(),
                            child: Text(AppLocalizations.of(context)!.block),
                          )
                        else
                          PopupMenuItem(
                            height: 25,
                            value: () => Provider.of<OtherProfileController>(
                                    context,
                                    listen: false)
                                .showUnblock(),
                            child: 
                                Text(AppLocalizations.of(context)!.unblock),
                                
                            ),
                          
                      ];
                    },
                    onSelected: (fn) => fn(),
                    color: Theme.of(context).colorScheme.surface,
                    child: Icon(
                      Icons.more_vert,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                            ],
                            bottom: PreferredSize(
                              preferredSize: const Size.fromHeight(3),
                              child: Divider(
                                color: Theme.of(context).colorScheme.outline,
                                height: c.dividerWidth,
                              ),
                            ),
                          ),
                    getter: Provider.of<OtherProfileController>(context,
                            listen: false)
                        .getPosts,
                    card: otherProfilePostCardBuilder,
                    startAfterQuery: Provider.of<OtherProfileController>(
                            context,
                            listen: false)
                        .getTimeFromPost,
                    header: const _Header(),
                    externalData: Provider.of<OtherProfileController>(context,
                            listen: false)
                        .loadedPostData,
                    extraRefresh: Provider.of<OtherProfileController>(context,
                            listen: false)
                        .onPageRefresh,
                    initialLoadingWidget: const FeedLoader(),
                  ),

            // FeedBuilder(
            //   user: AppUser(
            //       username:
            //           Provider.of<OtherProfileController>(context, listen: false)
            //               .loadedUser!.username,
            //       name:
            //           Provider.of<OtherProfileController>(context, listen: false)
            //               .loadedUser!.name,
            //       profilePicture:
            //           Provider.of<OtherProfileController>(context, listen: false)
            //               .loadedUser!.profilePicture,
            //       uid:
            //           Provider.of<OtherProfileController>(context, listen: false)
            //               .loadedUser!.uid),
            //   //query. Ok to be here in MVVM becasue it doesn't interact with database. Just a template for a request
            //   firestoreQuery: FirebaseFirestore.instance
            //       .collection('posts')
            //       .where("author",
            //           isEqualTo: Provider.of<OtherProfileController>(context,
            //                   listen: false)
            //               .loadedUser!.uid)
            //       .orderBy('time', descending: true),
            //   //This widget will be first in the list. use Column for this not ListView
            //   header: const _Header(),
            //   //Optional funtion to call on refresh.
            //   refreshFunction:
            //       Provider.of<OtherProfileController>(context, listen: false)
            //           .onPageRefresh,
            // )
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final width = c.widthGetter(context);
    return Column(
      children: [
        Consumer<OtherProfileController>(
          builder: (context, otherProfileController, _) => ProfileHeader(
            user: otherProfileController.loadedUser!,
            loggedIn: otherProfileController.isLoggedIn(),
          ),
        ),
        //TODO style
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: width * 0.4,
                height: width * 0.1,
                child: Provider.of<OtherProfileController>(context,
                                listen: true)
                            .loadedUser ==
                        null
                    ? null
                    : TextButton(
                        style: TextButton.styleFrom(
                          side: BorderSide(
                              width: 2,
                              color:
                                  Theme.of(context).colorScheme.onBackground),
                        ),
                        onPressed: () => Provider.of<OtherProfileController>(
                                context,
                                listen: false)
                            .onFollowPressed(),
                        child: Text(
                          Provider.of<OtherProfileController>(context,
                                      listen: true)
                                  .following
                              ? AppLocalizations.of(context)!.following
                              : AppLocalizations.of(context)!.follow,
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
