import 'package:deckinspectors/src/models/location_model.dart';
import 'package:deckinspectors/src/models/realm/realm_schemas.dart';

import 'section_mapper.dart';

class LocationMapper {
  SectionMapper sectionMapper = SectionMapper();
  Location? fromLocalLocation(LocalLocation? localLocation) {
    if (localLocation == null) {
      return null;
    }
    List<Section> sections = [];
    for (var element in localLocation.sections) {
      sections.add(sectionMapper.fromLocalSection(element) as Section);
    }
    final location = Location(
        id: localLocation.id,
        name: localLocation.name,
        parentid: localLocation.parentid,
        parenttype: localLocation.parenttype,
        description: localLocation.description,
        createdat: localLocation.createdat,
        createdby: localLocation.createdby,
        url: localLocation.url,
        editedat: localLocation.editedat,
        lasteditedby: localLocation.lasteditedby,
        sections: sections);
    return location;
  }

  LocalLocation fromLocation(Location location) {
    List<LocalSection> sections = [];

    if (location.sections != null) {
      for (var element in location.sections!) {
        sections.add(sectionMapper.fromSection(element) as LocalSection);
      }
    }

    final localLocation = LocalLocation(location.id,
        name: location.name,
        parentid: location.parentid,
        parenttype: location.parenttype,
        description: location.description,
        createdat: location.createdat,
        createdby: location.createdby,
        url: location.url,
        editedat: location.editedat,
        lasteditedby: location.lasteditedby,
        sections: sections);
    return localLocation;
  }
}
