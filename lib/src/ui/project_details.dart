import 'package:deckinspectors/src/models/project_model.dart';

import '../models/location_model.dart';
import 'location.dart';
import 'package:flutter/material.dart';
import 'addedit_project.dart';
import 'addedit_location.dart';
import 'subproject.dart';
import 'package:intl/intl.dart';

class ProjectDetailsPage extends StatefulWidget {
  final Project currentProject;
  final String userFullName;

  const ProjectDetailsPage(this.currentProject, this.userFullName, {Key? key})
      : super(key: key);
  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

//Add New Project
class _ProjectDetailsPageState extends State<ProjectDetailsPage>
    with SingleTickerProviderStateMixin {
  late Project currentProject;
  late int selectedTabIndex = 0;
//Tab Controls
  late TabController _tabController;
  late String userFullName;
  late String createdAt;
  late List<Child?> locations;
  late Location newLocation;
  //late Building newBuilding;
  @override
  void initState() {
    super.initState();
    currentProject = widget.currentProject;
    userFullName = widget.userFullName;
    newLocation = Location(
        name: "",
        description: "",
        createdby: userFullName,
        type: 'location',
        parentid: currentProject.id,
        parenttype: 'project');

    var shortDate = DateTime.tryParse(currentProject.createdat as String);
    if (shortDate != null) {
      createdAt = DateFormat.yMMMEd().format(shortDate);
    } else {
      createdAt = "";
    }
    if (currentProject.children != null) {
      locations = currentProject.children!
          .where((element) => element!.type == 'location')
          .toList();
    } else {
      locations = List.empty(growable: true);
    }

    _tabController = TabController(vsync: this, length: 2);

    _tabController.addListener(_handleTabSelection);
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
    setState(() {});
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AddEditProjectPage(currentProject, userFullName)),
    );
  }

  void addNewChild() {
    setState(() {});
    if (selectedTabIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddEditLocationPage(newLocation, userFullName)),
      );
    } else {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //       builder: (context) => AddEditSubProjectPage('Building')),
      // );
    }
  }

  void gotoDetails(String? id) {
    if (selectedTabIndex == 0) {

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LocationPage(id as String,userFullName)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SubProjectDetailsPage()),
      );
    }
  }

  void gotoLocationDetails() {
    setState(() {});
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const AddEditProjectPage()),
    // );
  }

  void gotoSubProjectDetails() {
    setState(() {});
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const AddEditProjectPage()),
    // );
  }

  @override
  Widget build(BuildContext context) {
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
                  'Projects',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
                const Text(
                  'Project',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                ),
                InkWell(
                    onTap: () {
                      addEditProject();
                    },
                    child: const Chip(
                      avatar: Icon(
                        Icons.cloud_sync_outlined,
                        color: Color(0xFF3F3F3F),
                      ),
                      labelPadding: EdgeInsets.all(2),
                      label: Text(
                        'Cloud Sync',
                        style: TextStyle(color: Color(0xFF3F3F3F)),
                        selectionColor: Colors.white,
                      ),
                      shadowColor: Colors.blue,
                      backgroundColor: Colors.blue,
                      elevation: 10,
                      autofocus: true,
                    )),
              ],
            )),
        body: SingleChildScrollView(
            child: Column(
          children: [
            projectDetails(),
            projectChildrenTab(context),
// Expanded(child: projectChildrenTab())
          ],
        )));
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
            height: 180,
            decoration: const BoxDecoration(
                color: Colors.orange,
                // image: networkImage(currentProject.url as String),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [BoxShadow(blurRadius: 1.0, color: Colors.blue)]),
            child: networkImage(currentProject.url as String),
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
                          avatar:
                              Icon(Icons.edit_outlined, color: Colors.black),
                          labelPadding: EdgeInsets.all(2),
                          label: Text(
                            'Edit Project ',
                            style: TextStyle(color: Colors.black),
                            selectionColor: Colors.white,
                          ),
                          shadowColor: Colors.blue,
                          backgroundColor: Colors.blue,
                          elevation: 10,
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

  Image networkImage(String? netWorkImageURL) {
    String imageURL = "";
    if (netWorkImageURL == null) {
      imageURL = "assets/images/blank.png";
    } else {
      imageURL = netWorkImageURL;
    }
    return Image.network(
      imageURL,
      fit: BoxFit.fill,
      // When image is loading from the server it takes some time
      // So we will show progress indicator while loading
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      // When dealing with networks it completes with two states,
      // complete with a value or completed with an error,
      // So handling errors is very important otherwise it will crash the app screen.
      // I showed dummy images from assets when there is an error, you can show some texts or anything you want.
      errorBuilder: (context, exception, stackTrace) {
        return Image.asset(
          'assets/images/heroimage.png',
          fit: BoxFit.cover,
          height: 180,
          width: double.infinity,
        );
      },
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
          tabs: const [
            Tab(
              text: "Project Locations",
              height: 32,
            ),
            Tab(
              text: "Buildings",
              height: 32,
            ),
          ],
          labelColor: Colors.black,
        ),
        Container(
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
                      color: Colors.black,
                    ),
                    labelPadding: const EdgeInsets.all(2),
                    label: Text(
                      'Add $type',
                      style: const TextStyle(color: Colors.black),
                      selectionColor: Colors.white,
                    ),
                    shadowColor: Colors.blue,
                    backgroundColor: Colors.blue,
                    elevation: 10,
                    autofocus: true,
                  )),
            ),
            locations.isEmpty
                ? Center(
                    child: Text(
                    'No $type, Add project $type.',
                    style: const TextStyle(fontSize: 16),
                  ))
                : Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: locations.length,
                        itemBuilder: (BuildContext context, int index) {
                          return horizontalScrollChildren(context, index);
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
              Container(
                height: 140,
                width: 192,
                decoration: const BoxDecoration(
                    color: Colors.orange,
                    // image: networkImage(currentProject.url as String),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    boxShadow: [
                      BoxShadow(blurRadius: 1.0, color: Colors.blue)
                    ]),
                child: networkImage(locations[index]!.url),
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
                      children:  [
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
              Padding(
                  padding: const EdgeInsets.fromLTRB(4, 2, 16, 2),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          maxLines: 1,
                          'Locations  Count:',
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          textAlign: TextAlign.left,
                          locations[index]!.count.toString() ,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          selectionColor: Colors.white,
                        ),
                      ])),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 4, 0.0),
                child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        // the height is 50, the width is full
                        minimumSize: const Size.fromHeight(30),
                        backgroundColor: Colors.white,
                        shadowColor: Colors.blue,
                        elevation: 2),
                    onPressed: () {
                      gotoDetails(locations[index]!.id);
                    },
                    icon: const Icon(Icons.view_carousel_outlined),
                    label: const Text('View Details')),
              ),
            ],
          ),
        ));
  }

  void deleteProject(String? id) {}
}
