// import 'package:flutter/material.dart';
// import '../models/post_handler.dart' show Post;

// void commentModal(BuildContext context, Post post) {
//   showModalBottomSheet(
//     backgroundColor: Colors.transparent,
//     context: context,
//     isScrollControlled: true,
//     isDismissible: true,
//     builder: (BuildContext context) {
//       return DraggableScrollableSheet(
//         initialChildSize: 0.75, //set this as you want
//         maxChildSize: 0.75, //set this as you want
//         minChildSize: 0.75, //set this as you want
//         expand: true,
//         builder: (context, scrollController) {
//           return Container(
//             color: Colors.amber,
//             child: Column(
//               children: [for (int i = 0; i < 0; i++) Text("$i")],
//             ),
//           ); //whatever you're returning, does not have to be a Container
//         },
//       );
//     },
//   );
// }
