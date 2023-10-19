import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/search_page_controller.dart';
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';

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
                
                // StreamBuilder<SearchResponse>(
                //   stream:
                //       Provider.of<SearchPageController>(context, listen: true)
                //           .searcher
                //           .responses, // 4. Listen and display search results!
                //   builder: (BuildContext context, AsyncSnapshot<SearchResponse> snapshot) {
                //     if (snapshot.hasData) {
                //       final response = snapshot.data;
                //       final hits = response?.hits.toList() ?? [];
                //       return Expanded(child: ListView.builder(
                //         itemCount: hits.length,
                //         itemBuilder: (BuildContext context, int index) {
                //           final hit = hits[index];
                //           return ListTile(
                //       title: RichText(
                //         text: TextSpan(
                //           style: Theme.of(context).textTheme.titleSmall,
                //           children:
                //               hit.getHighlightedString('username').toInlineSpans(),
                //         ),
                //       ),
                //     );
                //         },
                //       ),);
                //     } else {
                //       return const CircularProgressIndicator();
                //     }
                //   },
                // ),

                //Expanded(
                //   child: Provider.of<SearchPageController>(context, listen: true).isLoading
                //       ? const Center(
                //           child: CircularProgressIndicator(),
                //         )
                //       : Provider.of<SearchPageController>(context, listen: true).hits.isEmpty
                //           ? const Center(
                //               child: Text("No results found."),
                //             )
                //           : ListView.builder(
                //               itemCount: Provider.of<SearchPageController>(context, listen: true).hits.length,
                //               itemBuilder: (BuildContext ctx, int index) {
                //                 Map<String, dynamic> hit = Provider.of<SearchPageController>(context, listen: true).hits[index];

                //                 return TextButton(
                //                   onPressed: () {
                //                     print(hit["uid"]);
                //                   },
                //                   child: Text(hit["username"]),
                //                 );
                //               },
                //             ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
