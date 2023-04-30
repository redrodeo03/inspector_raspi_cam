import 'dart:async';
import 'package:deckinspectors/src/bloc/settings_bloc.dart';
import 'package:deckinspectors/src/models/project_model.dart';

import 'package:deckinspectors/src/resources/project_api_provider.dart';
import 'package:deckinspectors/src/resources/realm/project_local_provider.dart';
import 'package:deckinspectors/src/resources/user_provider.dart';

import '../models/login_response.dart';
import 'image_api_provider.dart';
import 'location_api_provider.dart';
import 'section_api_provider.dart';
import 'subproject_api_provider.dart';

class Repository {
  //Projects
  final projectsApiProvider = ProjectsApiProvider();
  final localProjectsApiProvider = LocalProjectApiProvider();

  Future<Projects> fetchAllProjects() {
    return projectsApiProvider.fetchProjects();
  }

  Future<Projects> fetchLocalProjects() {
    return localProjectsApiProvider.fetchProjects();
  }

  Future<Object> getProject(String id) {
    if (appSettings.isAppOfflineMode) {
      return localProjectsApiProvider.getProject(id);
    } else {
      return projectsApiProvider.getProject(id);
    }
  }

  Future<Object> addProject(Project project) {
    if (appSettings.isAppOfflineMode) {
      return localProjectsApiProvider.addProject(project);
    } else {
      return projectsApiProvider.addProject(project);
    }
  }

  Future<Object> updateProject(Object projectObject, String id) {
    if (appSettings.isAppOfflineMode) {
      return localProjectsApiProvider.updateProject(projectObject, id);
    } else {
      return projectsApiProvider.updateProject(projectObject, id);
    }
  }

  Future<Object> deleteProject(Object projectObject, String id) {
    if (appSettings.isAppOfflineMode) {
      return localProjectsApiProvider.deleteProject(projectObject, id);
    } else {
      return projectsApiProvider.deleteProject(projectObject, id);
    }
  }

  Future<Object> deleteOnlineProjectPermanently(String id) {
    return projectsApiProvider.deleteProjectPermanently(id);
  }

//local fetches

//Locations
  final locationApiProvider = LocationsApiProvider();
  Future<Object> getLocation(String id) => locationApiProvider.getLocation(id);
  Future<Object> addLocation(Object requestBody) =>
      locationApiProvider.addLocation(requestBody);
  Future<Object> updateLocation(Object projectObject, String id) =>
      locationApiProvider.updateLocation(projectObject, id);
  Future<Object> deleteLocation(Object projectObject, String id) =>
      locationApiProvider.deleteLocation(projectObject, id);

  //Sections
  final sectionApiProvider = SectionsApiProvider();
  Future<Object> getSection(String id) => sectionApiProvider.getSection(id);
  Future<Object> addSection(Object requestBody) =>
      sectionApiProvider.addSection(requestBody);
  Future<Object> updateSection(Object projectObject, String id) =>
      sectionApiProvider.updateSection(projectObject, id);
  Future<Object> deleteSection(Object projectObject, String id) =>
      sectionApiProvider.deleteSection(projectObject, id);

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

  final imageApiProvider = ImagesApiProvider();
  Future<Object> uploadImage(String path, String containerName, String uploader,
          String id, String parentType, String entityName) =>
      imageApiProvider.uploadImage(
          path, containerName, uploader, id, parentType, entityName);
}
