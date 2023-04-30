import 'dart:io';
import 'package:deckinspectors/src/models/error_response.dart';
import 'package:deckinspectors/src/models/success_response.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class LocalImagesApiProvider {
  Future<Object> uploadImage(String imageFilePath, String containerName,
      String uploader, String id, String parentType, String entityName) async {
    try {
      Directory? directory = await getExternalStorageDirectory();
      File file = File(imageFilePath);

      File copiedFile = await file.copy(path.join(directory!.path,
          containerName, entityName, path.basename(imageFilePath)));
      return ImageResponse(message: 'success', url: copiedFile.path);
    } catch (e) {
      return ErrorResponse(message: 'failure', errordata: e);
    }
  }
}
