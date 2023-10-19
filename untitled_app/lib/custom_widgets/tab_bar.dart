import 'package:flutter/material.dart';
import 'package:untitled_app/controllers/feed_controller.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';

import 'package:provider/provider.dart';

// TODO: I changed it to this does it look fine
class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50, // Adjust the height as needed
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _Button(text: AppLocalizations.of(context)!.followingTab, index: 0),
          _Button(text: AppLocalizations.of(context)!.popularTab, index: 1),
          _Button(text: AppLocalizations.of(context)!.newTab, index: 2),
          _Button(text: AppLocalizations.of(context)!.oldTab, index: 3),
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
    final isActive =
        Provider.of<FeedController>(context, listen: true).index == index;

    return GestureDetector(
      onTap: () => Provider.of<FeedController>(context, listen: false)
          .onTabPressed(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.onBackground
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onPrimary,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
