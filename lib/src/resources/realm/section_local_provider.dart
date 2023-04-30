import 'package:deckinspectors/src/models/error_response.dart';

import 'package:deckinspectors/src/models/realm/realm_schemas.dart';
import 'package:deckinspectors/src/models/section_model.dart';
import 'package:deckinspectors/src/models/success_response.dart';

import 'package:realm/realm.dart';

import '../mappers/visualsection_mapper.dart';

class LocalSectionApiProvider {
  late Realm realm;
  final sectionMapper = VisualSectionMapper();
  LocalSectionApiProvider() {
    var config = Configuration.local([LocalVisualSection.schema]);
    realm = Realm(config);
  }

  /// Get item by [id].
  Future<Object> getSection(String id) {
    SectionResponse sectionResponse = SectionResponse();
    return Future(() {
      try {
        final item = realm.find<LocalVisualSection>(id);
        sectionResponse.item = sectionMapper.fromLocalVisualSection(item);
        sectionResponse.message = 'Success';
        return sectionResponse;
      } catch (e) {
        return ErrorResponse(
            code: 500, message: 'failed to read realm', errordata: e);
      }
    });
  }

  Future<Object> addVisualSection(VisualSection visualSection) {
    return Future(() {
      SuccessResponse successResponse = SuccessResponse();
      try {
        var localVisualSection = sectionMapper.fromVisualSection(visualSection);
        var sectionId = ObjectId().toString();
        localVisualSection.id = sectionId;
        var creationtime = DateTime.now.toString();
        localVisualSection.createdat = creationtime;
        realm.writeAsync(() {
          realm.add(localVisualSection, update: false);
        });

        successResponse.id = sectionId;
        successResponse.message = 'added successfully to realm';
        return successResponse;
      } catch (e) {
        return ErrorResponse(
            code: 500, message: 'failed to add to realm', errordata: e);
      }
    });
  }

  Future<Object> updateVisualSection(VisualSection visualSection, String id) {
    return Future(() {
      SuccessResponse successResponse = SuccessResponse();
      try {
        var location = sectionMapper.fromVisualSection(visualSection);

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

  Future<Object> deleteVisualLocation(Object sectionObject, String id) {
    return Future(() {
      SuccessResponse successResponse = SuccessResponse();
      try {
        var location =
            sectionMapper.fromVisualSection(sectionObject as VisualSection);
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
