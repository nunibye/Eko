import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled_app/views/login.dart';
import 'navigation_bar.dart';
import '../controllers/root_controller.dart';
import 'package:provider/provider.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RootPageController(),
      builder: (context, child) {
        return Scaffold(
          body: StreamBuilder<User?>(
            stream: Provider.of<RootPageController>(context, listen: true).auth,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Provider.of<RootPageController>(context, listen: false)
                //     .loggedIn();
                return const BottomNavBarPage();
              } else {
                return const LoginPage();
              }
            },
          ),
        );
      },
    );
  }
}
