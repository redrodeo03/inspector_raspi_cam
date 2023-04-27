// import 'package:realm/realm.dart';

// import '../models/project_model.dart';

// class ProjectModel {
//   late Realm realm;

//   ProjectModel() {
//     var config = Configuration.local([Project.schema]);
//     realm = Realm(config);

//     var allItems = realm.all<Project>();

//   }

  
//   /// Get item by [id].
//   Project getById(int id) {
//     final objId = id % 14;

//     final item = realm.find<Project>(objId)!;
//     return item;
//   }

  
// }