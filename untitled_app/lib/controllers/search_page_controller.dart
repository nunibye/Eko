import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../secrets/secrets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

//import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';

// class SearchMetadata {
//   final int nbHits;

//   const SearchMetadata(this.nbHits);

//   factory SearchMetadata.fromResponse(SearchResponse response) =>
//       SearchMetadata(response.nbHits);
// }

class Item {
  final String username;
  final String uid;
 final String firstName;
   final String lastName;
   final String profilePicture;
  //this.firstName, this.lastName, this.profilePicture

  Item(this.username, this.uid, this.firstName, this.lastName, this.profilePicture);

  static Item fromJson(Map<String, dynamic> json) {
    return Item(json['username'], json['uid'], json['name']['firstName'], json['name']['lastName'], json['profileData']['profilePicture']);//json['name']['firstName'], json['profileData']['profilePicture']
  }
}

class SearchPageController extends ChangeNotifier {
  final searchTextController = TextEditingController();

  
  bool isLoading = false;

  List<Item> hits = [];



  void onSearchTextChanged(String s) async {
    if(s != ''){final response = await http.post(
      Uri.parse(
          'https://${Secrets.ALGOLIA_APP_ID}-dsn.algolia.net/1/indexes/users/query'),
      headers: <String, String>{
        'X-Algolia-API-Key': Secrets.SEARCH_API_KEY,
        'X-Algolia-Application-Id': Secrets.ALGOLIA_APP_ID,
      },
      body: jsonEncode(<String, String>{
        'params': 'query=$s&hitsPerPage=10',
      }),
    );

    if (response.statusCode == 200) {
      hits = (json.decode(response.body)['hits']as List)
        .map((i) => Item.fromJson(i))
        .toList();

    for (var item in hits) {
      print('username: ${item.username}, uid: ${item.uid}, f:${item.firstName}, l:${item.lastName}, pp:${item.profilePicture}');//, L:${item.lastName}, pp:${item.profilePicture}
    }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }}

    

    //print("test");
    //searcher.query(s);
    // //int i = await searcher.responses.length;
    // await for (final value in searcher.responses) {
    //   print(value.hits);
    // }

    // if (await searcher.responses.length != 0) {
    //   SearchResponse? response = searcher.lastResponse;
    //   if (response != null) {
    //     hits = response.hits.map((e) => e['uid']).toList();
    //     print("test");
    //     if (hits.isNotEmpty) {
    //       print(hits[0]);
    //     } else {
    //       print("no user");
    //     }
    //   }
    // }

    //  hits = searcher.responses
    //     .map((event) => event.hits.map(Item.fromJson).toList());
    // print(hits);
  }
}
