import 'package:deckinspectors/src/models/section_model.dart';
import '../../models/realm/realm_schemas.dart';

class VisualSectionMapper {
  VisualSection? fromLocalVisualSection(
      LocalVisualSection? localVisualSection) {
    if (localVisualSection == null) {
      return null;
    }

    final visuslSection = VisualSection(
        id: localVisualSection.id,
        name: localVisualSection.name,
        images: localVisualSection.images,
        exteriorelements: localVisualSection.exteriorelements,
        waterproofingelements: localVisualSection.waterproofingelements,
        additionalconsiderations: localVisualSection.additionalconsiderations,
        conditionalassessment: localVisualSection.conditionalassessment,
        visualreview: localVisualSection.visualreview,
        visualsignsofleak: localVisualSection.visualsignsofleak,
        createdat: localVisualSection.createdat,
        createdby: localVisualSection.createdby,
        furtherinvasivereviewrequired:
            localVisualSection.furtherinvasivereviewrequired,
        editedat: localVisualSection.editedat,
        lasteditedby: localVisualSection.lasteditedby,
        awe: localVisualSection.awe,
        lbc: localVisualSection.lbc,
        parentid: localVisualSection.parentid,
        eee: localVisualSection.eee);
    return visuslSection;
  }

  LocalVisualSection fromVisualSection(VisualSection visualSection) {
    final localVisuslSection = LocalVisualSection(visualSection.id,
        name: visualSection.name,
        images: visualSection.images as Iterable<String>,
        exteriorelements: visualSection.exteriorelements as Iterable<String>,
        waterproofingelements:
            visualSection.waterproofingelements as Iterable<String>,
        additionalconsiderations: visualSection.additionalconsiderations,
        conditionalassessment: visualSection.conditionalassessment,
        visualreview: visualSection.visualreview,
        visualsignsofleak: visualSection.visualsignsofleak,
        createdat: visualSection.createdat,
        createdby: visualSection.createdby,
        furtherinvasivereviewrequired:
            visualSection.furtherinvasivereviewrequired,
        editedat: visualSection.editedat,
        lasteditedby: visualSection.lasteditedby,
        awe: visualSection.awe,
        lbc: visualSection.lbc,
        parentid: visualSection.parentid,
        eee: visualSection.eee);
    return localVisuslSection;
  }
}
