import 'package:flutter/material.dart';
import 'package:untitled_app/custom_widgets/shimmer_loaders.dart'
    show FeedLoader;
import 'package:untitled_app/models/current_user.dart';
import 'package:untitled_app/models/feed_post_cache.dart';
import 'package:untitled_app/utilities/locator.dart';
import '../custom_widgets/pagination.dart';
import '../custom_widgets/tab_bar.dart';
import '../controllers/feed_controller.dart';
import 'package:provider/provider.dart';
import '../custom_widgets/post_card.dart';
import '../utilities/constants.dart' as c;

class FeedPage extends StatelessWidget {
  final bool rebuild;

  const FeedPage({super.key, this.rebuild = false});

  @override
  Widget build(BuildContext context) {
    //Provider.of<FeedController>(context, listen: false).checkNewActivity();
    //return ExampleUiLoadingAnimation();
    return ChangeNotifierProvider(
      create: (context) => FeedController(context: context, rebuild: rebuild),
      builder: (context, child) {
        final width = c.widthGetter(context);
        final height = MediaQuery.sizeOf(context).height;
        //begin app bar
        final SliverAppBar appBar = SliverAppBar(
          toolbarHeight: height * 0.13,
          floating: true,
          pinned: false,
          scrolledUnderElevation: 0.0,
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.background,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: Column(
              children: [
                const Padding(
                    padding: EdgeInsets.only(bottom: 6), child: CustomTabBar()),
                Divider(
                  color: Theme.of(context).colorScheme.outline,
                  height: c.dividerWidth,
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Stack(
                children: [
                  Icon(
                    Icons.notifications,
                    color: Theme.of(context).colorScheme.onBackground,
                    size: 28,
                  ),
                  if (Provider.of<FeedController>(context, listen: true)
                      .newActivity)
                    Positioned(
                      right: 1.5,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).colorScheme.error),
                      ),
                    )
                ],
              ),
              onPressed: () =>
                  Provider.of<FeedController>(context, listen: false)
                      .onNotificationButtonPressed(),
            ),
          ],
          title: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                width: width * 0.3,
                child: Image.asset(
                    (Theme.of(context).brightness == Brightness.light)
                        ? 'images/eko_logo_light.png'
                        : 'images/eko_logo.png'),
              )),
        );
        //end app bar
        
        return Scaffold(
          body: PaginationPage(
            initialLoadingWidget: const FeedLoader(),
            appbar: appBar,
            extraRefresh:
                Provider.of<FeedController>(context, listen: false).onRefresh,
            getter:
                Provider.of<FeedController>(context, listen: false).getPosts,
            card: postCardBuilder,
            startAfterQuery: Provider.of<FeedController>(context, listen: false)
                .getTimeFromPost,
            externalData: locator<FeedPostCache>().postsList[
                Provider.of<FeedController>(context, listen: true).index],
          ),
        );
      },
    );
  }
}
