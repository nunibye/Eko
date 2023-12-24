import 'package:flutter/material.dart';
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

    return ChangeNotifierProvider(
      create: (context) => FeedController(context: context, rebuild: rebuild),
      builder: (context, child) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        //begin app bar
        final SliverAppBar appBar = SliverAppBar(
          toolbarHeight: height * 0.1,
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
                    padding: EdgeInsets.only(bottom: 6),
                    child: const CustomTabBar()),
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
                  if (Provider.of<FeedController>(context, listen: true).newActivity) 
                    Positioned(
                      right: 1.5,
                      child: Container(
                        width:9,
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
          title: SizedBox(
            width: width * 0.3,
            child: Image.asset("images/echo.png"),
          ),
        );
        //end app bar

        return Scaffold(
          body: PaginationPage(
            appbar: appBar,
            extraRefresh:
                Provider.of<FeedController>(context, listen: false).onRefresh,
            getter:
                Provider.of<FeedController>(context, listen: false).getPosts,
            card: postCardBuilder,
            startAfterQuery: Provider.of<FeedController>(context, listen: false)
                .getTimeFromPost,
            cachedIndex:
                Provider.of<FeedController>(context, listen: true).index,
          ),

          //
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
        // height: 200,
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: width * 0.3,
                //height: height * 0.08,
                child: Image.asset("images/echo.png"),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.only(right: 10),
                //height: height * 0.08,
                child: IconButton(
                  icon: Stack(
                    children: [
                      const Icon(
                        Icons.notifications,
                        //size: ,
                      ),
                      if (Provider.of<FeedController>(context, listen: true)
                          .newActivity)
                        Positioned(
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).colorScheme.error),
                            constraints: const BoxConstraints(
                              minWidth: 10,
                              //minHeight: 10,
                            ),
                          ),
                        )
                    ],
                  ),
                  onPressed: () =>
                      Provider.of<FeedController>(context, listen: false)
                          .onNotificationButtonPressed(),
                ),
              ),
            )
          ],
        ),
        const CustomTabBar(),
      ],
    ));
  }
}
