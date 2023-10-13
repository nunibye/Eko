import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../models/post_handler.dart' show Post;
class ViewPostPage extends StatelessWidget {
  final Post? post;
  const ViewPostPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: Theme.of(context).colorScheme.primary),
          onPressed: () => context.pop("poped"),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          AppLocalizations.of(context)!.editProfile,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontFamily: 'Lato',
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Placeholder(),
    );
  }
}
