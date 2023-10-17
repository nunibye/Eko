import 'package:flutter/cupertino.dart';
import 'package:algolia/algolia.dart';

class SearchPageController with ChangeNotifier {
  final TextEditingController searchText = TextEditingController(text: "");
  List<AlgoliaObjectSnapshot> results = [];
  bool searching = false;
  late Algolia algolia;

  SearchPageController() {
    algolia = const Algolia.init(
      applicationId: '0TWRTKJQ5W',
      apiKey:
          '219a2653762d8c9871a260e303f0db73', // idk if this should be hidden or something
    );
  }

  search(String s) async {
    searching = true;
    notifyListeners();

    AlgoliaQuery query = algolia.instance.index('users');
    query = query.query(s);

    results = (await query.getObjects()).hits;

    searching = false;
    notifyListeners();
  }

  // TextEditingController get searchText => _searchText;
  //List<AlgoliaObjectSnapshot> get results => _results;
  //bool get searching => _searching;
}
