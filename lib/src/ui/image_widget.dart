import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget networkImage(String? netWorkImageURL) {
  String imageURL = "";
  if (netWorkImageURL == null) {
    return Image.asset(
      "assets/images/icon.png",
      fit: BoxFit.fill,
      width: double.infinity,
    );
  } else {
    imageURL = netWorkImageURL;
  }
  if (imageURL.startsWith('http')) {
    // return Image.network(
    //   imageURL, width: double.infinity,
    //   fit: BoxFit.fill,
    //   // When image is loading from the server it takes some time
    //   // So we will show progress indicator while loading
    //   loadingBuilder: (BuildContext context, Widget child,
    //       ImageChunkEvent? loadingProgress) {
    //     if (loadingProgress == null) return child;
    //     return Center(
    //       child: CircularProgressIndicator(
    //         value: loadingProgress.expectedTotalBytes != null
    //             ? loadingProgress.cumulativeBytesLoaded /
    //                 loadingProgress.expectedTotalBytes!
    //             : null,
    //       ),
    //     );
    //   },

    //   errorBuilder: (context, exception, stackTrace) {
    //     return Image.asset(
    //       "assets/images/icon.png",
    //       fit: BoxFit.fill,
    //       width: double.infinity,
    //     );
    //   },
    // );
    return CachedNetworkImage(
      placeholder: (context, url) => const CircularProgressIndicator(),
      imageUrl: imageURL,
      fit: BoxFit.fill,
    );
  } else {
    return Image.file(
      File(imageURL),
      fit: BoxFit.fill,
      width: double.infinity,
    );
  }
}

// Thumbnail thumbnailImage(String? imageURL, BuildContext context) {
//   return Thumbnail(
//     dataResolver: () async {
//       return (await DefaultAssetBundle.of(context).load(imageURL as String))
//           .buffer
//           .asUint8List();
//     },
//     mimeType: 'image/png',
//     widgetSize: 300,
//     errorBuilder: (uildContext, Exception error) {
//       return Image.asset(
//         "assets/images/icon.png",
//         fit: BoxFit.fill,
//         width: double.infinity,
//       );
//     },
//   );
// }
