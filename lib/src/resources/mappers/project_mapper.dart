import 'package:deckinspectors/src/models/project_model.dart';
import 'package:deckinspectors/src/models/realm/realm_schemas.dart';
import 'package:deckinspectors/src/resources/mappers/child_mapper.dart';

//part 'project_mapper.g.dart';

//@Mapper()
class ProjectMapper {
  ChildMapper mapper = ChildMapper();
  Project? fromLocalProject(LocalProject? localProject) {
    if (localProject == null) {
      return null;
    }
    List<Child> children = [];
    for (var element in localProject.children) {
      children.add(mapper.fromLocalChild(element) as Child);
    }

    final project = Project(
        id: localProject.id,
        name: localProject.name,
        address: localProject.address,
        description: localProject.description,
        projecttype: localProject.projecttype,
        createdat: localProject.createdat,
        createdby: localProject.createdby,
        url: localProject.url,
        editedat: localProject.editedat,
        lasteditedby: localProject.lasteditedby,
        children: children);
    return project;
  }

  LocalProject fromProject(Project project) {
    List<LocalChild> children = [];

    if (project.children != null) {
      for (var element in project.children!) {
        children.add(mapper.fromChild(element) as LocalChild);
      }
    }

    final localProject = LocalProject(project.id,
        name: project.name,
        address: project.address,
        description: project.description,
        projecttype: project.projecttype,
        createdat: project.createdat,
        createdby: project.createdby,
        url: project.url,
        editedat: project.editedat,
        lasteditedby: project.lasteditedby,
        children: children);
    return localProject;
  }
}
