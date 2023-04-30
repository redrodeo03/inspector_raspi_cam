import 'package:deckinspectors/src/ui/cachedimage_widget.dart';
import 'package:deckinspectors/src/ui/project_details.dart';
import 'package:flutter/material.dart';

import '../bloc/projects_bloc.dart';
import '../bloc/users_bloc.dart';
import '../models/error_response.dart';
import '../models/project_model.dart';
import 'addedit_project.dart';

class OfflineModePage extends StatelessWidget {
  OfflineModePage({super.key});

  late final String userFullName = getFullUsername();
  String getFullUsername() {
    var loggedInUser = usersBloc.userDetails;
    var userFullName = loggedInUser.firstname as String;
    userFullName = "$userFullName ${loggedInUser.lastname as String}";
    return userFullName;
  }

  void addNewProject(BuildContext context) {
    Project newProject = Project(
        name: "",
        description: "",
        address: "",
        url: "",
        createdby: userFullName);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddEditProjectPage(newProject, userFullName)));
  }

  @override
  Widget build(BuildContext context) {
    projectsBloc.fetchAllProjects();
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 20,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Offline Projects',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
      ),
      body: Center(
          child: Column(
        children: [
          Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: [
                  const Icon(Icons.wifi_off_outlined),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Offline project are for working in poor network area.You can start an offline project and upload to the database once you have connectivity.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                      onTap: () => addNewProject(context),
                      child: const Chip(
                        padding: EdgeInsets.all(8),
                        labelPadding: EdgeInsets.all(4),
                        label: Text(
                          'Start a new offline project',
                          style: TextStyle(color: Colors.white),
                          selectionColor: Colors.white,
                        ),
                        shadowColor: Colors.blue,
                        backgroundColor: Colors.blue,
                        elevation: 10,
                        autofocus: true,
                      )),
                ],
              )),
          //show offline projects
          Expanded(
            child: FutureBuilder(
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        '${snapshot.error} occurred',
                        style: const TextStyle(fontSize: 18),
                      ),
                    );

                    // if we got our data
                  } else if (snapshot.hasData) {
                    final data = snapshot.data;
                    if (data is Projects) {
                      var offlineProjects = data.projects;

                      return ListView.builder(
                          itemCount: offlineProjects!.length,
                          itemBuilder: (context, index) {
                            //final projUrl = projects[index]?.url?.isEmpty?'assets/images/icon.png':projects[index]?.url;
                            final projType =
                                offlineProjects[index]?.projecttype == null
                                    ? "Multi-Level"
                                    : offlineProjects[index]?.projecttype
                                        as String;

                            return SizedBox(
                              height: 120,
                              child: Card(
                                borderOnForeground: false,
                                elevation: 4,
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8, 8.0, 8, 8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          gotoProjectDetails(
                                              context,
                                              offlineProjects[index]!.id
                                                  as String);
                                        },
                                        child: Container(
                                          width: 90.0,
                                          height: 90.0,
                                          decoration: const BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0)),
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 1.0,
                                                    color: Colors.blue)
                                              ]),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: cachedNetworkImage(
                                                offlineProjects[index]!.url),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            2, 8, 2, 8),
                                        child: Column(
                                          children: <Widget>[
                                            // Expanded(
                                            //child:
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                offlineProjects[index]?.name
                                                    as String,
                                                maxLines: 2,
                                                overflow: TextOverflow.fade,
                                                textAlign: TextAlign.left,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            // ),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 8, 0, 0),
                                                        child: Text(
                                                          projType,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style:
                                                              const TextStyle(
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  0, 12, 0, 0),
                                                          child: GestureDetector(
                                                              onTap: () async {
                                                                gotoProjectDetails(
                                                                    context,
                                                                    offlineProjects[index]!
                                                                            .id
                                                                        as String);
                                                              },
                                                              child: Container(
                                                                  alignment: Alignment.bottomRight,
                                                                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                                                                  child: const Text(
                                                                    'View',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue,
                                                                        fontSize:
                                                                            17),
                                                                  ))))
                                                    ],
                                                  ),
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
                          });
                    }
                    if (data is ErrorResponse) {
                      return Center(
                        child: Text(
                          '${data?.message}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      );
                    }
                  }
                }

                // Displaying LoadingSpinner to indicate waiting state
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              future: projectsBloc.fetchAllOfflineProjects(),
            ),
          ),
          Stack(alignment: Alignment.center, children: [
            const Divider(
              color: Color.fromARGB(255, 222, 213, 213),
              height: 5,
              thickness: 2,
              indent: 30,
              endIndent: 30,
            ),
            Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(width: 0),
                  shape: BoxShape.circle,
                  // You can use like this way or like the below line
                  //borderRadius: new BorderRadius.circular(30.0),
                  color: Colors.lightBlue,
                ),
                child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Or',
                      style: TextStyle(color: Colors.white),
                    ))),
          ]),
          const Padding(
              padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Available to download',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              )),
          const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Your admin had made these projects available for offline work.You can download this project and merge with the database once complete',
                  style: TextStyle(fontSize: 13),
                ),
              )),
          Expanded(
              child: StreamBuilder(
                  stream: projectsBloc.projects,
                  builder: (context, AsyncSnapshot<Projects> snapshot) {
                    if (snapshot.hasData) {
                      final projects = snapshot.data?.projects;
                      if (projects == null) {
                        return const Center(
                            child: Text(
                          'No Projects to display, please add projects',
                          style: TextStyle(fontSize: 16, color: Colors.blue),
                        ));
                      } else {
                        if (projects.isEmpty) {
                          return const Center(
                              child: Text(
                            'No Projects to display, please add projects',
                            style: TextStyle(fontSize: 16, color: Colors.blue),
                          ));
                        }
                      }
                      return ListView.builder(
                        itemCount: projects.length,
                        itemBuilder: (context, index) {
                          //final projUrl = projects[index]?.url?.isEmpty?'assets/images/icon.png':projects[index]?.url;
                          final projType = projects[index]?.projecttype == null
                              ? "Multi-Level"
                              : projects[index]?.projecttype as String;

                          return SizedBox(
                            height: 120,
                            child: Card(
                              borderOnForeground: false,
                              elevation: 4,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8, 8.0, 8, 8.0),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: 90.0,
                                        height: 90.0,
                                        decoration: const BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0)),
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 1.0,
                                                  color: Colors.blue)
                                            ]),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: cachedNetworkImage(
                                              projects[index]!.url),
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
                                              projects[index]?.name as String,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(0, 8, 0, 0),
                                                      child: Text(
                                                        projType,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: const TextStyle(
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets.fromLTRB(
                                                                0, 12, 0, 0),
                                                        child: GestureDetector(
                                                            onTap: () {
                                                              gotoProjectDetails(
                                                                  context,
                                                                  projects[index]!
                                                                          .id
                                                                      as String);
                                                            },
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .bottomRight,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        0,
                                                                        8,
                                                                        8,
                                                                        8),
                                                                child:
                                                                    const Text(
                                                                  'View',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue,
                                                                      fontSize:
                                                                          17),
                                                                ))))
                                                  ],
                                                ),
                                                Visibility(
                                                    visible: projects[index]!
                                                            .isavailableoffline
                                                        as bool,
                                                    child: GestureDetector(
                                                        onTap: () {},
                                                        child: Container(
                                                            alignment: Alignment
                                                                .bottomRight,
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    8,
                                                                    8,
                                                                    16,
                                                                    8),
                                                            child: const Text(
                                                              'Download',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontSize: 17),
                                                            ))))
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
                    return const Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator());
                  })),
        ],
      )),
    );
  }

  void gotoProjectDetails(BuildContext context, String projectId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProjectDetailsPage(projectId, userFullName)));
  }
}
