import 'dart:io';

import 'package:deckinspectors/src/ui/cachedimage_widget.dart';
import 'package:deckinspectors/src/ui/subproject.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../bloc/images_bloc.dart';
import '../models/realm/realm_schemas.dart';
import '../models/success_response.dart';
import '../resources/realm/realm_services.dart';
import 'breadcrumb_navigation.dart';
import 'capture_image.dart';

class AddEditSubProjectPage extends StatefulWidget {
  final LocalSubProject currentBuilding;
  final String fullUserName;
  final String prevPageName;
  final bool isNewBuilding;
  const AddEditSubProjectPage(this.currentBuilding, this.isNewBuilding,
      this.fullUserName, this.prevPageName,
      {Key? key})
      : super(key: key);
  static MaterialPageRoute getRoute(LocalSubProject subProject, bool isNew,
          String userName, String prevPageName) =>
      MaterialPageRoute(
          settings:
              RouteSettings(name: isNew ? 'Add Building' : 'Edit Building'),
          builder: (context) =>
              AddEditSubProjectPage(subProject, isNew, userName, prevPageName));
  @override
  State<AddEditSubProjectPage> createState() => _AddEditSubProjectPageState();
}

class _AddEditSubProjectPageState extends State<AddEditSubProjectPage> {
  late String fullUserName;
  final TextEditingController _nameController = TextEditingController(text: '');
  bool showAssetPic = true;
  final TextEditingController _descriptionController =
      TextEditingController(text: '');
  @override
  void initState() {
    currentBuilding = widget.currentBuilding;
    fullUserName = widget.fullUserName;
    pageTitle = 'Add Building';
    name = "Building";
    super.initState();
    isNewBuilding = widget.isNewBuilding;
    if (!widget.isNewBuilding) {
      pageTitle = 'Edit Building';
      showAssetPic = false;
      _nameController.text = currentBuilding.name as String;
      _descriptionController.text = currentBuilding.description as String;
      //currentBuilding.url ??= "/assets/images/icon.png";
    }
    if (currentBuilding.url != null) {
      imageURL = currentBuilding.url as String;
    }
    prevPagename = widget.prevPageName;
  }

  String pageTitle = 'Add';
  String prevPagename = 'Project';
  late bool isNewBuilding;
  late LocalSubProject currentBuilding;
  String name = "";
  final _formKey = GlobalKey<FormState>();
  String imageURL = 'assets/images/icon.png';
  save(BuildContext context, RealmProjectServices realmServices) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saving Building...')),
      );

      try {
        bool result = realmServices.addupdateSubProject(
            currentBuilding,
            _nameController.text,
            _descriptionController.text,
            isNewBuilding,
            fullUserName);

        if (!mounted) {
          return;
        }
        if (result) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Building saved successfully.')));

          if (isNewBuilding) {
            Navigator.pushReplacement(
                context,
                SubProjectDetailsPage.getRoute(
                    currentBuilding.id, prevPagename, fullUserName));
          } else {
            Navigator.pop(context);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save the building.')),
          );
        }
        if (currentBuilding.url == null) {
          return;
        }

        if (imageURL != currentBuilding.url) {
          var result = await imagesBloc.uploadImage(
              imageURL,
              currentBuilding.name as String,
              fullUserName,
              currentBuilding.id.toString(),
              'project',
              'building');

          if (result is ImageResponse) {
            realmServices.updateSubProjectUrl(
                currentBuilding, result.url as String);
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to save the building.${e.toString()}')),
        );
      }
    }
  }

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
                        'Save $name',
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
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: BreadCrumbNavigator(),
        ),
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
                      Text(name),
                      const SizedBox(
                        height: 8,
                      ),
                      inputWidgetwithValidation(
                          '$name name', 'Please enter $name name'),
                      const SizedBox(
                        height: 16,
                      ),
                      const Text('Description'),
                      const SizedBox(
                        height: 8,
                      ),
                      inputWidgetNoValidation('$name Description', 3),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                          height: 220,
                          child: Card(
                            borderOnForeground: false,
                            elevation: 8,
                            child: GestureDetector(
                                onTap: () async {
                                  showAssetPic = false;
                                  //add logic to open camera.
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
                                          ? currentBuilding.url == ""
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
                      const SizedBox(
                        height: 20,
                      ),
                      if (!isNewBuilding)
                        OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                                side: BorderSide.none,
                                // the height is 50, the width is full
                                minimumSize: const Size.fromHeight(40),
                                backgroundColor: Colors.white,
                                shadowColor: Colors.blue,
                                elevation: 0),
                            onPressed: () {
                              deleteSubProject(context, realmServices);
                            },
                            icon: const Icon(
                              Icons.delete_outline_outlined,
                              color: Colors.redAccent,
                            ),
                            label: const Text(
                              'Delete Building',
                              style: TextStyle(color: Colors.red),
                            )),
                      const SizedBox(
                        height: 40,
                      ),
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

  void deleteSubProject(
      BuildContext context, RealmProjectServices realmServices) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Deleting Building...')),
    );

    var result = realmServices.deleteSubProject(currentBuilding);
    if (result == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Building deleted successfully.')));
      Navigator.of(context)
        ..pop()
        ..pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete the ${currentBuilding.type}')),
      );
    }
  }
}
