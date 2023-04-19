import 'dart:convert';

import 'package:deckinspectors/src/resources/urls.dart';
import 'package:http/http.dart' as http;
import '../models/error_response.dart';
import '../models/success_response.dart';

class ImagesApiProvider {
  Future<Object> uploadImage(String imageFilePath, String containerName,
      String uploader,String id,String parentType,String entityName) async {
    var endPoint = '${URLS.manageImagesUrl}upload';
    final baseUrl = Uri.parse(endPoint);

    var request = http.MultipartRequest('POST', baseUrl);
 request.files.add(
    await http.MultipartFile.fromPath(
      'picture',
      imageFilePath,
    )
  );
    
    request.fields['id'] = id;
    request.fields['parentType'] = parentType;
    request.fields['type'] = entityName;
    request.fields['containerName'] = containerName.replaceAll(' ', '').toLowerCase();
    request.fields['uploader'] = uploader;
    
    
    var responseStream = await request.send();
    var response = await http.Response.fromStream(responseStream);
    if (response.statusCode == 201) {
      // print("Uploaded! ");
      // print('response.body '+response.body);
      return ImageResponse.fromJson(json.decode(response.body));
    } else {
      return ErrorResponse.fromJson(json.decode(response.body));
    }
  }
}
