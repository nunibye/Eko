import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controllers/bottom_nav_bar_controller.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../views/profile_page.dart';
import '../views/feed_page.dart';
import '../views/compose_page.dart';
import '../views/search_page.dart';

class BottomNavBarPage extends StatelessWidget {
  const BottomNavBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BottomNavBarController(), // Provide the ViewModel
      child: const BottomNavBarView(),
    );
  }
}

class BottomNavBarView extends StatelessWidget {
  const BottomNavBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: Provider.of<BottomNavBarController>(context)
            .currentIndex, // Use the current index from the ViewModel
        onTap: (index) {
          Provider.of<BottomNavBarController>(context, listen: false)
              .changePage(index); // Update selected index
        },
        elevation: 16,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        unselectedItemColor: Theme.of(context).colorScheme.onPrimary,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'search'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'add'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile')
        ],
      ),

      // it will create all the pages. it loads the data on profile when it creates the object
      body: IndexedStack(
        index: Provider.of<BottomNavBarController>(context).currentIndex,
        children: [
          FeedPage(),
          SearchPage(),
          ComposePage(),
          ProfilePage(),
        ],
      ),
    );
  }
}
