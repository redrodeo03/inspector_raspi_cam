import 'dart:convert';
import 'package:deckinspectors/src/models/success_response.dart';
import 'package:deckinspectors/src/resources/urls.dart';
import 'package:http/http.dart' show Client;
import '../models/error_response.dart';
import '../models/section_model.dart';

class SectionsApiProvider {
  Client client = Client();

  Future<VisualSection> getSection(String id) async {
    var endPoint = URLS.manageSectionUrl + id;
    final baseUrl = Uri.parse(endPoint);
    final response = await client.get(baseUrl);

    if (response.statusCode == 201) {
      return VisualSection.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get section');
    }
  }

  Future<Object> addSection(Object requestBody) async {
    var endPoint = '${URLS.manageSectionUrl}add';
    final baseUrl = Uri.parse(endPoint);
    final response = await client.post(baseUrl,
        body: requestBody, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      return SuccessResponse.fromJson(json.decode(response.body));
    } else {
      return ErrorResponse.fromJson(json.decode(response.body));
    }
  }

  Future<Object> updateSection(Object requestBody, String id) async {
    var endPoint = URLS.manageSectionUrl + id;
    final baseUrl = Uri.parse(endPoint);
    final response = await client.put(baseUrl,
        body: requestBody, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      return SuccessResponse.fromJson(json.decode(response.body));
    } else {
      return ErrorResponse.fromJson(json.decode(response.body));
    }
  }

  deleteSection(Object requestBody, String id) async {
    var endPoint = '${URLS.manageSectionUrl}id/toggleVisibility';
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
