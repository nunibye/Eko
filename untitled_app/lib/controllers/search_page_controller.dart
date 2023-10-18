import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../secrets/secrets.dart';
import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';

class SearchPageController extends ChangeNotifier {
  final searchTextController = TextEditingController();

  final searcher = HitsSearcher(
    applicationID: Secrets.ALGOLIA_APP_ID,
    apiKey: Secrets.SEARCH_API_KEY,
    indexName: 'users',
  );

  bool isLoading = false;

  List<Map<String, dynamic>> hits = [];
  SearchPageController() {
    searchTextController.addListener(onSearchTextChanged);
    searcher.responses.listen((response) {
      if (response.hits.isEmpty) {
        print('No hits found for search query.');
      } else {
        hits = response.hits;
      }
      isLoading = false;
      notifyListeners();
    },);
  }

  void onSearchTextChanged() {
    searcher.query(searchTextController.text);
  }
}
