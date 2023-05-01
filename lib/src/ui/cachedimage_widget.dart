import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget cachedNetworkImage(String? imageUrl) {
  if (imageUrl == null) {
    return Image.asset(
      "assets/images/heroimage.png",
      fit: BoxFit.fill,
      width: double.infinity,
    );
  }
  if (imageUrl.startsWith('http')) {
    return CachedNetworkImage(
        progressIndicatorBuilder: (context, url, progress) => Center(
              child: CircularProgressIndicator(
                value: progress.progress,
              ),
            ),
        imageUrl: imageUrl,
        fadeOutDuration: const Duration(seconds: 1),
        fadeInDuration: const Duration(seconds: 3),
        errorWidget: (context, url, error) => Image.asset(
              "assets/images/heroimage.png",
              fit: BoxFit.fill,
              width: double.infinity,
            ),
        imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ));
  } else {
    var imgFile = File(imageUrl);
    if (imgFile.existsSync()) {
      return Image.file(
        File(imageUrl),
        fit: BoxFit.fill,
        width: double.infinity,
      );
    } else {
      return Image.asset(
        "assets/images/heroimage.png",
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }
}
