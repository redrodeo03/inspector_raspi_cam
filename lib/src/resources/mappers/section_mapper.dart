import 'package:deckinspectors/src/models/realm/realm_schemas.dart';

import '../../models/location_model.dart';

class SectionMapper {
  Section? fromLocalSection(LocalSection? localSection) {
    if (localSection == null) {
      return null;
    }
    final section = Section(
        id: localSection.id,
        name: localSection.name,
        visualsignsofleak: localSection.visualsignsofleak,
        furtherinvasivereviewrequired:
            localSection.furtherinvasivereviewrequired,
        visualreview: localSection.visualreview,
        coverUrl: localSection.coverUrl,
        conditionalassessment: localSection.conditionalassessment,
        count: localSection.count);
    return section;
  }

  LocalSection? fromSection(Section section) {
    final localSection = LocalSection(
      id: section.id,
      name: section.name,
      visualsignsofleak: section.visualsignsofleak,
      furtherinvasivereviewrequired: section.furtherinvasivereviewrequired,
      visualreview: section.visualreview,
      coverUrl: section.coverUrl,
      conditionalassessment: section.conditionalassessment,
      count: section.count,
    );
    return localSection;
  }
}
