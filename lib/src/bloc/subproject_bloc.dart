import 'dart:convert';
import 'package:deckinspectors/src/models/subproject_model.dart';
import '../resources/repository.dart';

class SubProjectBloc {
  final Repository _repository = Repository();

  Future <Object> getSubProject(String id) async{
    var response = await _repository.getSubProject(id);
    return response;
  }
  Future<Object> addSubProject(SubProject location) async {
    final locationObject = jsonEncode({
      'name': location.name,
      'description': location.description,
      'parentid': location.parentid,
      'parenttype': location.parenttype,
      'url': location.url,
      'createdby': location.createdby,
      
    });
    var response = await _repository.addSubProject(locationObject);

    return response;
  }

  updateSubProject(SubProject location) async {
    final locationObject = jsonEncode({
      'name': location.name,
      'description': location.description,      
      'url': location.url,      
      'lasteditedby': location.lasteditedby
    });
    var response =
        await _repository.updateSubProject(locationObject, location.id as String);
    return response;
  }
}

final subProjectsBloc = SubProjectBloc();
