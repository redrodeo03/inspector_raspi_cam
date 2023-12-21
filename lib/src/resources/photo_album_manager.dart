import 'package:flutter/services.dart';

class PhotoAlbumManager {
  static const MethodChannel _channel =
      MethodChannel('com.deckinspectors.fluttermobile/photoalbum');

  static Future<void> createAlbum(String albumName) async {
    try {
      await _channel.invokeMethod('createAlbum', {'albumName': albumName});
    } catch (e) {
      print('Error creating album: $e');
    }
  }

  static Future<void> addPhotoToAlbum(
      String albumName, String imagePath) async {
    try {
      await _channel.invokeMethod(
          'addPhotoToAlbum', {'albumName': albumName, 'imagePath': imagePath});
    } catch (e) {
      print('Error adding photo to album: $e');
    }
  }
}
