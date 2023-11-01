import 'package:flutter/material.dart';
import '../custom_widgets/feed_builder.dart';
import '../custom_widgets/tab_bar.dart';
import '../controllers/feed_controller.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatelessWidget {
  final bool rebuild;
  const FeedPage({super.key, this.rebuild = false});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FeedController(context: context, rebuild: rebuild),
      builder: (context, child) {
        return Scaffold(
          body: FeedBuilder(
            firestoreQuery:
                Provider.of<FeedController>(context, listen: true).query,
            index: Provider.of<FeedController>(context, listen: true).index,
            //TODO maybe optimize to check current user?
            user: null,
            header: const _Header(),
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomTabBar(),
      ],
    );
  }
}
