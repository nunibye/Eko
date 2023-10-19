import '../secrets/secrets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchedItem {
  final String username;
  final String uid;
  final String firstName;
  final String lastName;
  final String profilePicture;

  SearchedItem(this.username, this.uid, this.firstName, this.lastName,
      this.profilePicture);

  static SearchedItem fromJson(Map<String, dynamic> json) {
    return SearchedItem(
        json['username'],
        json['uid'],
        json['name']['firstName'],
        json['name']['lastName'],
        json['profileData']['profilePicture']);
  }
}

class SearchModel {
  Future<List<SearchedItem>> hitsQuery(String query) async {
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
          .map((i) => SearchedItem.fromJson(i))
          .toList();
    } else {
      return [];
    }
  }
}
