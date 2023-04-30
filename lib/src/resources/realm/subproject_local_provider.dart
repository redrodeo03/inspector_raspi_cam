import 'package:deckinspectors/src/models/error_response.dart';
import 'package:deckinspectors/src/models/realm/realm_schemas.dart';
import 'package:deckinspectors/src/models/success_response.dart';
import 'package:realm/realm.dart';

import '../../models/subproject_model.dart';
import '../mappers/subproject_mapper.dart';

class LocalSubProjectApiProvider {
  late Realm realm;
  final subProjectMapper = SubProjectMapper();
  LocalSubProjectApiProvider() {
    var config =
        Configuration.local([LocalSubProject.schema, LocalChild.schema]);
    realm = Realm(config);
  }

  /// Get item by [id].
  Future<Object> getSubProject(String id) {
    SubProjectResponse projectResponse = SubProjectResponse();
    return Future(() {
      try {
        final item = realm.find<LocalSubProject>(id);
        projectResponse.item = subProjectMapper.fromLocalSubProject(item);
        projectResponse.message = 'Success';
        return projectResponse;
      } catch (e) {
        return ErrorResponse(
            code: 500, message: 'failed to read realm', errordata: e);
      }
    });
  }

  Future<Object> addSubProject(SubProject subProject) {
    return Future(() {
      SuccessResponse successResponse = SuccessResponse();
      try {
        var localSubProject = subProjectMapper.fromSubProject(subProject);
        var subprojectId = ObjectId().toString();
        localSubProject.id = subprojectId;
        var creationtime = DateTime.now.toString();
        localSubProject.createdat = creationtime;
        realm.writeAsync(() {
          realm.add(localSubProject, update: false);
        });

        successResponse.id = subprojectId;
        successResponse.message = 'added successfully to realm';
        return successResponse;
      } catch (e) {
        return ErrorResponse(
            code: 500, message: 'failed to add to realm', errordata: e);
      }
    });
  }

  Future<Object> updateSubProject(SubProject subProject, String id) {
    return Future(() {
      SuccessResponse successResponse = SuccessResponse();
      try {
        var subproject = subProjectMapper.fromSubProject(subProject);

        realm.writeAsync(() {
          realm.add(subproject, update: true);
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
        var subproject =
            subProjectMapper.fromSubProject(projectObject as SubProject);
        realm.writeAsync(() {
          realm.delete(subproject);
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
