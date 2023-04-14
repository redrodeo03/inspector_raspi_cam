import 'dart:convert';
import '../models/location_model.dart';
import '../resources/repository.dart';

class LocationsBloc {
  final Repository _repository = Repository();

  Future <Object> getLocation(String id) async{
    var response = await _repository.getLocation(id);
    return response;
  }
  Future<Object> addLocation(Location location) async {
    final locationObject = jsonEncode({
      'name': location.name,
      'description': location.description,
      'parentid': location.parentid,
      'parenttype': location.parenttype,
      'url': location.url,
      'createdby': location.createdby,
      'type':location.type
    });
    var response = await _repository.addLocation(locationObject);

    return response;
  }

  updateLocation(Location location) async {
    final locationObject = jsonEncode({
      'name': location.name,
      'description': location.description,      
      'url': location.url,      
      'lasteditedby': location.lasteditedby
    });
    var response =
        await _repository.updateLocation(locationObject, location.id as String);
    return response;
  }

  deleteLocation(String id,String? type,String name, String parentId,String parentType,bool isVisible ) async{
    
    final locationObject = jsonEncode({
      'name': name,
      'type':type,
      'parentType':parentType,
      'isVisible':isVisible,      
      'parentId':parentId
    });
    var response =
        await _repository.deleteLocation(locationObject, id );
    return response;
  }
}

final locationsBloc = LocationsBloc();
