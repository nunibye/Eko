import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../custom_widgets/feed_builder.dart';
import '../custom_widgets/tab_bar.dart';
import '../controllers/feed_controller.dart';
import 'package:provider/provider.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FeedController(),
      builder: (context, child) {
        return Scaffold(
          // TODO trying to make this app bar so it can be scrolled under maybe. might require feed builder to not have a header
          // appBar: 
          // AppBar(
          //   titleTextStyle: TextStyle(),
          //   automaticallyImplyLeading: false,
          //   title: Container(
          //       width: MediaQuery.of(context).size.width,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: <Widget>[_Header()],
          //       )),
          // ),
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
    const CustomTabBar(),
    ],
    );
  }
}
