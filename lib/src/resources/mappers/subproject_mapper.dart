import 'package:deckinspectors/src/models/project_model.dart';
import 'package:deckinspectors/src/models/realm/realm_schemas.dart';
import 'package:deckinspectors/src/resources/mappers/child_mapper.dart';

import '../../models/subproject_model.dart';

//part 'project_mapper.g.dart';

//@Mapper()
class SubProjectMapper {
  ChildMapper mapper = ChildMapper();
  SubProject? fromLocalSubProject(LocalSubProject? localSubProject) {
    if (localSubProject == null) {
      return null;
    }
    List<Child> children = [];
    for (var element in localSubProject.children) {
      children.add(mapper.fromLocalChild(element) as Child);
    }

    final subProject = SubProject(
        id: localSubProject.id,
        name: localSubProject.name,
        parentid: localSubProject.parentid,
        description: localSubProject.description,
        parenttype: localSubProject.parenttype,
        createdat: localSubProject.createdat,
        createdby: localSubProject.createdby,
        url: localSubProject.url,
        type: localSubProject.type,
        editedat: localSubProject.editedat,
        lasteditedby: localSubProject.lasteditedby,
        children: children);
    return subProject;
  }

  LocalSubProject fromSubProject(SubProject subProject) {
    List<LocalChild> children = [];

    if (subProject.children != null) {
      for (var element in subProject.children!) {
        children.add(mapper.fromChild(element) as LocalChild);
      }
    }

    final localProject = LocalSubProject(subProject.id,
        name: subProject.name,
        parentid: subProject.parentid,
        description: subProject.description,
        parenttype: subProject.parenttype,
        createdat: subProject.createdat,
        createdby: subProject.createdby,
        url: subProject.url,
        type: subProject.type,
        editedat: subProject.editedat,
        lasteditedby: subProject.lasteditedby,
        children: children);
    return localProject;
  }
}
