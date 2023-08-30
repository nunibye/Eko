import 'package:flutter/material.dart';
import 'package:untitled_app/controllers/feed_controller.dart';
import 'package:untitled_app/utilities/constants.dart';

import 'package:provider/provider.dart';


class CustomTabBar extends StatelessWidget {
  const CustomTabBar({super.key,});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.06,
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.onBackground),
      child:  const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _Button(text: "following", index: 0),
          _Button(
            text: "popular",
            index: 1,
          ),
          _Button(
            text: "new",
            index: 2,
          ),
          _Button(text: "old", index: 3)
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final String text;
  final int index;

  const _Button({required this.text, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.sizeOf(context).height * 0.05,
      width: MediaQuery.sizeOf(context).width * 0.22,
      decoration: BoxDecoration(
        color:
            (Provider.of<FeedController>(context, listen: true).index ==
                    index)
                ? Theme.of(context).colorScheme.background
                : Colors.black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: TextButton(
        style: buttonStyle(context),
        onPressed: () =>
            Provider.of<FeedController>(context, listen: false).onTabPressed(index),
        child: Text(text),
      ),
    );
  }
}
