import 'dart:convert';

import 'package:deckinspectors/src/models/project_model.dart';
import 'package:rxdart/rxdart.dart';
import '../resources/repository.dart';


class ProjectsBloc {
  final Repository _repository = Repository();

  final _projectsFetcher = PublishSubject<Projects>();

  Stream<Projects> get projects => _projectsFetcher.stream;

  fetchAllProjects() async {
    //print('called projects api');
    Projects projects = await _repository.fetchAllProjects();
    _projectsFetcher.sink.add(projects);
  }

  dispose() {
    _projectsFetcher.close();
  }

Future<Object> addProject(Project project) async {
    
    final projectObject =jsonEncode({
      'name': project.name,
      'description':project.description,
      'address':project.address,
      'url':project.url,
      'projectType':project.projecttype,
      'createdby':project.createdby
    });
    var response = await _repository.addProject(projectObject);   
    fetchAllProjects(); 
    return response;
  }

  updateProject(Project project) async {
    final projectObject =jsonEncode({
      'name': project.name,
      'description':project.description,
      'address':project.address,
      'url':project.url,
      'projectType':project.projecttype,
      'lasteditedby':project.lasteditedby
    });
    var response = await _repository.updateProject(projectObject,project.id as String);
    return response;
  }

}
final projectsBloc = ProjectsBloc();