import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/search_page_controller.dart';


class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchPageController(),
      builder: (context, child) {
        return const Scaffold(
            body: Text("search"));
      },
    );
  }
}


