import 'package:deckinspectors/src/models/project_model.dart';
import 'package:deckinspectors/src/models/realm/realm_schemas.dart';

class ChildMapper {
  Child? fromLocalChild(LocalChild? localChild) {
    if (localChild == null) {
      return null;
    }
    final child = Child(
        id: localChild.id,
        name: localChild.name,
        type: localChild.type,
        description: localChild.description,
        url: localChild.url,
        count: localChild.count);
    return child;
  }

  LocalChild? fromChild(Child child) {
    final localChild = LocalChild(
        id: child.id,
        name: child.name,
        type: child.type,
        description: child.description,
        url: child.url,
        count: child.count);
    return localChild;
  }
}
