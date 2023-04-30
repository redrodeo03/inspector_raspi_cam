import 'dart:async';
import 'package:deckinspectors/src/bloc/settings_bloc.dart';
import 'package:deckinspectors/src/models/project_model.dart';

import 'package:deckinspectors/src/models/section_model.dart';
import 'package:deckinspectors/src/models/subproject_model.dart';

import 'package:deckinspectors/src/resources/project_api_provider.dart';

import 'package:deckinspectors/src/resources/user_provider.dart';

import '../models/location_model.dart';
import '../models/login_response.dart';
import 'image_api_provider.dart';
import 'location_api_provider.dart';
import 'realm/location_local_provider.dart';
import 'realm/project_local_provider.dart';
import 'realm/section_local_provider.dart';
import 'realm/subproject_local_provider.dart';
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

  Future<Object> updateProject(Project project, String id) {
    if (appSettings.isAppOfflineMode) {
      return localProjectsApiProvider.updateProject(project, id);
    } else {
      return projectsApiProvider.updateProject(project, id);
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
  final localLocationApiProvider = LocalLocationApiProvider();

  Future<Object> getLocation(String id) {
    if (appSettings.isAppOfflineMode) {
      return localLocationApiProvider.getLocation(id);
    } else {
      return locationApiProvider.getLocation(id);
    }
  }

  Future<Object> addLocation(Location location) {
    if (appSettings.isAppOfflineMode) {
      return localLocationApiProvider.addLocation(location);
    } else {
      return locationApiProvider.addLocation(location);
    }
  }

  Future<Object> updateLocation(Location location, String id) {
    if (appSettings.isAppOfflineMode) {
      return localLocationApiProvider.updateLocation(location, id);
    } else {
      return locationApiProvider.updateLocation(location, id);
    }
  }

  Future<Object> deleteLocation(Object locationObject, String id) {
    if (appSettings.isAppOfflineMode) {
      return localLocationApiProvider.deleteLocation(locationObject, id);
    } else {
      return locationApiProvider.deleteLocation(locationObject, id);
    }
  }

  //Sections
  final sectionApiProvider = SectionsApiProvider();
  final localSectionApiProvider = LocalSectionApiProvider();
  Future<Object> getSection(String id) {
    if (appSettings.isAppOfflineMode) {
      return localSectionApiProvider.getSection(id);
    } else {
      return sectionApiProvider.getSection(id);
    }
  }

  Future<Object> addSection(VisualSection visualSection) {
    if (appSettings.isAppOfflineMode) {
      return localSectionApiProvider.addVisualSection(visualSection);
    } else {
      return sectionApiProvider.addSection(visualSection);
    }
  }

  Future<Object> updateSection(VisualSection visualSection, String id) {
    if (appSettings.isAppOfflineMode) {
      return localSectionApiProvider.updateVisualSection(visualSection, id);
    } else {
      return sectionApiProvider.updateSection(visualSection, id);
    }
  }

  Future<Object> deleteSection(Object visualObject, String id) {
    if (appSettings.isAppOfflineMode) {
      return localSectionApiProvider.deleteVisualLocation(visualObject, id);
    } else {
      return sectionApiProvider.deleteSection(visualObject, id);
    }
  }

  //SubProject
  final subProjectApiProvider = SubProjectApiProvider();
  final localSubProjectApiProvider = LocalSubProjectApiProvider();
  Future<Object> getSubProject(String id) {
    if (appSettings.isAppOfflineMode) {
      return localSubProjectApiProvider.getSubProject(id);
    } else {
      return subProjectApiProvider.getSubProject(id);
    }
  }

  Future<Object> addSubProject(SubProject subProject) {
    if (appSettings.isAppOfflineMode) {
      return localSubProjectApiProvider.addSubProject(subProject);
    } else {
      return subProjectApiProvider.addSubProject(subProject);
    }
  }

  Future<Object> updateSubProject(SubProject subProject, String id) {
    if (appSettings.isAppOfflineMode) {
      return localSubProjectApiProvider.updateSubProject(subProject, id);
    } else {
      return subProjectApiProvider.updateSubProject(subProject, id);
    }
  }

  Future<Object> deleteSubProject(Object subProjectObject, String id) {
    if (appSettings.isAppOfflineMode) {
      return localSubProjectApiProvider.deleteProject(subProjectObject, id);
    } else {
      return subProjectApiProvider.deleteSubProject(subProjectObject, id);
    }
  }

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
