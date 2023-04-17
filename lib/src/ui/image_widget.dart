import 'dart:io';

import 'package:flutter/material.dart';

Image networkImage(String? netWorkImageURL) {
  String imageURL = "";
  if (netWorkImageURL == null) {
    return Image.asset(
          "assets/images/heroimage.png",
          fit: BoxFit.fill,
          width: double.infinity,
        );
  } else {
    imageURL = netWorkImageURL;
  }
  if (imageURL.startsWith('http')) {
    return Image.network(
      imageURL,
      fit: BoxFit.fill,
      // When image is loading from the server it takes some time
      // So we will show progress indicator while loading
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      // When dealing with networks it completes with two states,
      // complete with a value or completed with an error,
      // So handling errors is very important otherwise it will crash the app screen.
      // I showed dummy images from assets when there is an error, you can show some texts or anything you want.
      errorBuilder: (context, exception, stackTrace) {
        return Image.asset(
          "assets/images/heroimage.png",
          fit: BoxFit.fill,
          width: double.infinity,
        );
      },
    );
  } else {
    return Image.file(
      File(imageURL ),
      fit: BoxFit.fill,
      width: double.infinity,
    );
  }
}
