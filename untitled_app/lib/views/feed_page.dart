import 'package:flutter/material.dart';
import '../custom_widgets/pagination.dart';
import '../custom_widgets/tab_bar.dart';
import '../controllers/feed_controller.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../custom_widgets/post_card.dart';

class FeedPage extends StatelessWidget {
  final bool rebuild;

  const FeedPage({super.key, this.rebuild = false});

  @override
  Widget build(BuildContext context) {
    //Provider.of<FeedController>(context, listen: false).checkNewActivity();

    return ChangeNotifierProvider(
      create: (context) => FeedController(context: context, rebuild: rebuild),
      builder: (context, child) {
        return Scaffold(
            body: PaginationPage(
                getter: Provider.of<FeedController>(context, listen: false), card: postCardBuilder, startAfterQuery: Provider.of<FeedController>(context, listen: false)
                          .getTimeFromPost)
            // FeedBuilder(
            //   firestoreQuery:
            //       Provider.of<FeedController>(context, listen: true).query,
            //   index: Provider.of<FeedController>(context, listen: true).index,
            //   //TODO maybe optimize to check current user?
            //   user: null,
            //   header: const _Header(),
            // ),
            );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: height * 0.08,
                child: Image.asset("images/echo.png"),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.only(right: 10),
                height: height * 0.08,
                child: IconButton(
                  icon: Stack(
                    children: [
                      const Icon(
                        Icons.notifications,
                        size: 28,
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
                              minHeight: 10,
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
    );
  }
}
