import 'dart:convert';

import 'package:deckinspectors/src/resources/urls.dart';
import 'package:http/http.dart' show Client;

import 'package:realm/realm.dart';

import '../models/login_response.dart';

class UsersApiProvider {
  Client client = Client();
  final _baseUrl = Uri.parse(URLS.userLogin);

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
}
