import 'dart:convert';
import 'package:deckinspectors/src/models/project_model.dart';
import 'package:deckinspectors/src/models/success_response.dart';
import 'package:deckinspectors/src/resources/urls.dart';
import 'package:http/http.dart' show Client;

import '../models/error_response.dart';


class ProjectsApiProvider {
  Client client = Client();
 

  Future<Projects> fetchProjects() async {
    final baseUrl = Uri.parse( URLS.allProjectsUrl);
    final response = await client.get(baseUrl); 
    //print(response.body.toString());

    if (response.statusCode == 201) {
      return Projects.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load projects');
    }
  }
  Future<ProjectResponse> getProject(String id) async {
    var endPoint = URLS.manageProjectsUrl + id;
    final baseUrl = Uri.parse(endPoint);
    final response = await client.get(baseUrl);

    if (response.statusCode == 201) {
      return ProjectResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get project details');
    }
  }

  Future<Object> addProject(Object requestBody) async {
    final baseUrl = Uri.parse( URLS.addProjectsUrl);
    final response = await client.post(
      baseUrl,
    body:requestBody,
    headers: {'Content-Type':'application/json'}); 
    //print(response.body.toString()); 

    if (response.statusCode == 201) {
      return SuccessResponse.fromJson(json.decode(response.body));
    } else {
      return ErrorResponse.fromJson(json.decode(response.body));
    }
  }
Future<Object> updateProject(Object requestBody,String id) async {
    var endPoint = URLS.manageProjectsUrl+ id;
    final baseUrl = Uri.parse( endPoint);
    final response = await client.put(
      baseUrl,
    body:requestBody,
    headers: {'Content-Type':'application/json'}); 
    //print(response.body.toString()); 

    if (response.statusCode == 201) {
      return SuccessResponse.fromJson(json.decode(response.body));
    } else {
      return ErrorResponse.fromJson(json.decode(response.body));
    }
  }

  deleteProject(Object requestBody,String id) async {
    var endPoint = '${URLS.manageProjectsUrl}id/toggleVisibility';
    final baseUrl = Uri.parse( endPoint);
    final response = await client.post(
      baseUrl,
    body:requestBody,
    headers: {'Content-Type':'application/json'}); 
    //print(response.body.toString()); 

    if (response.statusCode == 201) {
      return SuccessResponse.fromJson(json.decode(response.body));
    } else {
      return ErrorResponse.fromJson(json.decode(response.body));
    }
  }
}