import 'dart:convert';
import 'package:deckinspectors/src/models/location_model.dart';
import 'package:deckinspectors/src/models/success_response.dart';
import 'package:deckinspectors/src/resources/urls.dart';
import 'package:http/http.dart' show Client;
import '../models/error_response.dart';

class LocationsApiProvider {
  Client client = Client();

  Future<LocationResponse> getLocation(String id) async {
    var endPoint = URLS.manageLocationUrl + id;
    final baseUrl = Uri.parse(endPoint);
    final response = await client.get(baseUrl);

    if (response.statusCode == 201) {
      return LocationResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get location');
    }
  }

  Future<Object> addLocation(Object requestBody) async {
    var endPoint = '${URLS.manageLocationUrl}add';
    final baseUrl = Uri.parse(endPoint);
    final response = await client.post(baseUrl,
        body: requestBody, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      return SuccessResponse.fromJson(json.decode(response.body));
    } else {
      return ErrorResponse.fromJson(json.decode(response.body));
    }
  }

  Future<Object> updateLocation(Object requestBody, String id) async {
    var endPoint = URLS.manageLocationUrl + id;
    final baseUrl = Uri.parse(endPoint);
    final response = await client.put(baseUrl,
        body: requestBody, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 201) {
      return SuccessResponse.fromJson(json.decode(response.body));
    } else {
      return ErrorResponse.fromJson(json.decode(response.body));
    }
  }

  Future<Object>  deleteLocation(Object requestBody, String id) async {
    var endPoint = '${URLS.manageLocationUrl}$id/toggleVisibility';
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
