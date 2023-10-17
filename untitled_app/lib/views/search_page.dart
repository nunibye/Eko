import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:algolia/algolia.dart';

import '../controllers/search_page_controller.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

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
                  onChanged: (s)=>Provider.of<SearchPageController>(context, listen: false).search(s),
                  controller: Provider.of<SearchPageController>(context, listen: false).searchText,
                  decoration: const InputDecoration(
                      hintText: "Search username here..."),
                ),
                Expanded(
                  child: Provider.of<SearchPageController>(context, listen: true).searching == true
                      ? const Center(
                          child: Text("Searching..."),
                        )
                      : Provider.of<SearchPageController>(context, listen: true).results.isEmpty
                          ? const Center(
                              child: Text("No results found."),
                            )
                          : ListView.builder(
                              itemCount: Provider.of<SearchPageController>(context, listen: true).results.length,
                              itemBuilder: (BuildContext ctx, int index) {
                                AlgoliaObjectSnapshot snap = Provider.of<SearchPageController>(context, listen: true).results[
                                    index]; // idk if this should be here

                                return TextButton(
                                  onPressed: () {
                                    print(snap.data["uid"]);
                                  },
                                  child: Text(snap.data["username"]),
                                );
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
