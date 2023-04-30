import 'package:deckinspectors/src/models/error_response.dart';
import 'package:deckinspectors/src/models/realm/realm_schemas.dart';
import 'package:deckinspectors/src/models/success_response.dart';
import 'package:realm/realm.dart';

import '../../models/project_model.dart';
import '../mappers/project_mapper.dart';

class LocalProjectApiProvider {
  late Realm realm;
  final projectMapper = ProjectMapper();
  LocalProjectApiProvider() {
    var config = Configuration.local([LocalProject.schema, LocalChild.schema]);
    realm = Realm(config);
  }

  ///Get all local Projects
  Future<Projects> fetchProjects() {
    return Future(() => getLocalProjects());
  }

  Projects getLocalProjects() {
    Projects projectsObject = Projects();
    try {
      List<Project> projects = [];
      var localProjects = realm.all<LocalProject>().toList();
      for (var localProject in localProjects) {
        projects.add(projectMapper.fromLocalProject(localProject) as Project);
        projectsObject.projects = projects;
        projectsObject.message = 'Success';
      }
    } catch (e) {
      projectsObject.message = 'failure';
    }

    return projectsObject;
  }

  /// Get item by [id].
  Future<Object> getProject(String id) {
    ProjectResponse projectResponse = ProjectResponse();
    return Future(() {
      try {
        final item = realm.find<LocalProject>(id);
        projectResponse.item = projectMapper.fromLocalProject(item);
        projectResponse.message = 'Success';
        return projectResponse;
      } catch (e) {
        return ErrorResponse(
            code: 500, message: 'failed to read realm', errordata: e);
      }
    });
  }

  Future<Object> addProject(Project project) {
    return Future(() {
      SuccessResponse successResponse = SuccessResponse();
      try {
        var localproject = projectMapper.fromProject(project);
        var projectId = ObjectId().toString();
        localproject.id = projectId;
        var creationtime = DateTime.now.toString();
        localproject.createdat = creationtime;
        realm.writeAsync(() {
          realm.add(localproject, update: false);
        });

        successResponse.id = projectId;
        successResponse.message = 'added successfully to realm';
        return successResponse;
      } catch (e) {
        return ErrorResponse(
            code: 500, message: 'failed to add to realm', errordata: e);
      }
    });
  }

  Future<Object> updateProject(Object projectObject, String id) {
    return Future(() {
      SuccessResponse successResponse = SuccessResponse();
      try {
        var project = projectMapper.fromProject(projectObject as Project);

        realm.writeAsync(() {
          realm.add(project, update: true);
        });
        successResponse.id = id;
        successResponse.message = 'updated successfully to realm';
        return successResponse;
      } catch (e) {
        return ErrorResponse(
            code: 500, message: 'failed to update to realm', errordata: e);
      }
    });
  }

  Future<Object> deleteProject(Object projectObject, String id) {
    return Future(() {
      SuccessResponse successResponse = SuccessResponse();
      try {
        var project = projectMapper.fromProject(projectObject as Project);
        realm.writeAsync(() {
          realm.delete(project);
        });
        successResponse.id = '';
        successResponse.message = 'deleted successfully from realm';
        return successResponse;
      } catch (e) {
        return ErrorResponse(
            code: 500, message: 'failed to delete from realm', errordata: e);
      }
    });
  }
}
