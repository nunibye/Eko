import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../models/post_handler.dart' show Post;
import '../controllers/view_post_page_controller.dart';

class ViewPostPage extends StatelessWidget {
  final Post? post;
  const ViewPostPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => PostPageController(post: post),
        builder: (context, child) {
          return Scaffold(
            appBar: AppBar(
              
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded,
                    color: Theme.of(context).colorScheme.primary),
                onPressed: () => context.pop(),
              ),
              backgroundColor: Theme.of(context).colorScheme.onBackground,
              title: Text(
                Provider.of<PostPageController>(context, listen: false)
                          .title,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Lato',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            body: ListView(children: [Text(Provider.of<PostPageController>(context, listen: false)
                          .body)]),
          );
        });
  }
}
