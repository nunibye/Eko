import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_page.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 50),
//         IconButton(
//             onPressed: () => FirebaseAuth.instance.signOut(),
//             icon: const Icon(Icons.abc)),
//       ],
//     );
//   }
// }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _username = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Function to load user data from Firestore
  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      final querySnapshot = await firestore
          .collection('users')
          .where("uid", isEqualTo: user.uid)
          .get(); // Get the user's document based on their UID
      if (querySnapshot.docs.isNotEmpty) {
        final userData = querySnapshot.docs.first.data();
        // final nameData = userData['name'];
        final firstName = userData['name']['firstName']; // exmaple map querey
        final lastName = userData['name']['lastName']; // exmaple map querey
        final userName = userData['username'];
        if (userName != null) {
          setState(() {
            _username = "$userName";
          });
        } else {
          setState(() {
            _username = "Name not available";
          });
        }
      } else {
        setState(() {
          _username = "User data not found";
        });
      }
    } else {
      setState(() {
        _username = "No user logged in";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text("Profile"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome,",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              _username,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage(postReferences: [],)),
                    ),
                child: const Text("View Profile")),
            IconButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                icon: const Icon(Icons.abc)),
          ],
        ),
      ),
    );
  }
}
