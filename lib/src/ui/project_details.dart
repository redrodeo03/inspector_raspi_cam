import 'dart:async' as async;

import 'package:deckinspectors/src/resources/realm/realm_services.dart';
import 'package:deckinspectors/src/ui/cachedimage_widget.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

import '../models/realm/realm_schemas.dart';

import 'addedit_subproject.dart';

import 'location.dart';
import 'package:flutter/material.dart';
import 'addedit_project.dart';
import 'addedit_location.dart';
import 'subproject.dart';
import 'package:intl/intl.dart';

class ProjectDetailsPage extends StatefulWidget {
  final ObjectId id;
  final String userFullName;

  const ProjectDetailsPage(this.id, this.userFullName, {Key? key})
      : super(key: key);
  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

//Add New Project
class _ProjectDetailsPageState extends State<ProjectDetailsPage>
    with SingleTickerProviderStateMixin {
  late LocalProject currentProject;
  late int selectedTabIndex = 0;
//Tab Controls
  late TabController _tabController;
  late String userFullName;
  late String createdAt;
  late List<LocalChild?> locations;
  late List<LocalChild?> buildings;

  late ObjectId projectId;
  //late Building newBuilding;

  LocalLocation getNewLocation() {
    var newLocation = LocalLocation(ObjectId(), projectId,
        name: "",
        description: "",
        createdby: userFullName,
        type: 'projectlocation',
        parenttype: 'project');
    return newLocation;
  }

  LocalSubProject getNewBuilding() {
    var newBuilding = LocalSubProject(ObjectId(), projectId,
        name: "",
        description: "",
        createdby: userFullName,
        type: 'subproject',
        parenttype: 'project');
    return newBuilding;
  }

  @override
  void initState() {
    super.initState();
    projectId = widget.id;
    userFullName = widget.userFullName;

    _tabController = TabController(vsync: this, length: 2);

    _tabController.addListener(_handleTabSelection);
    locations = List.empty(growable: true);
    buildings = List.empty(growable: true);
  }

  async.FutureOr refreshProjectDetails(dynamic value) async {
    // var response = await projectsBloc.getProject(currentProject.id as String);
    // if (response is Project) {
    //   currentProject = response;
    // } else {
    //   //
    // }
    setState(() {
      if (currentProject.isValid) {
        locations = currentProject.children
            .where((element) => element.type == 'location')
            .toList();
        buildings = currentProject.children
            .where((element) => element.type == 'subproject')
            .toList();
      }
    });
  }

  void _handleTabSelection() {
    switch (_tabController.index) {
      case 0:
        selectedTabIndex = 0;
        break;
      case 1:
        selectedTabIndex = 1;
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void addEditProject() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AddEditProjectPage(currentProject, false, userFullName)),
    );
  }

