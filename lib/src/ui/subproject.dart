import 'package:deckinspectors/src/ui/cachedimage_widget.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

import '../models/realm/realm_schemas.dart';

import '../resources/realm/realm_services.dart';
import 'addedit_location.dart';
import 'addedit_subproject.dart';

import 'location.dart';
import 'package:flutter/material.dart';

class SubProjectDetailsPage extends StatefulWidget {
  final ObjectId id;
  final String userfullName;
  final String prevPageName;
  const SubProjectDetailsPage(this.id, this.prevPageName, this.userfullName,
      {Key? key})
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
  late ObjectId buildingId;

  late LocalSubProject currentBuilding;
  late List<LocalChild?> buildinglocations;
  late List<LocalChild?> apartments;
  late LocalLocation newLocation;
  late LocalLocation newApartment;
  late String prevPageName;

  LocalLocation getLocation(String type) {
    return LocalLocation(ObjectId(), buildingId,
        name: "",
        description: "",
        createdby: userFullName,
        type: type,
        parenttype: 'subproject');
  }

  @override
  void initState() {
    buildingId = widget.id;
    userFullName = widget.userfullName;
    super.initState();
    prevPageName = widget.prevPageName;

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
      MaterialPageRoute(
          builder: (context) =>
              AddEditSubProjectPage(currentBuilding, false, userFullName)),
    ).then((value) => setState(
          () {},
        ));
  }

  void addNewChild() {
    setState(() {});
    if (selectedTabIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddEditLocationPage(
                getLocation('buildinglocation'), true, userFullName)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddEditLocationPage(
                getLocation('apartment'), true, userFullName)),
      );
    }
  }

  void gotoDetails(ObjectId id, String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LocationPage(
              id, currentBuilding.name as String, type, userFullName)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final realmServices = Provider.of<RealmProjectServices>(context);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leadingWidth: 120,
          leading: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.blue,
            ),
            label: Text(
              prevPageName,
              style: const TextStyle(color: Colors.blue),
            ),
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
            style:
                TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          ),
        ),
        body: StreamBuilder<RealmObjectChanges<LocalSubProject>>(
          //projectsBloc.projects
          stream: realmServices.getSubProject(buildingId)!.changes,
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
                currentBuilding = data.object;
                return SingleChildScrollView(
                    child: Column(
                  children: [
                    StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return buildingDetails();
                    }),
                    subProjectChildrenTab(context),
                  ],
                ));
              }
            }

            // Displaying LoadingSpinner to indicate waiting state
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
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
              child: cachedNetworkImage(currentBuilding.url),
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
                          shadowColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
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
        ],
      ),
    );
  }

  Widget subProjectChildrenTab(BuildContext context) {
    // return DefaultTabController(
    //   length: 2,
    //   child:
    buildinglocations = List.empty(growable: true);
    apartments = List.empty(growable: true);

    buildinglocations = currentBuilding.children
        .where((element) => element.type == 'buildinglocation')
        .toList();
    apartments = currentBuilding.children
        .where((element) => element.type == 'apartment')
        .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: "Building Locations (${buildinglocations.length})",
              height: 32,
            ),
            Tab(
              text: "Apartments(${apartments.length})",
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
    bool isLocation = true;
    isLocation = type == 'building location'
        ? buildinglocations.isEmpty
        : apartments.isEmpty;
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
                    shadowColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
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
              GestureDetector(
                onTap: () {
                  gotoDetails(buildinglocations[index]!.id, 'Common Location');
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
                    child: cachedNetworkImage(buildinglocations[index]!.url),
                  ),
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
              //                 buildinglocations[index]!.count.toString(),
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

  Widget horizontalScrollChildrenApartments(BuildContext context, int index) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  gotoDetails(apartments[index]!.id, 'Apartment');
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
                      child: cachedNetworkImage(apartments[index]!.url),
                    )),
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
              //                 apartments[index]!.count.toString(),
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

  void deleteProject(String? id) {}
}
