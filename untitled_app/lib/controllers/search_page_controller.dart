import 'package:flutter/cupertino.dart';
import 'package:algolia/algolia.dart';

class SearchPageController with ChangeNotifier {
  final TextEditingController _searchText = TextEditingController(text: "");
  List<AlgoliaObjectSnapshot> _results = [];
  bool _searching = false;

  SearchPageController() {
    _searchText.addListener(() {
      _search();
    });
  }

  _search() async {
    _searching = true;
    notifyListeners();

    Algolia algolia = const Algolia.init(
      applicationId: '0TWRTKJQ5W',
      apiKey: '219a2653762d8c9871a260e303f0db73', // idk if this should be hidden or something
    );

    AlgoliaQuery query = algolia.instance.index('users');
    query = query.query(_searchText.text);

    _results = (await query.getObjects()).hits;

    _searching = false;
    notifyListeners();
  }

  TextEditingController get searchText => _searchText;
  List<AlgoliaObjectSnapshot> get results => _results;
  bool get searching => _searching;
}