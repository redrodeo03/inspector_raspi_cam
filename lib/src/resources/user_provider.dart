import 'dart:convert';

import 'package:deckinspectors/src/resources/urls.dart';
import 'package:http/http.dart' show Client;

import '../models/login_response.dart';

class UsersApiProvider {
  Client client = Client();
  final _baseUrl = Uri.parse(URLS.userLogin);
  final _regUrl = Uri.parse(URLS.registerUser);
  Future<LoginResponse> login(Object requestBody) async {
    final response = await client.post(_baseUrl,
        body: requestBody, headers: {'Content-Type': 'application/json'});
    //print(response.body.toString());

    if (response.statusCode == 201) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else {
      return LoginResponse(id: null, username: null);
    }
  }

  Future<RegisterResponse> register(Object requestBody) async {
    final response = await client.post(_regUrl,
        body: requestBody, headers: {'Content-Type': 'application/json'});
    //print(response.body.toString());

    if (response.statusCode == 201) {
      return RegisterResponse.fromJson(json.decode(response.body));
    } else {
      return RegisterResponse(acknowledged: false, insertedId: null);
    }
  }
}
