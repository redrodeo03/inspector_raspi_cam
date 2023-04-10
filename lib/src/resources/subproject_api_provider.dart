import 'dart:convert';

import 'package:deckinspectors/src/models/success_response.dart';
import 'package:deckinspectors/src/resources/urls.dart';
import 'package:http/http.dart' show Client;
import '../models/error_response.dart';
import '../models/subproject_model.dart';

class SubProjectApiProvider {
  Client client = Client();

  Future<SubProjectResponse> getSubProject(String id) async {
    var endPoint = URLS.manageSubprojectUrl + id;
    final baseUrl = Uri.parse(endPoint);
    final response = await client.get(baseUrl);

    if (response.statusCode == 201) {
      return SubProjectResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get location');
    }
  }

  Future<Object> addSubProject(Object requestBody) async {
    var endPoint = '${URLS.manageSubprojectUrl}add';
    final baseUrl = Uri.parse(endPoint);
    final response = await client.post(baseUrl,
        body: requestBody, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      return SuccessResponse.fromJson(json.decode(response.body));
    } else {
      return ErrorResponse.fromJson(json.decode(response.body));
    }
  }

  Future<Object> updateSubProject(Object requestBody, String id) async {
    var endPoint = URLS.manageSubprojectUrl + id;
    final baseUrl = Uri.parse(endPoint);
    final response = await client.put(baseUrl,
        body: requestBody, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      return SuccessResponse.fromJson(json.decode(response.body));
    } else {
      return ErrorResponse.fromJson(json.decode(response.body));
    }
  }

  Future<Object> deleteSubProject(Object requestBody, String id) async {
    var endPoint = '${URLS.manageSubprojectUrl}id/toggleVisibility';
    final baseUrl = Uri.parse(endPoint);
    final response = await client.post(baseUrl,
        body: requestBody, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      return SuccessResponse.fromJson(json.decode(response.body));
    } else {
      return ErrorResponse.fromJson(json.decode(response.body));
    }
  }
}
