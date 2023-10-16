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
        var controller = Provider.of<SearchPageController>(context);
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
                  controller: controller.searchText,
                  decoration: const InputDecoration(hintText: "Search username here..."),
                ),
                Expanded(
                  child: controller.searching == true
                      ? const Center(
                          child: Text("Searching..."),
                        )
                      : controller.results.isEmpty
                          ? const Center(
                              child: Text("No results found."),
                            )
                          : ListView.builder(
                              itemCount: controller.results.length,
                              itemBuilder: (BuildContext ctx, int index) {
                                AlgoliaObjectSnapshot snap = controller.results[index]; // idk if this should be here 

                                return ListTile(
                                  title: Text(snap.data["username"]),
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
