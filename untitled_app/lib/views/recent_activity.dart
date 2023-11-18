import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/recent_activity_controller.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return ChangeNotifierProvider(
      create: (context) => RecentActivtiyController(),
      builder: (context, child) {
        return const Scaffold(
            body: Placeholder());
      },
    );
  }
}
