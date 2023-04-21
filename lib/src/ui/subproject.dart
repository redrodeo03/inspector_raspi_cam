import 'package:deckinspectors/src/bloc/subproject_bloc.dart';
import '../models/error_response.dart';
import '../models/location_model.dart';
import '../models/project_model.dart';
import '../models/subproject_model.dart';
import 'addedit_location.dart';
import 'addedit_subproject.dart';
import 'image_widget.dart';
import 'location.dart';
import 'package:flutter/material.dart';

class SubProjectDetailsPage extends StatefulWidget {
  final String id;
  final String userfullName;

  const SubProjectDetailsPage(this.id, this.userfullName, {Key? key})
      : super(key: key);
  @override
  State<SubProjectDetailsPage> createState() => _SubProjectDetailsPageState();
}

//Add New Project
class _SubProjectDetailsPageState extends State<SubProjectDetailsPage>
    with SingleTickerProviderStateMixin {
  late int selectedTabIndex = 0;
//Tab Controls
  late TabController _tabController;
  String userFullName = "";
  String buildingId = "";

  late SubProject currentBuilding;
  late List<Child?> buildinglocations;
  late List<Child?> apartments;
  late Location newLocation;
  late Location newApartment;

  @override
  void initState() {
    buildingId = widget.id;
    userFullName = widget.userfullName;
    super.initState();
    newLocation = Location(
        name: "",
        description: "",
        createdby: userFullName,
        type: 'location',
        parentid: buildingId,
        parenttype: 'subproject');
    newApartment = Location(
        name: "",
        description: "",
        createdby: userFullName,
        type: 'apartment',
        parentid: buildingId,
        parenttype: 'subproject');    

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

  void addEditSubProject() {
    setState(() {});
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditSubProjectPage(currentBuilding,userFullName)),
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
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddEditLocationPage(newApartment, userFullName)),
      );
    }
  }

  void gotoDetails(String? id,String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LocationPage(id as String,'Building',type, userFullName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        leadingWidth: 120,
        leading: ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios,color: Colors.blue,),
          label: const Text('Project', style: TextStyle(color:Colors.blue),),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
        ),
            backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
            elevation: 0,
          title: const Text(
                  'Building',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                ),
        ),
        body: FutureBuilder(
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
                if (data is SubProjectResponse) {
                  currentBuilding = data.item as SubProject;
                  return SingleChildScrollView(
                      child: Column(
                    children: [
                      buildingDetails(),
                      subProjectChildrenTab(context),
                    ],
                  ));
                }
                if (data is ErrorResponse) {
                  return Center(
                    child: Text(
                      '${data.message}',
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
          future: subProjectsBloc.getSubProject(buildingId),
        )
        );
  }

  Widget buildingDetails() {
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
                // image: DecorationImage(
                //     image: AssetImage('assets/images/icon.png'),
                //     fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [BoxShadow(blurRadius: 1.0, color: Colors.blue)]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: networkImage(currentBuilding.url),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: Text(
                currentBuilding.name as String,
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
                        currentBuilding.description as String,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    InkWell(
                        onTap: () {
                          addEditSubProject();
                        },
                        child: const Chip(
                          avatar: Icon(
                            Icons.edit_outlined,
                            color: Colors.blue,
                          ),
                          labelPadding: EdgeInsets.all(2),
                          label: Text(
                            'Edit Building ',
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
          ),
          const Divider(
            color: Color.fromARGB(255, 222, 213, 213),
            height: 5,
            thickness: 2,
            indent: 0,
            endIndent: 0,
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(0, 8, 0, 0.0),
          //   child: OutlinedButton.icon(
          //       style: OutlinedButton.styleFrom(
          //           side: BorderSide.none,
          //           // the height is 50, the width is full
          //           minimumSize: const Size.fromHeight(30),
          //           backgroundColor: Colors.white,
          //           shadowColor: Colors.red,
          //           elevation: 2),
          //       onPressed: () {
          //         print('delete building');
          //       },
          //       icon: const Icon(
          //         Icons.delete_outlined,
          //         color: Colors.red,
          //       ),
          //       label: const Text(
          //         'Delete Building',
          //         style: TextStyle(color: Colors.red),
          //       )),
          // )
        ],
      ),
    );
  }

  Widget subProjectChildrenTab(BuildContext context) {
    // return DefaultTabController(
    //   length: 2,
    //   child:
    if (currentBuilding.children != null) {
      buildinglocations = currentBuilding.children!
          .where((element) => element!.type == 'location')
          .toList();
      apartments = currentBuilding.children!
          .where((element) => element!.type == 'apartment')
          .toList();
    } else {
      buildinglocations = List.empty(growable: true);
      apartments = List.empty(growable: true);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: "Building Locations",
              height: 32,
            ),
            Tab(
              text: "Apartments",
              height: 32,
            ),
          ],
          labelColor: Colors.black,
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: TabBarView(controller: _tabController, children: [
              locationsWidget('building location'),
              locationsWidget('apartment'),
            ])),
      ],
      // ),
    );
  }

  Widget locationsWidget(String type) {
    
    bool isLocation=true;
    isLocation =type=='building location'?buildinglocations.isEmpty: apartments.isEmpty;
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
                      selectionColor: Colors.white,
                    ),
                    shadowColor: Colors.white,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    autofocus: true,
                  )),
            ),
            isLocation
                ? Center(
                    child: Text(
                    'No $type, Add $type.',
                    style: const TextStyle(fontSize: 16),
                  ))
                : type == 'building location'
                    ? Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: buildinglocations.length,
                            itemBuilder: (BuildContext context, int index) {
                              return horizontalScrollChildren(context, index);
                            }))
                    : Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: apartments.length,
                            itemBuilder: (BuildContext context, int index) {
                              return horizontalScrollChildrenApartments(
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

                child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: networkImage(buildinglocations[index]!.url),
            ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                  child: Text(
                    buildinglocations[index]!.name as String,
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
                            buildinglocations[index]!.description as String,
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
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              buildinglocations[index]!.count.toString(),
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              selectionColor: Colors.white,
                            ),
                          ]))),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 4, 0.0),
                child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        // the height is 50, the width is full
                        minimumSize: const Size.fromHeight(30),
                        backgroundColor: Colors.white,
                        shadowColor: Colors.blue,
                        elevation: 1),
                    onPressed: () {
                      gotoDetails(buildinglocations[index]!.id,'Common Location');
                    },
                    icon: const Icon(Icons.view_carousel_outlined),
                    label: const Text('View Details')),
              ),
            ],
          ),
        ));
  }

  Widget horizontalScrollChildrenApartments(BuildContext context, int index) {
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
                child:ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: networkImage(apartments[index]!.url),
                )
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                  child: Text(
                    apartments[index]!.name as String,
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
                            apartments[index]!.description as String,
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
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              apartments[index]!.count.toString(),
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                              selectionColor: Colors.white,
                            ),
                          ]))),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 4, 0.0),
                child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        // the height is 50, the width is full
                        minimumSize: const Size.fromHeight(30),
                        backgroundColor: Colors.white,
                        shadowColor: Colors.blue,
                        elevation: 1),
                    onPressed: () {
                      gotoDetails(apartments[index]!.id,'Apartment');
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
