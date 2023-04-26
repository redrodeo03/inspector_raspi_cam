import 'dart:io';

import 'package:deckinspectors/src/bloc/subproject_bloc.dart';
import 'package:deckinspectors/src/models/subproject_model.dart';
import 'package:flutter/material.dart';

import '../bloc/images_bloc.dart';
import '../models/success_response.dart';
import 'capture_image.dart';
import 'image_widget.dart';

class AddEditSubProjectPage extends StatefulWidget {
  final SubProject currentBuilding;
  final String fullUserName;
  const AddEditSubProjectPage(this.currentBuilding, this.fullUserName,
      {Key? key})
      : super(key: key);

  @override
  State<AddEditSubProjectPage> createState() => _AddEditSubProjectPageState();
}

class _AddEditSubProjectPageState extends State<AddEditSubProjectPage> {
  late String fullUserName;
  final TextEditingController _nameController = TextEditingController(text: '');

  final TextEditingController _descriptionController =
      TextEditingController(text: '');
  @override
  void initState() {
    currentBuilding = widget.currentBuilding;
    fullUserName = widget.fullUserName;
    pageTitle = 'Add Building';
    name = "Building";
    super.initState();
    if (currentBuilding.id != null) {
      pageTitle = 'Edit Building';
      prevPagename = 'Building';
      isNewLocation = false;
      _nameController.text = currentBuilding.name as String;
      _descriptionController.text = currentBuilding.description as String;
      //currentBuilding.url ??= "/assets/images/icon.png";
      if (currentBuilding.url != null) {
        imageURL = currentBuilding.url as String;
      }
    }
  }

  String pageTitle = 'Add';
  String prevPagename = 'Project';
  bool isNewLocation = true;
  late SubProject currentBuilding;
  String name = "";
  final _formKey = GlobalKey<FormState>();
  String imageURL = 'assets/images/icon.png';
  save(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saving Building...')),
      );
      currentBuilding.name = _nameController.text;

      currentBuilding.description = _descriptionController.text;
      if (isNewLocation) {
        currentBuilding.createdby = fullUserName;
      } else {
        currentBuilding.lasteditedby = fullUserName;
      }

      try {
        Object result;
        if (currentBuilding.id == null) {
          result = await subProjectsBloc.addSubProject(currentBuilding);
          if (result is SuccessResponse) {
            currentBuilding.id = result.id;
          }
        } else {
          result = await subProjectsBloc.updateSubProject(currentBuilding);
        }
        dynamic uploadResult;
        if (imageURL != currentBuilding.url) {
          uploadResult = await imagesBloc.uploadImage(
              currentBuilding.url as String,
              currentBuilding.name as String,
              fullUserName,
              currentBuilding.id as String,
              'project',
              'building');
        }

        if (!mounted) {
          return;
        }
        if (result is SuccessResponse) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Building saved successfully.')));
          if (uploadResult is ImageResponse) {
            setState(() {
              currentBuilding.url = uploadResult.url;
            });
          }
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save the building.')),
          );
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
                      save(context);
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
                                  //add logic to open camera.
                                  var xfile = await captureImage(context);
                                  if (xfile != null) {
                                    setState(() {
                                      currentBuilding.url = xfile.path;
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
                                      child: isNewLocation
                                          ? currentBuilding.url == null
                                              ? networkImage(
                                                  currentBuilding.url)
                                              : Image.file(
                                                  File(currentBuilding.url
                                                      as String),
                                                  fit: BoxFit.fill,
                                                  width: double.infinity,
                                                  height: 250,
                                                )
                                          : networkImage(currentBuilding.url),
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
                        height: 30,
                      )
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
}
