import 'package:deckinspectors/src/bloc/settings_bloc.dart';

import 'package:deckinspectors/src/ui/addedit_location.dart';
import 'package:deckinspectors/src/ui/invasivesection.dart';
import 'package:deckinspectors/src/ui/section.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

import '../models/realm/realm_schemas.dart';
import '../resources/realm/realm_services.dart';
import 'cachedimage_widget.dart';
import 'showprojecttype_widget.dart';

class LocationPage extends StatefulWidget {
  final ObjectId id;
  final String userFullName;
  final String parentType;
  final String locationType;
  const LocationPage(
      this.id, this.parentType, this.locationType, this.userFullName,
      {Key? key})
      : super(key: key);
  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  void initState() {
    locationId = widget.id;
    parenttype = widget.parentType;
    userFullName = widget.userFullName;
    locationType = widget.locationType;
    super.initState();
  }

  String locationType = '';
  String parenttype = 'Project';
  String userFullName = "";
  late ObjectId locationId;
  late LocalLocation currentLocation;
  @override
  Widget build(BuildContext context) {
    final realmServices =
        Provider.of<RealmProjectServices>(context, listen: false);
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
              parenttype,
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
          title: Text(
            locationType,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.normal),
          ),
        ),
        body: StreamBuilder<RealmObjectChanges<LocalLocation>>(
            //projectsBloc.projects
            stream: realmServices.getLocation(locationId)!.changes,
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
                  currentLocation = data.object;
                  return SingleChildScrollView(
                      child: Column(
                    children: [
                      locationDetails(currentLocation),
                      locationsWidget(context),
                    ],
                  ));
                }
              }

              // Displaying LoadingSpinner to indicate waiting state
              return const Center(
                child: CircularProgressIndicator(),
              );
            }));
  }

  Widget locationDetails(LocalLocation currentLocation) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 4,
          ),
          const ProjectType(),
          Container(
            height: 220,
            decoration: BoxDecoration(
                color: appSettings.isInvasiveMode ? Colors.orange : Colors.blue,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(8.0)),
                boxShadow: const [
                  BoxShadow(blurRadius: 1.0, color: Colors.blue)
                ]),
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(8.0)),
              child: cachedNetworkImage(currentLocation.url),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: Text(
                currentLocation.name as String,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 16,
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
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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
                        currentLocation.description as String,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Visibility(
                      visible: !appSettings.isInvasiveMode,
                      child: InkWell(
                          onTap: () {
                            addEditLocation(currentLocation);
                          },
                          child: const Chip(
                            avatar: Icon(
                              Icons.edit_outlined,
                              color: Colors.blue,
                            ),
                            labelPadding: EdgeInsets.all(2),
                            label: Text(
                              'Edit',
                              style: TextStyle(color: Colors.blue),
                              selectionColor: Colors.transparent,
                            ),
                            shadowColor: Colors.white,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            autofocus: true,
                          )),
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

  Widget locationsWidget(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height / 1.4,
        child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(2),
                      child: Text(
                        'Locations',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Visibility(
                      visible: !appSettings.isInvasiveMode,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                            onTap: () {
                              addNewChild();
                            },
                            child: const Chip(
                              avatar: Icon(
                                Icons.add_circle_outline,
                                color: Colors.blue,
                              ),
                              labelPadding: EdgeInsets.all(2),
                              label: Text(
                                'Add Location',
                                style: TextStyle(color: Colors.blue),
                                selectionColor: Colors.transparent,
                              ),
                              shadowColor: Colors.white,
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              autofocus: true,
                            )),
                      ),
                    ),
                  ],
                ),
                appSettings.isInvasiveMode
                    ? currentLocation.invasiveSections.isEmpty
                        ? const Center(
                            child: Text(
                            'No invasive locations to show.',
                            style: TextStyle(fontSize: 16),
                          ))
                        : Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    currentLocation.invasiveSections.length,
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    horizontalScrollChildren(context, index)),
                          )
                    : currentLocation.sections.isEmpty
                        ? const Center(
                            child: Text(
                            'No locations, Add locations.',
                            style: TextStyle(fontSize: 16),
                          ))
                        : Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: currentLocation.sections.length,
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    horizontalScrollChildren(context, index)),
                          )
              ],
            )));
  }

  Widget horizontalScrollChildren(BuildContext context, int index) {
    String vreview = '';
    String visualReview = appSettings.isInvasiveMode
        ? (currentLocation.invasiveSections[index].visualreview as String)
        : (currentLocation.sections[index].visualreview as String);
    switch (visualReview) {
      case 'good':
        vreview = 'Good';
        break;
      case 'fair':
        vreview = 'Fair';
        break;
      case 'bad':
        vreview = 'Bad';
        break;
      default:
    }
    String assessment = '';
    String? coverUrl = appSettings.isInvasiveMode
        ? currentLocation.invasiveSections[index].coverUrl
        : currentLocation.sections[index].coverUrl;
    String assessmentActual = appSettings.isInvasiveMode
        ? (currentLocation.invasiveSections[index].conditionalassessment
            as String)
        : (currentLocation.sections[index].conditionalassessment as String);
    switch (assessmentActual) {
      case 'pass':
        assessment = 'Pass';
        break;
      case 'fail':
        assessment = 'Fail';
        break;
      case 'futureinspection':
        assessment = 'Future Inspection';
        break;
      default:
    }
    bool furtherInvasive = appSettings.isInvasiveMode
        ? currentLocation.invasiveSections[index].furtherinvasivereviewrequired
        : currentLocation.sections[index].furtherinvasivereviewrequired;

    bool visualLeaks = appSettings.isInvasiveMode
        ? currentLocation.invasiveSections[index].visualsignsofleak
        : currentLocation.sections[index].visualsignsofleak;
    return SizedBox(
      width: MediaQuery.of(context).size.width - 70,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 2, 8, 4),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: appSettings.isInvasiveMode ? Colors.orange : Colors.blue,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
                bottom: Radius.circular(00),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: cachedNetworkImage(coverUrl),
            ),
          ),
          InkWell(
              onTap: () {
                if (appSettings.isInvasiveMode) {
                  gotoInvasiveDetails(
                      currentLocation.invasiveSections[index].id);
                } else {
                  gotoDetails(currentLocation.sections[index].id);
                }
              },
              child: Card(
                  shadowColor: Colors.blue,
                  elevation: 8,
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              appSettings.isInvasiveMode
                                  ? currentLocation.invasiveSections[index].name
                                      as String
                                  : currentLocation.sections[index].name
                                      as String,
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Icon(
                              Icons.navigate_next_sharp,
                              color: Colors.blue,
                            )
                          ]),
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 20,
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 2, 4, 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  maxLines: 1,
                                  'Visual Review',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    vreview,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )),
                            ],
                          )),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 2, 4, 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  maxLines: 1,
                                  'Visual signs of leak',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    visualLeaks == true ? 'True' : 'False',
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )),
                            ],
                          )),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 2, 4, 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  maxLines: 1,
                                  'Further Inspection',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    furtherInvasive == true ? 'True' : 'False',
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )),
                            ],
                          )),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 2, 4, 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  maxLines: 1,
                                  'Conditional assesment',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    assessment,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )),
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 2, 4, 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  maxLines: 1,
                                  'Images',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Text(
                                    appSettings.isInvasiveMode
                                        ? currentLocation
                                            .invasiveSections[index].count
                                            .toString()
                                        : currentLocation.sections[index].count
                                            .toString(),
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )),
                            ],
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ])))
        ]),
      ),
    );
  }

  void addNewChild() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SectionPage(
                ObjectId(),
                currentLocation.id,
                userFullName,
                parenttype,
                currentLocation.name as String,
                true))).then((value) => setState(() {}));
  }

  void gotoDetails(ObjectId sectionId) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SectionPage(sectionId, currentLocation.id,
              userFullName, parenttype, currentLocation.name as String, false),
        )).then((value) {
      if (!mounted) {
        return;
      }
      setState(
        () {},
      );
    });
  }

  void addEditLocation(LocalLocation currentLocation) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddEditLocationPage(currentLocation, false,
              userFullName, currentLocation.name as String)),
    );
  }

  void gotoInvasiveDetails(ObjectId id) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => InvasiveSectionPage(id, currentLocation.id,
              userFullName, parenttype, currentLocation.name as String, false),
        )).then((value) {
      if (!mounted) {
        return;
      }
      setState(
        () {},
      );
    });
  }
}
