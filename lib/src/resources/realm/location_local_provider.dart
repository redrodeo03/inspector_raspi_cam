import 'package:deckinspectors/src/models/error_response.dart';
import 'package:deckinspectors/src/models/location_model.dart';
import 'package:deckinspectors/src/models/realm/realm_schemas.dart';
import 'package:deckinspectors/src/models/success_response.dart';
import 'package:realm/realm.dart';
import '../mappers/location_mapper.dart';

class LocalLocationApiProvider {
  late Realm realm;
  final locationMapper = LocationMapper();
  LocalLocationApiProvider() {
    var config =
        Configuration.local([LocalLocation.schema, LocalSection.schema]);
    realm = Realm(config);
  }

  /// Get item by [id].
  Future<Object> getLocation(String id) {
    LocationResponse projectResponse = LocationResponse();
    return Future(() {
      try {
        final item = realm.find<LocalLocation>(id);
        projectResponse.item = locationMapper.fromLocalLocation(item);
        projectResponse.message = 'Success';
        return projectResponse;
      } catch (e) {
        return ErrorResponse(
            code: 500, message: 'failed to read realm', errordata: e);
      }
    });
  }

  Future<Object> addLocation(Location location) {
    return Future(() {
      SuccessResponse successResponse = SuccessResponse();
      try {
        var localLocation = locationMapper.fromLocation(location);
        var locationId = ObjectId().toString();
        localLocation.id = locationId;
        var creationtime = DateTime.now.toString();
        localLocation.createdat = creationtime;
        realm.writeAsync(() {
          realm.add(localLocation, update: false);
        });

        successResponse.id = locationId;
        successResponse.message = 'added successfully to realm';
        return successResponse;
      } catch (e) {
        return ErrorResponse(
            code: 500, message: 'failed to add to realm', errordata: e);
      }
    });
  }

  Future<Object> updateLocation(Location locationObject, String id) {
    return Future(() {
      SuccessResponse successResponse = SuccessResponse();
      try {
        var location = locationMapper.fromLocation(locationObject);

        realm.writeAsync(() {
          realm.add(location, update: true);
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

  Future<Object> deleteLocation(Object locationObject, String id) {
    return Future(() {
      SuccessResponse successResponse = SuccessResponse();
      try {
        var location = locationMapper.fromLocation(locationObject as Location);
        realm.writeAsync(() {
          realm.delete(location);
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
