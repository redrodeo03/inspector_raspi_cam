import 'dart:convert';
import '../models/section_model.dart';
import '../resources/repository.dart';

class SectionBloc {
  final Repository _repository = Repository();

  Future <Object> getSection(String id) async{
    var response = await _repository.getSection(id);
    return response;
  }
  Future<Object> addSection(VisualSection visualSection) async {
    final sectionObject = jsonEncode({
      'name': visualSection.name,
      'exteriorelements': visualSection.exteriorelements,
      'waterproofingelements': visualSection.waterproofingelements,
      'additionalconsiderations': visualSection.additionalconsiderations,
      'visualreview': visualSection.visualreview,
      'visualsignsofleak': visualSection.visualsignsofleak,
      'furtherinvasivereviewrequired': visualSection.furtherinvasivereviewrequired,
      'conditionalassessment': visualSection.conditionalassessment,
      'eee': visualSection.eee,
      'lbc': visualSection.lbc,
      'awe': visualSection.awe,
      'createdby': visualSection.createdby,
      'parentid': visualSection.parentid,
    });
    var response = await _repository.addSection(sectionObject);

    return response;
  }
  Future<Object> updateSection(VisualSection visualSection) async {
    final sectionObject = jsonEncode({
      'name': visualSection.name,
      'exteriorelements': visualSection.exteriorelements,
      'waterproofingelements': visualSection.waterproofingelements,
      'additionalconsiderations': visualSection.additionalconsiderations,
      'visualreview': visualSection.visualreview,
      'visualsignsofleak': visualSection.visualsignsofleak,
      'furtherinvasivereviewrequired': visualSection.furtherinvasivereviewrequired,
      'conditionalassessment': visualSection.conditionalassessment,
      'eee': visualSection.eee,
      'lbc': visualSection.lbc,
      'awe': visualSection.awe,
      'lasteditedby': visualSection.lasteditedby,
      'parentid': visualSection.parentid,
    });
    var response = await _repository.updateSection(sectionObject,visualSection.id as String);

    return response;
  }  
}

final sectionsBloc = SectionBloc();
