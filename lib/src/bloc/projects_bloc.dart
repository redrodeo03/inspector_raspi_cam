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

  // Future<Projects> fetchAllOfflineProjects() async {
  //   var response = await _repository.fetchLocalProjects();
  //   return response;
  // }

  Future<Object> getProject(String id) async {
    var response = await _repository.getProject(id);
    return response;
  }

  dispose() {
    _projectsFetcher.close();
  }

  Future<Object> addProject(Project project) async {
    var response = await _repository.addProject(project);
    fetchAllProjects();
    return response;
  }

  Future<Object> updateProject(Project project) async {
    var response =
        await _repository.updateProject(project, project.id as String);
    return response;
  }

  Future<Object> deleteProjectPermanently(Project project, String id) async {
    return _repository.deleteProject(project, id);
  }

  Future<Object> downloadProjectReport(String id, String fileType) {
    return _repository.downloadProjectReport(id, fileType);
  }
}

final projectsBloc = ProjectsBloc();