  void addNewChild() {
    //setState(() {});
    if (selectedTabIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddEditLocationPage(getNewLocation(), true, userFullName)),
      ); //.then(refreshProjectDetails);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddEditSubProjectPage(getNewBuilding(), true, userFullName)),
      ); //.then(refreshProjectDetails);
    }
  }

  void gotoDetails(ObjectId id, String name) {
    if (selectedTabIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                LocationPage(id, name, 'Project Locations', userFullName)),
      ).then((value) => locations.remove(value));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SubProjectDetailsPage(id, name, userFullName)),
      ).then((value) => buildings.remove(value));
    }
  }

  @override
  Widget build(BuildContext context) {
    final realmServices =
        Provider.of<RealmProjectServices>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            leadingWidth: 140,
            leading: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.blue,
              ),
              label: const Text(
                'Home',
                style: TextStyle(color: Colors.blue),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
            ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Project',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                        onTap: () {
                          addEditProject();
                        },
                        child: const Chip(
                          avatar: Icon(
                            Icons.cloud_sync_outlined,
                            color: Colors.black,
                          ),
                          labelPadding: EdgeInsets.all(2),
                          label: Text(
                            'Cloud Sync',
                            style: TextStyle(color: Colors.black),
                            selectionColor: Colors.white,
                          ),
                          shadowColor: Colors.blue,
                          backgroundColor: Colors.blue,
                          elevation: 10,
                          autofocus: true,
                        )),
                  ),
                )
              ],
            )),
        body: StreamBuilder<RealmObjectChanges<LocalProject>>(
          //projectsBloc.projects
          stream: realmServices.getProject(projectId)?.changes,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;

              if (data == null) {
                return Center(
                  child: Text(
                    '${snapshot.error} occurred',
                    style: const TextStyle(fontSize: 18),
                  ),
                );

                // if we got our data
              } else {
                currentProject = data.object;
                if (currentProject.isValid) {
                  locations = currentProject.children
                      .where((element) => element.type == 'location')
                      .toList();
                  buildings = currentProject.children
                      .where((element) => element.type == 'subproject')
                      .toList();
                  var shortDate =
                      DateTime.tryParse(currentProject.createdat as String);
                  if (shortDate != null) {
                    createdAt = DateFormat.yMMMEd().format(shortDate);
                  } else {
                    createdAt = "";
                  }
                }

                return SingleChildScrollView(
                    child: Column(
                  children: [
                    // StatefulBuilder(builder: (context, StateSetter setState) {
                    projectDetails(),
                    //}),
                    projectChildrenTab(context),
                  ],
                ));

                // if (data is ErrorResponse) {
                //   return Center(
                //     child: Text(
                //       '${data.message}',
                //       style: const TextStyle(fontSize: 18),
                //     ),
                //   );
                // }
              }
            }

            // Displaying LoadingSpinner to indicate waiting state
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  Widget projectDetails() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 4,
          ),
          Container(
            height: 220,
            decoration: const BoxDecoration(
                color: Colors.orange,
                // image: networkImage(currentProject.url as String),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [BoxShadow(blurRadius: 1.0, color: Colors.blue)]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: cachedNetworkImage(currentProject.url),
            ),
          ),
          //networkImage(currentProject.url as String),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: Text(
                currentProject.name as String,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Text(
                'Description',
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        maxLines: 2,
                        currentProject.description as String,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          addEditProject();
                        },
                        child: const Chip(
                          avatar: Icon(Icons.edit_outlined, color: Colors.blue),
                          labelPadding: EdgeInsets.all(2),
                          label: Text(
                            'Edit Project ',
                            style: TextStyle(color: Colors.blue),
                            selectionColor: Colors.transparent,
                          ),
                          shadowColor: Colors.white,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          autofocus: true,
                        )),
                  ],
                )),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Created By:',
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      userFullName,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      createdAt,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                )),
          ),
          const Divider(
            color: Color.fromARGB(255, 222, 213, 213),
            height: 5,
            thickness: 2,
            indent: 0,
            endIndent: 0,
          ),
        ],
      ),
    );
  }

  Widget projectChildrenTab(BuildContext context) {
    // return DefaultTabController(
    //   length: 2,
    //   child:
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: "Project Locations (${locations.length})",
              height: 32,
            ),
            Tab(
              text: "Buildings (${buildings.length})",
              height: 32,
            ),
          ],
          labelColor: Colors.black,
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: TabBarView(controller: _tabController, children: [
              locationsWidget('location'),
              locationsWidget('building'),
            ])),
      ],
      // ),
    );
  }

  Widget locationsWidget(String type) {
    return Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                  onTap: () {
                    addNewChild();
                  },
                  child: Chip(
                    avatar: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.blue,
                    ),
                    labelPadding: const EdgeInsets.all(2),
                    label: Text(
                      'Add $type',
                      style: const TextStyle(color: Colors.blue, fontSize: 15),
                      selectionColor: Colors.transparent,
                    ),
                    shadowColor: Colors.white,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    autofocus: true,
                  )),
            ),
            locations.isEmpty
                ? Center(
                    child: Text(
                    'No $type, Add project $type.',
                    style: const TextStyle(fontSize: 16),
                  ))
                : type == 'location'
                    ? Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: locations.length,
                            itemBuilder: (BuildContext context, int index) {
                              return horizontalScrollChildren(context, index);
                            }))
                    : Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: buildings.length,
                            itemBuilder: (BuildContext context, int index) {
                              return horizontalScrollChildrenBuildings(
                                  context, index);
                            }))
          ],
        ));
  }

  //Todo create widget for locations
  Widget horizontalScrollChildren(BuildContext context, int index) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  gotoDetails(
                      locations[index]!.id, currentProject.name as String);
                },
                child: Container(
                  height: 140,
                  width: 192,
                  decoration: const BoxDecoration(
                      color: Colors.orange,
                      // image: networkImage(currentProject.url as String),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      boxShadow: [
                        BoxShadow(blurRadius: 1.0, color: Colors.blue)
                      ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: cachedNetworkImage(locations[index]!.url),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                  child: Text(
                    locations[index]!.name as String,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Text(
                            maxLines: 2,
                            locations[index]!.description as String,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    )),
              ),
              const SizedBox(
                height: 8,
              ),
              // Padding(
              //     padding: const EdgeInsets.fromLTRB(4, 2, 16, 2),
              //     child: Align(
              //         alignment: Alignment.centerLeft,
              //         child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               const Text(
              //                 maxLines: 1,
              //                 'Locations  Count:',
              //                 style: TextStyle(
              //                   overflow: TextOverflow.ellipsis,
              //                   fontSize: 13,
              //                 ),
              //                 textAlign: TextAlign.center,
              //               ),
              //               Text(
              //                 textAlign: TextAlign.left,
              //                 locations[index]!.count.toString(),
              //                 style: const TextStyle(
              //                     color: Colors.blue,
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 14),
              //                 selectionColor: Colors.white,
              //               ),
              //             ]))),
            ],
          ),
        ));
  }

  Widget horizontalScrollChildrenBuildings(BuildContext context, int index) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  gotoDetails(
                      buildings[index]!.id, currentProject.name as String);
                },
                child: Container(
                  height: 140,
                  width: 192,
                  decoration: const BoxDecoration(
                      color: Colors.orange,
                      // image: networkImage(currentProject.url as String),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      boxShadow: [
                        BoxShadow(blurRadius: 1.0, color: Colors.blue)
                      ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: cachedNetworkImage(buildings[index]!.url),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                  child: Text(
                    buildings[index]!.name as String,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Text(
                            maxLines: 2,
                            buildings[index]!.description as String,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    )),
              ),
              const SizedBox(
                height: 8,
              ),
              // Padding(
              //     padding: const EdgeInsets.fromLTRB(4, 2, 16, 2),
              //     child: Align(
              //         alignment: Alignment.centerLeft,
              //         child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               const Text(
              //                 maxLines: 1,
              //                 'Locations  Count:',
              //                 style: TextStyle(
              //                   overflow: TextOverflow.ellipsis,
              //                   fontSize: 13,
              //                 ),
              //                 textAlign: TextAlign.center,
              //               ),
              //               Text(
              //                 textAlign: TextAlign.left,
              //                 buildings[index]!.count.toString(),
              //                 style: const TextStyle(
              //                     color: Colors.blue,
              //                     fontWeight: FontWeight.bold,
              //                     fontSize: 14),
              //                 selectionColor: Colors.white,
              //               ),
              //             ]))),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(4, 8, 4, 0.0),
              //   child: OutlinedButton.icon(
              //       style: OutlinedButton.styleFrom(
              //           side: BorderSide.none,
              //           // the height is 50, the width is full
              //           minimumSize: const Size.fromHeight(30),
              //           backgroundColor: Colors.white,
              //           shadowColor: Colors.blue,
              //           elevation: 1),
              //       onPressed: () {
              //         gotoDetails(buildings[index]!.id);
              //       },
              //       icon: const Icon(Icons.view_carousel_outlined),
              //       label: const Text('View Details')),
              // ),
            ],
          ),
        ));
  }
}
