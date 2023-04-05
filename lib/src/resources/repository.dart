import 'dart:async';
import 'package:deckinspectors/src/models/project_model.dart';
import 'package:deckinspectors/src/resources/project_api_provider.dart';
import 'package:deckinspectors/src/resources/user_provider.dart';

import '../models/login_response.dart';
import 'location_api_provider.dart';
import 'subproject_api_provider.dart';

class Repository {
  //Projects
  final projectsApiProvider = ProjectsApiProvider();
  Future<Projects> fetchAllProjects() => projectsApiProvider.fetchProjects();

  Future<Object> addProject(Object requestBody) =>
      projectsApiProvider.addProject(requestBody);
  Future<Object> updateProject(Object projectObject, String id) =>
      projectsApiProvider.updateProject(projectObject, id);
  Future<Object> deleteProject(Object projectObject, String id) =>
      projectsApiProvider.deleteProject(projectObject, id);

//Locations
  final locationApiProvider = LocationsApiProvider();
Future<Object> getLocation(String id) =>
      locationApiProvider.getLocation(id);
  Future<Object> addLocation(Object requestBody) =>
      locationApiProvider.addLocation(requestBody);
  Future<Object> updateLocation(Object projectObject, String id) =>
      locationApiProvider.updateLocation(projectObject, id);
  Future<Object> deleteLocation(Object projectObject, String id) =>
      locationApiProvider.deleteLocation(projectObject, id);

      //SubProject
  final subProjectApiProvider = SubProjectApiProvider();
Future<Object> getSubProject(String id) =>
      subProjectApiProvider.getSubProject(id);
  Future<Object> addSubProject(Object requestBody) =>
      subProjectApiProvider.addSubProject(requestBody);
  Future<Object> updateSubProject(Object projectObject, String id) =>
      subProjectApiProvider.updateSubProject(projectObject, id);
  Future<Object> deleteSubProject(Object projectObject, String id) =>
      subProjectApiProvider.deleteSubProject(projectObject, id);

  //Users
  final usersApiProvider = UsersApiProvider();
  Future<LoginResponse> login(Object loginReq) =>
      usersApiProvider.login(loginReq);
}
