import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled_app/views/login.dart';
import 'navigation_bar.dart';
import '../controllers/root_controller.dart';
import 'package:provider/provider.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth.instance.authStateChanges().listen(((User? user) {
      if (user != null) {
        context.go('/profile');
      } else {
        context.go('/login');
      }
    }));
    return ChangeNotifierProvider(
      create: (context) => RootPageController(),
      builder: (context, child) {
        return const CircularProgressIndicator();
      },
    );
  }
}
