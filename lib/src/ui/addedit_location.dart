import 'dart:io';
import 'package:deckinspectors/src/ui/cachedimage_widget.dart';
import 'package:deckinspectors/src/ui/location.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bloc/images_bloc.dart';
import '../models/realm/realm_schemas.dart';
import '../models/success_response.dart';
import '../resources/realm/realm_services.dart';
import 'capture_image.dart';

class AddEditLocationPage extends StatefulWidget {
  final LocalLocation currentLocation;
  final String fullUserName;
  final bool isNewLocation;
  final String prevPageName;
  // final Object currentBuilding;
  const AddEditLocationPage(this.currentLocation, this.isNewLocation,
      this.fullUserName, this.prevPageName,
      {Key? key})
      : super(key: key);

  @override
  State<AddEditLocationPage> createState() => _AddEditLocationPageState();

  static MaterialPageRoute getRoute(LocalLocation location, bool isNew,
          String userName, String prevPage) =>
      MaterialPageRoute(
          settings: const RouteSettings(name: 'Edit Location'),
          builder: (context) =>
              AddEditLocationPage(location, isNew, userName, prevPage));
}

class _AddEditLocationPageState extends State<AddEditLocationPage> {
  late String fullUserName;
  final TextEditingController _nameController = TextEditingController(text: '');

  final TextEditingController _descriptionController =
      TextEditingController(text: '');

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  bool showAssetPic = true;
  @override
  void initState() {
    currentLocation = widget.currentLocation;
    fullUserName = widget.fullUserName;

    super.initState();
    pageType = currentLocation.type == 'apartment' ? 'Apartment' : 'Location';
    if (!widget.isNewLocation) {
      pageTitle = 'Edit $pageType';
      isNewLocation = false;
      showAssetPic = false;
      _nameController.text = currentLocation.name as String;
      _descriptionController.text = currentLocation.description as String;
      //currentLocation.url ??= "/assets/images/icon.png";
    } else {
      pageTitle = 'Add $pageType';
    }
    if (currentLocation.url != null) {
      imageURL = currentLocation.url as String;
    }
    prevPagename = widget.prevPageName;
  }

  late LocalLocation currentLocation;

  String pageType = '';
  String pageTitle = 'Add';
  String prevPagename = 'Project';
  bool isNewLocation = true;
  final _formKey = GlobalKey<FormState>();
  String imageURL = 'assets/images/icon.png';

