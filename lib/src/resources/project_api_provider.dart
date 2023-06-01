import 'dart:convert';
import 'dart:io';
import 'package:deckinspectors/src/models/project_model.dart';
import 'package:deckinspectors/src/models/success_response.dart';
import 'package:deckinspectors/src/resources/urls.dart';
import 'package:http/http.dart' show Client;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/error_response.dart';

class ProjectsApiProvider {
  Client client = Client();

  Future<Projects> fetchProjects() async {
    final baseUrl = Uri.parse(URLS.allProjectsUrl);
    final response = await client.get(baseUrl);
    //print(response.body.toString());

    if (response.statusCode == 201) {
      return Projects.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load projects');
    }
  }

  Future<Object> getProject(String id) async {
    var endPoint = URLS.manageProjectsUrl + id;
    final baseUrl = Uri.parse(endPoint);
    final response = await client.get(baseUrl);

    if (response.statusCode == 201) {
      return ProjectResponse.fromJson(json.decode(response.body));
    } else {
      return ErrorResponse(message: 'failed', code: response.statusCode);
    }
  }

  Future<Object> addProject(Project project) async {
    final projectObject = jsonEncode({
      'name': project.name,
      'description': project.description,
      'address': project.address,
      'url': project.url,
      'projectType': project.projecttype,
      'createdby': project.createdby
    });
    final baseUrl = Uri.parse(URLS.addProjectsUrl);
    final response = await client.post(baseUrl,
        body: projectObject, headers: {'Content-Type': 'application/json'});
    //print(response.body.toString());

    if (response.statusCode == 201) {
      return SuccessResponse.fromJson(json.decode(response.body));
    } else {
      return ErrorResponse.fromJson(json.decode(response.body));
    }
  }

  Future<Object> updateProject(Project project, String id) async {
    final projectObject = jsonEncode({
      'name': project.name,
      'description': project.description,
      'address': project.address,
      'url': project.url,
      'lasteditedby': project.lasteditedby
    });
    var endPoint = URLS.manageProjectsUrl + id;
    final baseUrl = Uri.parse(endPoint);
    final response = await client.put(baseUrl,
        body: projectObject, headers: {'Content-Type': 'application/json'});
    //print(response.body.toString());

    if (response.statusCode == 201) {
      return SuccessResponse.fromJson(json.decode(response.body));
    } else {
      return ErrorResponse.fromJson(json.decode(response.body));
    }
  }

  deleteProject(Object requestBody, String id) async {
    var endPoint = '${URLS.manageProjectsUrl}id/toggleVisibility';
    final baseUrl = Uri.parse(endPoint);
    final response = await client.post(baseUrl,
        body: requestBody, headers: {'Content-Type': 'application/json'});
    //print(response.body.toString());

    if (response.statusCode == 201) {
      return SuccessResponse.fromJson(json.decode(response.body));
    } else {
      return ErrorResponse.fromJson(json.decode(response.body));
    }
  }

  Future<Object> deleteProjectPermanently(String id) async {
    var endPoint = '${URLS.manageProjectsUrl}$id';
    final baseUrl = Uri.parse(endPoint);
    final response = await client
        .delete(baseUrl, headers: {'Content-Type': 'application/json'});
    //print(response.body.toString());

    if (response.statusCode == 201) {
      return SuccessResponse.fromJson(json.decode(response.body));
    } else {
      return ErrorResponse.fromJson(json.decode(response.body));
    }
  }

  Future<Object> downloadReport(String projectName, String id, String fileType,
      int quality, int imageFactor, String companyName) async {
    try {
      var endPoint = '${URLS.manageProjectsUrl}/generatereport';
      final baseUrl = Uri.parse(endPoint);
      final reportBody = jsonEncode({
        'id': id,
        'companyName': companyName,
        'sectionImageProperties': {
          'compressionQuality': quality,
          'imageFactor': imageFactor,
        },
      });

      final response = await client.post(baseUrl,
          body: reportBody, headers: {'Content-Type': 'application/json'});
      //print(response.body.toString());

      if (response.statusCode == 200) {
        //save file
        Directory? directory = await getApplicationDocumentsDirectory();

        var destDirectory =
            await Directory(path.join(directory.path, companyName))
                .create(recursive: true);
        var reportFile = path.join(destDirectory.path, '$projectName-$id.pdf');
        final file = File(reportFile);

        var writtenFile = await file.writeAsBytes(response.bodyBytes);
        return SuccessResponse(code: 200, message: writtenFile.path);
      } else if (response.statusCode == 500) {
        return ErrorResponse(message: response.body, code: response.statusCode);
      } else {
        return ErrorResponse(code: 502, message: response.body);
      }
    } catch (e) {
      return ErrorResponse(message: e.toString(), code: 502);
    }
  }
}
