import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../utilities/constants.dart' as c;
import '../models/posts.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Divider(
              color: Colors.grey[30],
              height: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: c.postPaddingHoriz,
              vertical: c.postPaddingVert,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display the profile picture as a CircleAvatar
               SizedBox( width: MediaQuery.of(context).size.width * 0.1, child: ClipOval(
                  
                  child: CachedNetworkImage(
                    imageUrl: post.profilePic,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "@${post.username}",
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 1,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        post.body,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: c.postPaddingHoriz,
              vertical: c.postPaddingVert,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Row(
                //   children: [
                //     const Icon(Icons.comment),
                //     const SizedBox(width: 5),
                //     Text('$comments'),
                //   ],
                // ),
                Row(
                  children: [
                    const Icon(Icons.favorite_border),
                    const SizedBox(width: 5),
                    Text('${post.likes}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
