import 'dart:convert';
import 'dart:io';
import 'package:android_x_storage/android_x_storage.dart';
import 'package:deckinspectors/src/resources/photo_album_manager.dart';
import 'package:deckinspectors/src/resources/urls.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
//import 'package:saver_gallery/saver_gallery.dart';
import '../models/error_response.dart';
import '../models/success_response.dart';
import 'package:path/path.dart' as path;

class ImagesApiProvider {
  Future<Object> uploadImage(String imageFilePath, String containerName,
      String uploader, String id, String parentType, String entityName) async {
    var endPoint = '${URLS.manageImagesUrl}upload';
    final baseUrl = Uri.parse(endPoint);

    var request = http.MultipartRequest('POST', baseUrl);
    request.files.add(await http.MultipartFile.fromPath(
      'picture',
      imageFilePath,
    ));
    if (containerName.length < 3) {
      containerName = containerName + uploader;
    }
    request.fields['id'] = id;
    request.fields['parentType'] = parentType;
    request.fields['type'] = entityName;
    request.fields['containerName'] =
        containerName.replaceAll(' ', '').toLowerCase();

    request.fields['uploader'] = uploader;

    var responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);
    if (response.statusCode == 201) {
      // print("Uploaded! ");
      // print('response.body '+response.body);
      // final uploadedImage = File(imageFilePath);
      // uploadedImage.delete();
      return ImageResponse.fromJson(json.decode(response.body));
    } else {
      return ErrorResponse.fromJson(json.decode(response.body));
    }
  }

  Future<Object> uploadImageLocally(String imageFilePath, String containerName,
      String uploader, String id, String parentType, String entityName) async {
    try {
      //Directory? directory = await getApplicationDocumentsDirectory();
      File? copiedFile;
      if (File(imageFilePath).existsSync()) {
        File file = File(imageFilePath);

        if (Platform.isAndroid) {
          final androidXStorage = AndroidXStorage();
          var dcimPath = await androidXStorage.getDCIMDirectory();

          var destDirectory = await Directory(path.join(dcimPath as String,
                  'E3Inspections', entityName, containerName))
              .create(recursive: true);
          copiedFile = await file.copy(
              path.join(destDirectory.path, path.basename(imageFilePath)));
        } else {
          Directory directory = await getApplicationSupportDirectory();

          var destDirectory = await Directory(path.join(
                  directory.path, 'E3Inspections', entityName, containerName))
              .create(recursive: true);
          copiedFile = await file.copy(
              path.join(destDirectory.path, path.basename(imageFilePath)));
          //move to album
          //create album
          String albumName = "E3Inspections";
          await PhotoAlbumManager.createAlbum("E3Inspections");
          await PhotoAlbumManager.addPhotoToAlbum(albumName, copiedFile.path);
        }
        return ImageResponse(message: 'success', url: copiedFile.path);
      } else {
        return ErrorResponse(
            message: 'failure', errordata: 'file doesn\'t exist');
      }
    } catch (e) {
      return ErrorResponse(message: 'failure', errordata: e);
    }
  }
}
