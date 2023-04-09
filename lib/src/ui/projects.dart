import 'package:deckinspectors/src/bloc/users_bloc.dart';

import 'package:flutter/material.dart';
import '../models/project_model.dart';
import '../bloc/projects_bloc.dart';
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
  late Project newProject;
  @override
  void initState(){
    super.initState();
    var loggedInUser = usersBloc.userDetails;
    userFullName = loggedInUser.firstname as String ;
    userFullName = "$userFullName ${loggedInUser.lastname as String}";
    newProject = Project(name: "", description: "",address: "",url: "",createdby: userFullName );
  }
  
  void addEditProject() {
    setState(() {});
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditProjectPage(newProject,userFullName))
    );
  }

  void gotoProjectDetails(Project currentProject ) {
    setState(() {});
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProjectDetailsPage(currentProject,userFullName))
    );
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
        body: StreamBuilder(
            stream: projectsBloc.projects,
            builder: (context, AsyncSnapshot<Projects> snapshot) {
              if (snapshot.hasData) {
                final projects = snapshot.data?.projects;
                if (projects == null) {
                  return const Text(
                    'No Projects to display, please add projects',
                    style: TextStyle(fontSize: 16, color: Colors.blue),
                  );
                } else {
                  if (projects.isEmpty) {
                    return const Text(
                      'No Projects to display, please add projects',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    );
                  }
                }
                return ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    //final projUrl = projects[index]?.url?.isEmpty?'assets/images/icon.png':projects[index]?.url;
                    final projType = projects[index]?.projecttype == null
                        ? "Multi-Level"
                        : projects[index]?.projecttype as String;
                    // final createdAt = projects[index]?.createdat == null
                    //     ? ""
                    //     : projects[index]?.createdat as String;
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
                                  const EdgeInsets.fromLTRB(16, 8.0, 16, 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  gotoProjectDetails(projects[index] as Project);
                                },
                                child: Container(
                                  width: 90.0,
                                  height: 90.0,
                                  decoration: const BoxDecoration(
                                      color: Colors.orange,
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/icon.png'),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 1.0, color: Colors.blue)
                                      ]),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(2, 8, 2, 8),
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
                                            MainAxisAlignment.spaceBetween,                                            
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Padding(padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                              child:
                                               Text(
                                                  projType,
                                                  textAlign: TextAlign.left,
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                  ),
                                                ),),
                                              Padding(padding: const EdgeInsets.fromLTRB(0,12,0,0),
                                              child:
                                              GestureDetector(
                                              onTap: () {
                                                gotoProjectDetails(projects[index] as Project);
                                              },
                                              child: Container(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(0,8,8,8),
                                                  child: const Text(
                                                    'View Visual',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 17),
                                                  )))
                                              )
                                            ],
                                          ),
                                          GestureDetector(
                                              onTap: () {
                                                print('clicked invasive');
                                              },
                                              child: Container(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(8,8,16,8),
                                                  child: const Text(
                                                    'Invasive',
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
              return const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator());
            }));
  }
}
