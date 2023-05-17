import 'package:deckinspectors/src/bloc/users_bloc.dart';
import 'package:deckinspectors/src/models/realm/realm_schemas.dart';
import 'package:deckinspectors/src/ui/cachedimage_widget.dart';
import 'package:deckinspectors/src/ui/location.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

import '../resources/realm/realm_services.dart';
import 'addedit_project.dart';
import 'project_details.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({Key? key}) : super(key: key);
  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

//Add New Project
class _ProjectsPageState extends State<ProjectsPage> {
  //LoginResponse loggedInUser = LoginResponse();
  late String userFullName;

  @override
  void initState() {
    super.initState();
    var loggedInUser = usersBloc.userDetails;
    userFullName = loggedInUser.firstname as String;
    userFullName = "$userFullName ${loggedInUser.lastname as String}";
  }

  LocalProject getLocalProject() {
    return LocalProject(ObjectId(),
        name: "",
        description: "",
        address: "",
        url: "",
        projecttype: 'multilevel',
        children: [],
        createdby: userFullName);
  }

  void addEditProject() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddEditProjectPage(getLocalProject(), true, userFullName)));
  }

  void gotoProjectDetails(ObjectId projectId) {
    //setState(() {});
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProjectDetailsPage(projectId, userFullName)));
  }

  @override
  Widget build(BuildContext context) {
    //projectsBloc.fetchAllProjects();
    final realmServices = Provider.of<RealmProjectServices>(context);
    return Scaffold(
        appBar: AppBar(
            leadingWidth: 20,
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Projects',
                  style: TextStyle(color: Colors.black),
                ),
                InkWell(
                    onTap: () {
                      addEditProject();
                    },
                    child: const Chip(
                      avatar: Icon(
                        Icons.add_circle_outline,
                        color: Colors.blue,
                      ),
                      labelPadding: EdgeInsets.all(2),
                      label: Text(
                        'Add new project',
                        style: TextStyle(color: Colors.blue),
                        selectionColor: Colors.white,
                      ),
                      shadowColor: Colors.white,
                      backgroundColor: Colors.white,
                      elevation: 0,
                      autofocus: true,
                    )),
              ],
            )),
        body: StreamBuilder<RealmResultsChanges<LocalProject>>(
            //projectsBloc.projects
            stream: realmServices.realm
                .query<LocalProject>("TRUEPREDICATE SORT(_id DESC)")
                .changes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data;

                if (data == null) {
                  return const Center(
                      child: Text(
                    'No Projects to display, please add projects',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  ));
                } else {
                  final projects = data.results;

                  return ListView.builder(
                    itemCount: projects.realm.isClosed ? 0 : projects.length,
                    itemBuilder: (context, index) {
                      final projType = projects[index].projecttype == null
                          ? "Multi-Level"
                          : projects[index].projecttype == 'singlelevel'
                              ? "Single-Level"
                              : "Multi-Level";

                      return SizedBox(
                        height: 120,
                        child: Card(
                          borderOnForeground: false,
//                color: Colors.blue,
                          elevation: 4,
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(8, 8.0, 8, 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (projects[index].projecttype ==
                                        'singlelevel') {
                                      gotoSingleLevelProject(projects[index].id,
                                          projects[index].name as String);
                                    } else {
                                      gotoProjectDetails(projects[index].id);
                                    }
                                  },
                                  child: Container(
                                    width: 90.0,
                                    height: 90.0,
                                    decoration: const BoxDecoration(
                                        color: Colors.orange,
                                        // image: DecorationImage(
                                        //     image: AssetImage(
                                        //         'assets/images/icon.png'),
                                        //     fit: BoxFit.cover),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 1.0,
                                              color: Colors.blue)
                                        ]),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: cachedNetworkImage(
                                          projects[index].url),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(2, 8, 2, 8),
                                  child: Column(
                                    children: <Widget>[
                                      // Expanded(
                                      //child:
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          projects[index].name as String,
                                          maxLines: 2,
                                          overflow: TextOverflow.fade,
                                          textAlign: TextAlign.left,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      // ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 8, 0, 0),
                                                  child: Text(
                                                    projType,
                                                    textAlign: TextAlign.left,
                                                    style: const TextStyle(
                                                      color: Colors.black87,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 12, 0, 0),
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          gotoProjectDetails(
                                                              projects[index]
                                                                  .id);
                                                        },
                                                        child: Container(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0, 8, 8, 8),
                                                            child: const Text(
                                                              'View Visual',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontSize: 17),
                                                            ))))
                                              ],
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  //print('clicked invasive');
                                                },
                                                child: Container(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    padding: const EdgeInsets
                                                        .fromLTRB(8, 8, 16, 8),
                                                    child: const Text(
                                                      'Create Invasive',
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 17),
                                                    )))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              }
              return const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator());
            }));
  }

  void gotoSingleLevelProject(ObjectId id, String name) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LocationPage(id, name, 'Project Locations', userFullName)));
  }
}
