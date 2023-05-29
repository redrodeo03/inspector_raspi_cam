import 'package:deckinspectors/src/bloc/images_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/helpers/show_checkbox_picker.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';
import '../models/exteriorelements.dart';
import '../models/realm/realm_schemas.dart';

import '../models/success_response.dart';

import '../resources/realm/realm_services.dart';
import 'capturemultipic.dart';
import 'image_widget.dart';
import 'package:image_picker/image_picker.dart';

class SectionPage extends StatefulWidget {
  final ObjectId sectionId;
  final String userFullName;
  final String parentType;
  final ObjectId parentId;
  final String parentName;
  final bool isNewSection;
  const SectionPage(this.sectionId, this.parentId, this.userFullName,
      this.parentType, this.parentName, this.isNewSection,
      {Key? key})
      : super(key: key);
  //VisualSection currentSection;
  @override
  State<SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  late RealmProjectServices realmServices;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          tooltip: 'Save and Create New',
          elevation: 8,
          onPressed: () {
            saveAndNext(context, realmServices);
          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.save)),
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Details',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.normal),
              ),
              InkWell(
                  onTap: () {
                    save(context, realmServices);
                  },
                  child: const Chip(
                    avatar: Icon(
                      Icons.save_outlined,
                      color: Colors.black,
                    ),
                    labelPadding: EdgeInsets.all(2),
                    label: Text(
                      'Save Location',
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
      body: isRunning
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  sectionForm(context),
                ],
              ),
            ),
    );
  }

  bool isRunning = false;
  String userFullName = "";
  String parentType = "";
  late LocalVisualSection currentVisualSection;
  late Future sectionResponse;
  late bool isNewSection;
  late String prevPageName;
  void fetchData() {
    isRunning = true;
    currentVisualSection =
        realmServices.getVisualSection(widget.sectionId) as LocalVisualSection;
    setInitialValues();
    isRunning = false;
  }

  LocalVisualSection getNewVisualSection() {
    return LocalVisualSection(
      ObjectId(),
      "",
      "",
      "",
      widget.parentId,
      visualsignsofleak: false,
      createdby: userFullName,
      furtherinvasivereviewrequired: false,
    );
  }

  @override
  void initState() {
    realmServices = Provider.of<RealmProjectServices>(context, listen: false);
    isNewSection = widget.isNewSection;
    if (isNewSection) {
      currentVisualSection = getNewVisualSection();
      capturedImages = [];
    } else {
      capturedImages.clear();
      fetchData();
    }
    userFullName = widget.userFullName;
    parentType = widget.parentType;
    prevPageName = widget.parentName;
    super.initState();
  }

  void setInitialValues() {
    //Set all values before returning the widget.
    _nameController.text = currentVisualSection.name as String;
    _concernsController.text =
        currentVisualSection.additionalconsiderations as String;
    selectedExteriorelements = exteriorElements
        .where(
            (item) => currentVisualSection.exteriorelements.contains(item.name))
        .toList();

    selectedWaterproofingElements = waterproofingElements
        .where((item) =>
            currentVisualSection.waterproofingelements.contains(item.name))
        .toList();

    _review = VisualReview.values
        .firstWhere((e) => e.name == currentVisualSection.visualreview);
    _assessment = ConditionalAssessment.values.firstWhere(
        (e) => e.name == currentVisualSection.conditionalassessment);

    _eee = ExpectancyYears.values
        .firstWhere((e) => e.name == currentVisualSection.eee);
    _lbc = ExpectancyYears.values
        .firstWhere((e) => e.name == currentVisualSection.lbc);
    _awe = ExpectancyYears.values
        .firstWhere((e) => e.name == currentVisualSection.awe);

    invasiveReviewRequired = currentVisualSection.furtherinvasivereviewrequired;
    hasSignsOfLeak = currentVisualSection.visualsignsofleak;
    if (currentVisualSection.images.isNotEmpty) {
      capturedImages.addAll(currentVisualSection.images);
    }
  }

  final TextEditingController _nameController = TextEditingController(text: '');
  final TextEditingController _concernsController =
      TextEditingController(text: '');
  save(BuildContext context, RealmProjectServices realmServices) async {
    if (_formKey.currentState!.validate()) {
      //check if everything is filled.
      //TODO

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saving Location...')),
      );

      var saveResult = realmServices.addupdateVisualSection(
          currentVisualSection,
          _nameController.text,
          _concernsController.text,
          selectedExteriorelements,
          selectedWaterproofingElements,
          _review,
          _assessment,
          _eee,
          _lbc,
          _awe,
          invasiveReviewRequired,
          hasSignsOfLeak,
          isNewSection,
          userFullName);

      if (!mounted) {
        return;
      }
      if (saveResult) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location saved successfully.')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save the location.')),
        );
      }
      if (saveResult) {
        if (capturedImages.isNotEmpty) {
          var imagesToUpload =
              capturedImages.where((e) => !e.startsWith('http')).toList();
          if (imagesToUpload.isEmpty) {
            return;
          }
          imagesBloc
              .uploadMultipleImages(
                  imagesToUpload,
                  currentVisualSection.name as String,
                  userFullName,
                  currentVisualSection.id.toString(),
                  parentType,
                  'section')
              .then((value) {
            List<String> urls = [];
            for (var element in value) {
              if (element is ImageResponse) {
                urls.add(element.url as String);
              }
            }
            realmServices.addImagesUrl(currentVisualSection, urls);
          });
        }
      }
    }
  }

  final _formKey = GlobalKey<FormState>();
  //List<XFile> capturedImages = [];
  List<String> capturedImages = [];
  bool hasSignsOfLeak = false;
  bool invasiveReviewRequired = false;

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.blue,
          ),
          const SizedBox(
            width: 15,
          ),
          Text(title),
        ],
      ),
    );
  }

  _onMenuItemSelected(int value) async {
    if (value == 1) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CameraScreen()),
      ).then((value) {
        setState(() {
          if (value != null) {
            capturedImages.addAll(value);
            if (value.isNotEmpty) {
              setState(() {
                // currentVisualSection.realm.write(() {
                //   currentVisualSection.images
                //       .addAll(value.map((e) => e.path).toList());
                // });
              });
            }
            // for (var element in capturedImages) {
            //   //currentVisualSection.images ??= RealmList<String>[];
            //   currentVisualSection.images.add(element);
            // }
          }
        });
      });
    } else {
      //Code toopen gallery
      final ImagePicker picker = ImagePicker();
      //todo
      var imageFiles = await picker.pickMultiImage(imageQuality: 100);
      if (imageFiles.isNotEmpty) {
        setState(() {
          capturedImages.addAll(imageFiles.map((e) => e.path).toList());
          // currentVisualSection.realm.write(() {
          //   currentVisualSection.images
          //       .addAll(imageFiles.map((e) => e.path).toList());
          // });
        });
      }
    }
  }

  Widget sectionForm(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Location name'),
                  const SizedBox(
                    height: 8,
                  ),
                  inputWidgetwithValidation('Location Name',
                      'Please enter location name', 1, _nameController),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Unit photos(${capturedImages.length})'),
                      PopupMenuButton(
                        child: const Chip(
                          avatar: Icon(
                            Icons.add_a_photo_outlined,
                            color: Colors.blue,
                          ),
                          labelPadding: EdgeInsets.all(2),
                          label: Text(
                            'Add Photos',
                            style: TextStyle(color: Colors.blue, fontSize: 15),
                          ),
                          shadowColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          elevation: 10,
                          autofocus: true,
                        ),
                        onSelected: (value) {
                          _onMenuItemSelected(value as int);
                        },
                        itemBuilder: (ctx) => [
                          _buildPopupMenuItem(
                              'Camera', Icons.camera_alt_outlined, 1),
                          _buildPopupMenuItem(
                              'Gallery', Icons.browse_gallery_outlined, 2),
                        ],
                      ),
                    ],
                  ),
                  capturedImages.isEmpty
                      ? const SizedBox(
                          height: 180,
                          child: Center(
                              child: Text(
                            'Add location Images',
                            style: TextStyle(fontSize: 16),
                          )))
                      : SizedBox(
                          height: MediaQuery.of(context).size.height / 3.5,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: capturedImages.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(2, 8, 8, 8),
                                    height: 180,
                                    width: 300,
                                    decoration: const BoxDecoration(
                                        color: Colors.orange,
                                        // image: DecorationImage(
                                        //     image:
                                        //         AssetImage('assets/images/icon.png'),
                                        //     fit: BoxFit.cover),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 1.0,
                                              color: Colors.blue)
                                        ]),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child:
                                          networkImage(capturedImages[index]),
                                    )),
                          )),
                  const SizedBox(
                    height: 4,
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 222, 213, 213),
                    height: 20,
                    thickness: 1,
                    indent: 2,
                    endIndent: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Exterior Elements',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      InkWell(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${selectedExteriorelements.length} Selected',
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 14,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        onTap: () {
                          showMaterialCheckboxPicker<ElementModel>(
                            context: context,
                            title: 'Exterior Elements',
                            items: exteriorElements,
                            selectedItems: selectedExteriorelements,
                            onChanged: (value) => setState(
                                () => selectedExteriorelements = value),
                          );
                        },
                      ),
                    ],
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 222, 213, 213),
                    height: 15,
                    thickness: 1,
                    indent: 2,
                    endIndent: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Waterproofing Elements',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      InkWell(
                        onTap: () {
                          showMaterialCheckboxPicker<ElementModel>(
                            context: context,
                            title: 'Waterproofing Elements',
                            items: waterproofingElements,
                            selectedItems: selectedWaterproofingElements,
                            onChanged: (value) => setState(
                                () => selectedWaterproofingElements = value),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${selectedWaterproofingElements.length} Selected',
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 14,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 222, 213, 213),
                    height: 20,
                    thickness: 1,
                    indent: 2,
                    endIndent: 2,
                  ),
                  const Text(
                    'Visual Review',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  radioWidget('visual', 3),
                  const Divider(
                    color: Color.fromARGB(255, 222, 213, 213),
                    height: 0,
                    thickness: 1,
                    indent: 2,
                    endIndent: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Any visual signs of leaks',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Switch(
                        onChanged: (value) {
                          toggleSwitch(value);
                        },
                        value: hasSignsOfLeak,
                      ),
                    ],
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 222, 213, 213),
                    height: 0,
                    thickness: 1,
                    indent: 2,
                    endIndent: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Further invasive review required',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Switch(
                        onChanged: (value) {
                          toggleSwitchInvasive(value);
                        },
                        value: invasiveReviewRequired,
                      ),
                    ],
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 222, 213, 213),
                    height: 15,
                    thickness: 1,
                    indent: 2,
                    endIndent: 2,
                  ),
                  const Text(
                    'Conditional Assessment',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  radioWidget('conditional', 3),
                  const Divider(
                    color: Color.fromARGB(255, 222, 213, 213),
                    height: 15,
                    thickness: 1,
                    indent: 2,
                    endIndent: 2,
                  ),
                  const Text('Additional considerations or concerns'),
                  const SizedBox(
                    height: 8,
                  ),
                  inputWidgetwithValidation('Additonal Considerations',
                      'Please enter details', 5, _concernsController),
                  const SizedBox(
                    height: 4,
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 222, 213, 213),
                    height: 15,
                    thickness: 1,
                    indent: 2,
                    endIndent: 2,
                  ),
                  const Text(
                    'Life expectancy exterior elevated elements (EEE)',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  radioWidget('EEE', 4),
                  const Divider(
                    color: Color.fromARGB(255, 222, 213, 213),
                    height: 15,
                    thickness: 1,
                    indent: 2,
                    endIndent: 2,
                  ),
                  const Text(
                    'Life expectancy load bearing components (LBC)',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  radioWidget('LBC', 4),
                  const Divider(
                    color: Color.fromARGB(255, 222, 213, 213),
                    height: 15,
                    thickness: 1,
                    indent: 2,
                    endIndent: 2,
                  ),
                  const Text(
                    'Life expectancy associated waterproofing elements (AWE)',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  radioWidget('AWE', 4),
                  isNewSection
                      ? Container()
                      : Padding(
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
                                deleteSection(context, currentVisualSection);
                              },
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              label: const Text('Delete Location',
                                  style: TextStyle(color: Colors.red))),
                        )
                ],
              ),
            )));
  }

  void toggleSwitch(bool value) {
    if (hasSignsOfLeak == false) {
      setState(() {
        hasSignsOfLeak = true;
      });
    } else {
      setState(() {
        hasSignsOfLeak = false;
      });
    }
  }

  void toggleSwitchInvasive(bool value) {
    if (invasiveReviewRequired == false) {
      setState(() {
        invasiveReviewRequired = true;
      });
    } else {
      setState(() {
        invasiveReviewRequired = false;
      });
    }
  }

  Widget inputWidgetwithValidation(String hint, String message, int lines,
      TextEditingController controller) {
    return TextFormField(
        controller: controller,
        // The validator receives the text that the user has entered.
        validator: (value) {
          if (value == null || value.isEmpty) {
            return message;
          }
          return null;
        },
        maxLines: lines,
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.only(left: 5, top: 2.0, bottom: 2.0),
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 13.0,
              color: Color(0xFFABB3BB),
              height: 1.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            )));
  }

  static const List<ElementModel> exteriorElements = <ElementModel>[
    //ElementModel('SELECT ALL', '10');
    ElementModel('Decks', '1'),
    ElementModel('Porches/Entry', '2'),
    ElementModel('Stairs', '3'),
    ElementModel('Stairs Landing', '4'),
    ElementModel('Walkways', '5'),
    ElementModel('Railings', '6'),
    ElementModel('Integrations', '7'),
    ElementModel('Door Threshold', '8'),
    ElementModel('Stucco Interface', '9'),
  ];
  List<ElementModel> selectedExteriorelements = [];

  static const List<ElementModel> waterproofingElements = <ElementModel>[
    //ElementModel('SELECT ALL', '5'),
    ElementModel('Flashings', '1'),
    ElementModel('Waterproofing', '2'),
    ElementModel('Coatings', '3'),
    ElementModel('Sealants', '4'),
  ];
  List<ElementModel> selectedWaterproofingElements = [];

  //Radios

  Widget getListTile(String radioType, int position) {
    if (radioType == 'visual') {
      switch (position) {
        case 1:
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text('Good'),
            leading: Radio<VisualReview>(
              value: VisualReview.good,
              groupValue: _review,
              onChanged: (VisualReview? value) {
                setState(() {
                  _review = value;
                });
                debugPrint(_review!.name);
              },
            ),
          );
        //break;
        case 2:
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text('Fair'),
            leading: Radio<VisualReview>(
              value: VisualReview.fair,
              groupValue: _review,
              onChanged: (VisualReview? value) {
                setState(() {
                  _review = value;
                });
                debugPrint(_review!.name);
              },
            ),
          );
        case 3:
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text('Bad'),
            leading: Radio<VisualReview>(
              value: VisualReview.bad,
              groupValue: _review,
              onChanged: (VisualReview? value) {
                setState(() {
                  _review = value;
                });
                debugPrint(_review!.name);
              },
            ),
          );
      }
    } else if (radioType == "EEE") {
      switch (position) {
        case 1:
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text('0-1 Years'),
            leading: Radio<ExpectancyYears>(
              value: ExpectancyYears.one,
              groupValue: _eee,
              onChanged: (ExpectancyYears? value) {
                setState(() {
                  _eee = value;
                });
                debugPrint(_review!.name);
              },
            ),
          );
        //break;
        case 2:
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text('1-4 Years'),
            leading: Radio<ExpectancyYears>(
              value: ExpectancyYears.four,
              groupValue: _eee,
              onChanged: (ExpectancyYears? value) {
                setState(() {
                  _eee = value;
                });
              },
            ),
          );
        case 3:
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text('4-7 Years'),
            leading: Radio<ExpectancyYears>(
              value: ExpectancyYears.seven,
              groupValue: _eee,
              onChanged: (ExpectancyYears? value) {
                setState(() {
                  _eee = value;
                });
              },
            ),
          );
        case 4:
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text('7+ Years'),
            leading: Radio<ExpectancyYears>(
              value: ExpectancyYears.sevenplus,
              groupValue: _eee,
              onChanged: (ExpectancyYears? value) {
                setState(() {
                  _eee = value;
                });
              },
            ),
          );
      }
    } else if (radioType == "LBC") {
      switch (position) {
        case 1:
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text('0-1 Years'),
            leading: Radio<ExpectancyYears>(
              value: ExpectancyYears.one,
              groupValue: _lbc,
              onChanged: (ExpectancyYears? value) {
                setState(() {
                  _lbc = value;
                });
              },
            ),
          );
        //break;
        case 2:
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text('1-4 Years'),
            leading: Radio<ExpectancyYears>(
              value: ExpectancyYears.four,
              groupValue: _lbc,
              onChanged: (ExpectancyYears? value) {
                setState(() {
                  _lbc = value;
                });
              },
            ),
          );
        case 3:
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text('4-7 Years'),
            leading: Radio<ExpectancyYears>(
              value: ExpectancyYears.seven,
              groupValue: _lbc,
              onChanged: (ExpectancyYears? value) {
                setState(() {
                  _lbc = value;
                });
              },
            ),
          );
        case 4:
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text('7+ Years'),
            leading: Radio<ExpectancyYears>(
              value: ExpectancyYears.sevenplus,
              groupValue: _lbc,
              onChanged: (ExpectancyYears? value) {
                setState(() {
                  _lbc = value;
                });
              },
            ),
          );
      }
    } else if (radioType == "AWE") {
      switch (position) {
        case 1:
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text('0-1 Years'),
            leading: Radio<ExpectancyYears>(
              value: ExpectancyYears.one,
              groupValue: _awe,
              onChanged: (ExpectancyYears? value) {
                setState(() {
                  _awe = value;
                });
              },
            ),
          );
        //break;
        case 2:
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text('1-4 Years'),
            leading: Radio<ExpectancyYears>(
              value: ExpectancyYears.four,
              groupValue: _awe,
              onChanged: (ExpectancyYears? value) {
                setState(() {
                  _awe = value;
                });
              },
            ),
          );
        case 3:
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text('4-7 Years'),
            leading: Radio<ExpectancyYears>(
              value: ExpectancyYears.seven,
              groupValue: _awe,
              onChanged: (ExpectancyYears? value) {
                setState(() {
                  _awe = value;
                });
              },
            ),
          );
        case 4:
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text('7+ Years'),
            leading: Radio<ExpectancyYears>(
              value: ExpectancyYears.sevenplus,
              groupValue: _awe,
              onChanged: (ExpectancyYears? value) {
                setState(() {
                  _awe = value;
                });
              },
            ),
          );
      }
    } else {
      switch (position) {
        case 1:
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text('Pass'),
            leading: Radio<ConditionalAssessment>(
              value: ConditionalAssessment.pass,
              groupValue: _assessment,
              onChanged: (ConditionalAssessment? value) {
                setState(() {
                  _assessment = value;
                });
                debugPrint(_review!.name);
              },
            ),
          );
        //break;
        case 2:
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text('Fail'),
            leading: Radio<ConditionalAssessment>(
              value: ConditionalAssessment.fail,
              groupValue: _assessment,
              onChanged: (ConditionalAssessment? value) {
                setState(() {
                  _assessment = value;
                });
              },
            ),
          );
        case 3:
          return ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: const Text('Future Inspection'),
            leading: Radio<ConditionalAssessment>(
              value: ConditionalAssessment.futureinspection,
              groupValue: _assessment,
              onChanged: (ConditionalAssessment? value) {
                setState(() {
                  _assessment = value;
                });
              },
            ),
          );
      }
    }
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: const Text('Fair'),
      leading: Radio<VisualReview>(
        value: VisualReview.fair,
        groupValue: _review,
        onChanged: (VisualReview? value) {
          setState(() {
            _review = value;
          });
          debugPrint(_review!.name);
        },
      ),
    );
  }

  VisualReview? _review; //= VisualReview.good;
  ConditionalAssessment? _assessment; //= ConditionalAssessment.pass;
  ExpectancyYears? _eee; //= ExpectancyYears.four;
  ExpectancyYears? _lbc; // = ExpectancyYears.four;
  ExpectancyYears? _awe; //= ExpectancyYears.four;

  Widget radioWidget(String radioType, int radioCount) {
    if (radioCount == 4) {
      return Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          children: <Widget>[
            Expanded(child: getListTile(radioType, 1)),
            Expanded(child: getListTile(radioType, 2)),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(child: getListTile(radioType, 3)),
            Expanded(child: getListTile(radioType, 4)),
          ],
        )
      ]);
    }
    return Row(
      children: <Widget>[
        Expanded(flex: 2, child: getListTile(radioType, 1)),
        Expanded(flex: 2, child: getListTile(radioType, 2)),
        Expanded(flex: 3, child: getListTile(radioType, 3))
      ],
    );
  }

  void deleteSection(
      BuildContext context, LocalVisualSection currentVisualSection) {
    var locationame = currentVisualSection.name;
    var result = realmServices.deleteVisualSection(currentVisualSection);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Deleting $locationame')),
    );

    if (result == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${currentVisualSection.name} deleted successfully.')));
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete the $locationame')),
      );
    }
  }

  void saveAndNext(BuildContext context, RealmProjectServices realmServices) {
    save(context, realmServices);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SectionPage(ObjectId(), widget.parentId,
                userFullName, widget.parentType, widget.parentName, true)));
  }
}

enum VisualReview { good, fair, bad }

enum ConditionalAssessment { pass, fail, futureinspection }

enum ExpectancyYears { one, four, seven, sevenplus }
