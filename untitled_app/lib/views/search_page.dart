import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/search_page_controller.dart';
import '../custom_widgets/post_card.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchPageController(),
      builder: (context, child) {
        return Scaffold(
          body: RefreshIndicator(
            child: Consumer<SearchPageController>(
              builder: (context, searchPageController, child) =>
                  ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller:
                    Provider.of<SearchPageController>(context, listen: false)
                        .scroll,
                itemCount: searchPageController.posts.length + 2,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return child;
                  } else if (searchPageController.posts.isNotEmpty && index < searchPageController.posts.length + 1) {
                    return PostCard(
                        post: searchPageController.posts[index - 1]);
                  } else {
                    return searchPageController.end ? const Center(child: Text("No More Posts")):const Center(child: Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator()));
                  }
                },
              ),
              child: const Text("Header text or something"),
            ),
            onRefresh: () =>
                Provider.of<SearchPageController>(context, listen: false)
                    .onRefresh(),
          ),
        );
      },
    );
  }
}