  save(BuildContext context, RealmProjectServices realmServices) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saving $pageType...')),
      );
      //location details
      String name, description, id, parenttype, type;
      name = _nameController.text;

      description = _descriptionController.text;
      try {
        var result = realmServices.addupdateLocation(
            currentLocation, name, description, fullUserName, isNewLocation);

        if (!mounted) {
          return;
        }
        if (result) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$pageType saved successfully.')));

          //Navigator.pop(context, currentLocation.url);
          if (isNewLocation) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LocationPage(
                        currentLocation.id,
                        currentLocation.parenttype as String,
                        pageType,
                        fullUserName)));
          } else {
            Navigator.pop(context);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to save the ${currentLocation.type}')),
          );
        }

        id = currentLocation.id.toString();

        parenttype = currentLocation.parenttype as String;
        type = currentLocation.type as String;
        if (currentLocation.url == null) {
          return;
        }
        if (imageURL != currentLocation.url) {
          var result = await imagesBloc.uploadImage(
              imageURL, name, fullUserName, id, parenttype, type);

          if (result is ImageResponse) {
            realmServices.updateLocationUrl(
                currentLocation, result.url as String);
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to save the ${currentLocation.type} ${e.toString()}')),
        );
      }
    }
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
                prevPagename,
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pageTitle,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                ),
                InkWell(
                    onTap: () {
                      save(context, realmServices);
                    },
                    child: Chip(
                      avatar: const Icon(
                        Icons.save_outlined,
                        color: Colors.black,
                      ),
                      labelPadding: const EdgeInsets.all(2),
                      label: Text(
                        'Save $pageType',
                        style: const TextStyle(color: Colors.black),
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
          child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * .9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pageType),
                      const SizedBox(
                        height: 8,
                      ),
                      inputWidgetwithValidation('$pageType name',
                          'Please enter ${currentLocation.type} name'),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text('Description'),
                      const SizedBox(
                        height: 8,
                      ),

                      inputWidgetNoValidation('Description', 3),

                      const SizedBox(
                        height: 16,
                      ),

                      SizedBox(
                          height: 220,
                          child: Card(
                            borderOnForeground: false,
                            elevation: 4,
                            child: GestureDetector(
                                onTap: () async {
                                  //add logic to open camera.
                                  showAssetPic = false;
                                  var xfile = await captureImage(context);
                                  if (xfile != null) {
                                    setState(() {
                                      imageURL = xfile.path;
                                    });
                                  }
                                },
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                          boxShadow: [
                                            BoxShadow(
                                                blurRadius: 1.0,
                                                color: Colors.blue)
                                          ]),
                                      child: showAssetPic
                                          ? currentLocation.url == ""
                                              ? Image.asset(
                                                  "assets/images/heroimage.png",
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
                                                  height: 250,
                                                )
                                              : Image.file(
                                                  File(imageURL),
                                                  fit: BoxFit.fill,
                                                  width: double.infinity,
                                                  height: 250,
                                                )
                                          : cachedNetworkImage(imageURL),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: const [
                                        Icon(Icons.camera_outlined,
                                            size: 40, color: Colors.black),
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Add Image',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          )),
                      if (!isNewLocation)
                        OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                                side: BorderSide.none,
                                // the height is 50, the width is full
                                minimumSize: const Size.fromHeight(40),
                                backgroundColor: Colors.white,
                                shadowColor: Colors.blue,
                                elevation: 0),
                            onPressed: () {
                              deleteLocation(context, realmServices);
                            },
                            icon: const Icon(
                              Icons.delete_outline_outlined,
                              color: Colors.redAccent,
                            ),
                            label: Text(
                              'Delete $pageType',
                              style: const TextStyle(color: Colors.red),
                            )),
                      const SizedBox(
                        height: 40,
                      )
                      // Padding(

                      //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                      //   child: ElevatedButton(
                      //     onPressed: () {
                      //       // Validate returns true if the form is valid, or false otherwise.
                      //       if (_formKey.currentState!.validate()) {
                      //         // If the form is valid, display a snackbar. In the real world,
                      //         // you'd often call a server or save the information in a database.
                      //         ScaffoldMessenger.of(context).showSnackBar(
                      //           const SnackBar(content: Text('Processing Data')),
                      //         );
                      //       }
                      //     },
                      //     child: const Text('Submit'),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              )),
        ));
  }

  Widget inputWidgetwithValidation(String hint, String message) {
    return TextFormField(
        controller: _nameController,
        // The validator receives the text that the user has entered.
        validator: (value) {
          if (value == null || value.isEmpty) {
            return message;
          }
          return null;
        },
        maxLines: 1,
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 14.0,
              color: Color(0xFFABB3BB),
              height: 1.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            )));
  }

  Widget inputWidgetNoValidation(String hint, int? lines) {
    return TextField(
        controller: _descriptionController,
        // The validator receives the text that the user has entered.
        maxLines: lines,
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 14.0,
              color: Color(0xFFABB3BB),
              height: 1.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            )));
  }

  void deleteLocation(
      BuildContext context, RealmProjectServices realmServices) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Deleting $pageType...')),
    );
    //id,type, name, parentId, parentType, isVisible
    // var result = await locationsBloc.deleteLocation(
    //     currentLocation.id as String,
    //     currentLocation.type,
    //     currentLocation.name as String,
    //     currentLocation.parentid as String,
    //     currentLocation.parenttype as String,
    //     false);

    // if (!mounted) {
    //   return;
    // }
    var result = realmServices.deleteLocation(currentLocation);
    if (result == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$pageType deleted successfully.')));
      Navigator.of(context)
        ..pop()
        ..pop(currentLocation);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete the ${currentLocation.type}')),
      );
    }
  }
}
