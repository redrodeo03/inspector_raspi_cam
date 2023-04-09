import 'package:deckinspectors/src/bloc/locations_bloc.dart';
import 'package:deckinspectors/src/bloc/section_bloc.dart';
import 'package:deckinspectors/src/models/error_response.dart';
import 'package:deckinspectors/src/ui/addedit_location.dart';
import 'package:deckinspectors/src/ui/section.dart';
import 'package:flutter/material.dart';

import '../models/location_model.dart';
import '../models/section_model.dart';
import 'image_widget.dart';

class LocationPage extends StatefulWidget {
  final String id;
  final String userFullName;
  const LocationPage(this.id, this.userFullName, {Key? key}) : super(key: key);
  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  void initState() {
    locationId = widget.id;
    userFullName = widget.userFullName;
    super.initState();
  }

  String userFullName = "";
  String locationId = "";
  late Location currentLocation;
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
              children: const [
                Text(
                  'Projects',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
                Text(
                  'Common Locations',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  width: 70,
                ),
              ]),
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
                if (data is LocationResponse) {
                  currentLocation = data.item as Location;
                  return SingleChildScrollView(
                      child: Column(
                    children: [
                      locationDetails(data.item as Location),
                      locationsWidget(context),
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
          future: locationsBloc.getLocation(locationId),
        ));
  }

  Widget locationDetails(Location currentLocation) {
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
                image: DecorationImage(
                    image: AssetImage('assets/images/heroimage.png'),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [BoxShadow(blurRadius: 1.0, color: Colors.blue)]),
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
                    InkWell(
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
          //           surfaceTintColor: Colors.red,
          //           shadowColor: Colors.red,
          //           elevation: 2),
          //       onPressed: () {
          //         print('Delete Location');
          //       },
          //       icon: const Icon(
          //         Icons.delete_outline,
          //         color: Colors.red,
          //       ),
          //       label: const Text(
          //         'Delete Location',
          //         style: TextStyle(color: Colors.red),
          //       )),
          // )
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
                    Align(
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
                              selectionColor: Colors.white,
                            ),
                            shadowColor: Colors.white,
                            backgroundColor: Colors.white,
                            elevation: 0,
                            autofocus: true,
                          )),
                    ),
                  ],
                ),
                currentLocation.sections == null
                    ? const Center(
                        child: Text(
                        'No locations, Add locations.',
                        style: TextStyle(fontSize: 16),
                      ))
                    : Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: currentLocation.sections!.length,
                            itemBuilder: (BuildContext context, int index) =>
                                horizontalScrollChildren(context, index)),
                      )
              ],
            )));
  }

  Widget horizontalScrollChildren(BuildContext context, int index) {
    String vreview = '';
    String visualReview =
        (currentLocation.sections?[index]!.visualreview as String);
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
    String assessmentActual =
        (currentLocation.sections?[index]!.conditionalassessment as String);
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
    return SizedBox(
      width: MediaQuery.of(context).size.width - 70,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 2, 8, 4),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            height: 180,
            decoration: const BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
                bottom: Radius.circular(00),
              ),
            ),
            child: networkImage(currentLocation.sections?[index]!.coverUrl),
          ),
          InkWell(
              onTap: () =>
                  {gotoDetails(currentLocation.sections?[index]!.id as String)},
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
                              currentLocation.sections?[index]!.name as String,
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
                                    currentLocation.sections?[index]!
                                                .visualsignsofleak ==
                                            true
                                        ? 'True'
                                        : 'False',
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
                                    currentLocation.sections?[index]!
                                                .furtherinvasivereviewrequired ==
                                            true
                                        ? 'True'
                                        : 'False',
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
                                    currentLocation.sections?[index]!.count
                                        .toString() as String,
                                    style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )),
                            ],
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                              side: BorderSide.none,
                              // the height is 50, the width is full
                              minimumSize: const Size.fromHeight(30),
                              backgroundColor: Colors.white,
                              shadowColor: Colors.blue,
                              elevation: 0),
                          onPressed: () {
                            print('clickd delete');
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          label: const Text('Delete Location',
                              style: TextStyle(color: Colors.red))),
                    ),
                  ])))
        ]),
      ),
    );
  }

  void addNewChild() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SectionPage("", currentLocation.id as String, userFullName)));
  }

  void gotoDetails(String sectionId) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SectionPage(
              sectionId, currentLocation.id as String, userFullName),
        ));
  }

  void addEditLocation(Location currentLocation) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AddEditLocationPage(currentLocation, userFullName)),
    );
  }
}
