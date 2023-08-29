import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../custom_widgets/feed_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    
        return Scaffold(
            body: FeedBuilder(
              //TODO maybe optimize to check current user?
              user: null,
          header: const _Header(),
          
        )
      
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("feed page"),
        IconButton(
            onPressed: () => FirebaseAuth.instance.signOut(),
            icon: const Icon(Icons.logout)),
      ],
    );
  }
}