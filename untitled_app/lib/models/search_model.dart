import '../secrets/secrets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'users.dart';

class SearchModel {

  Future<List<AppUser>> hitsQuery(String query) async {
    final response = await http.post(
      Uri.parse(
          'https://${Secrets.ALGOLIA_APP_ID}-dsn.algolia.net/1/indexes/users/query'),
      headers: <String, String>{
        'X-Algolia-API-Key': Secrets.SEARCH_API_KEY,
        'X-Algolia-Application-Id': Secrets.ALGOLIA_APP_ID,
      },
      body: jsonEncode(<String, String>{
        'params': 'query=$query&hitsPerPage=10',
      }),
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body)['hits'] as List)
          .map((i) => AppUser.fromJson(i))
          .toList();
    } else {
      return [];
    }
  }

  // Future<List<AppUser>> onSearchTextChanged(String s) async {
  //   List<AppUser> hits = [];
  //   void internalCall() async {
  //     hits = await hitsQuery(s);
  //   }

  //   if (_debounce?.isActive ?? false) _debounce!.cancel();
  //   _debounce =
  //       Timer(const Duration(milliseconds: c.searchPageDebounce), () async {
  //     if (s != '') {
  //       internalCall();
  //     }
  //   });
  //   return hits;
  // }

}
