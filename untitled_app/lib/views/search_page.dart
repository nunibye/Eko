import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/search_page_controller.dart';
import '../custom_widgets/searched_user_card.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchPageController(),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("User Search"),
          ),
          body: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  onChanged: (s) =>
                      Provider.of<SearchPageController>(context, listen: false)
                          .onSearchTextChanged(s),
                  controller:
                      Provider.of<SearchPageController>(context, listen: false)
                          .searchTextController,
                  decoration: const InputDecoration(
                      hintText: "Search username here..."),
                ),
                Expanded(
                  child: Provider.of<SearchPageController>(context,
                              listen: true)
                          .isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Provider.of<SearchPageController>(context, listen: true)
                              .hits
                              .isEmpty
                          ? const Center(
                              child: Text("No results found."),
                            )
                          : ListView.builder(
                              itemCount: Provider.of<SearchPageController>(
                                      context,
                                      listen: true)
                                  .hits
                                  .length,
                              itemBuilder: (BuildContext context, int index) {
                                return UserCard(
                                    user: Provider.of<SearchPageController>(
                                            context,
                                            listen: true)
                                        .hits[index]);
                              },
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
