import 'package:flutter/material.dart';
import 'package:untitled_app/localization/generated/app_localizations.dart';

class GifWidget extends StatelessWidget {
  final String url;
  GifWidget({super.key, required this.url});
  Future<ImageProvider> _loadImage(String url) async {
    return NetworkImage(url);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: FutureBuilder<ImageProvider>(
        future: _loadImage(url),
        builder: (BuildContext context, AsyncSnapshot<ImageProvider> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              alignment: Alignment.center,
              width: 200,
              height: 150,
              child: const CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text(AppLocalizations.of(context)!.gifLoadingError);
          } else {
            return Image(
              image: snapshot.data!,
              fit: BoxFit.fill,
            );
          }
        },
      ),
      // Stack(
      //   children: [
      //     ValueListenableBuilder<bool>(
      //       valueListenable: _isLoading,
      //       builder: (context, isLoading, child) {
      //         if (isLoading) {
      //           return Container(
      //             alignment: Alignment.center,
      //             width: 200,
      //             height: 150,
      //             color: Theme.of(context).colorScheme.onBackground,
      //           );
      //         } else {
      //           return const SizedBox.shrink(); // This will hide the container
      //         }
      //       },
      //     ),
      //     Image.network(
      //       url,
      //       fit: BoxFit.fill,
      //       errorBuilder: (context, error, stackTrace) =>
      //           Text(AppLocalizations.of(context)!.gifLoadingError),
      //       loadingBuilder: (BuildContext context, Widget child,
      //           ImageChunkEvent? loadingProgress) {

      //         if (loadingProgress == null) {
      //           _isLoading.value = false;
      //           return child;
      //         }
      //         return Container(
      //           alignment: Alignment.center,
      //           width: 200,
      //           height: 150,
      //           child: CircularProgressIndicator(
      //             value: loadingProgress.expectedTotalBytes != null
      //                 ? loadingProgress.cumulativeBytesLoaded /
      //                     loadingProgress.expectedTotalBytes!
      //                 : null,
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // ),
    );
  }
}
