import 'dart:convert';

import 'package:deckinspectors/src/resources/urls.dart';
import 'package:http/http.dart' as http;
import '../models/error_response.dart';
import '../models/success_response.dart';

class ImagesApiProvider {
  Future<Object> uploadImage(String imageFilePath, String containerName,
      String uploader, String entityName) async {
    var endPoint = '${URLS.manageImagesUrl}upload';
    final baseUrl = Uri.parse(endPoint);

    var request = http.MultipartRequest('POST', baseUrl);
 request.files.add(
    await http.MultipartFile.fromPath(
      'picture',
      imageFilePath,
    )
  );
    
    request.fields['containerName'] = containerName;
    request.fields['uploader'] = uploader;
    request.fields['entityName'] = entityName;
    
    var responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);
    if (response.statusCode == 200) {
      // print("Uploaded! ");
      // print('response.body '+response.body);
      return ImageResponse.fromJson(json.decode(response.body));
    } else {
      return ErrorResponse.fromJson(json.decode(response.body));
    }
  }
}
