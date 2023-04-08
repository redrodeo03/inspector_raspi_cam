import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/helpers/show_checkbox_picker.dart';
import '../models/exteriorelements.dart';
import '../models/section_model.dart';
import '../models/success_response.dart';
import '../bloc/section_bloc.dart';

class SectionPage extends StatefulWidget {
  final VisualSection currentVisualSection;
  final String userFullName;
  const SectionPage(this.currentVisualSection, this.userFullName, {Key? key})
      : super(key: key);
  //VisualSection currentSection;
  @override
  State<SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
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
                  'Locations',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
                const Text(
                  'Details',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.normal),
                ),
                InkWell(
                    onTap: () {
                      save(context);
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              sectionForm(context),
            ],
          ),
        ));
  }

  String userFullName = "";
  late VisualSection currentVisualSection;
  bool isNewSection = true;
  @override
  void initState() {
    currentVisualSection = widget.currentVisualSection;
    userFullName = widget.userFullName;
    if (currentVisualSection.id != null) {
    _nameController.text = currentVisualSection.name as String;
    _concernsController.text =
        currentVisualSection.additionalconsiderations as String;
        isNewSection=false;
    }
    super.initState();
  }

  final TextEditingController _nameController = TextEditingController(text: '');
  final TextEditingController _concernsController =
      TextEditingController(text: '');
  save(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saving Location...')),
      );
      currentVisualSection.name = _nameController.text;
      currentVisualSection.additionalconsiderations = _concernsController.text;
      currentVisualSection.exteriorelements =
          selectedExteriorelements.map((element) => element.name).toList();
      currentVisualSection.waterproofingelements =
          selectedWaterproofingElements.map((element) => element.name).toList();
      currentVisualSection.visualreview = _review!.name;
      currentVisualSection.conditionalassessment = _assessment!.name;
      currentVisualSection.eee = _eee!.name;
      currentVisualSection.lbc = _lbc!.name;
      currentVisualSection.awe = _awe!.name;
      currentVisualSection.furtherinvasivereviewrequired =
          invasiveReviewRequired;
      currentVisualSection.visualsignsofleak = hasSignsOfLeak;

      if (isNewSection) {
        currentVisualSection.createdby = userFullName;
      } else {
        currentVisualSection.lasteditedby = userFullName;
      }

      //TODO : Set image URL

      Object result;
      if (currentVisualSection.id==null) {
        result = await sectionsBloc.addSection(currentVisualSection);
      } else {
        result = await sectionsBloc.updateSection(currentVisualSection);
      }

      if (!mounted) {
        return;
      }
      if (result is SuccessResponse) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location saved successfully.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save the location.')),
        );
      }

      //Navigator.pop(context);
    }
  }

  final _formKey = GlobalKey<FormState>();

  bool hasSignsOfLeak = false;
  bool invasiveReviewRequired = false;

  Widget sectionForm(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
     child:Form(
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
                  const Text('Unit photos'),
                  InkWell(
                      onTap: () {},
                      child: const Chip(
                        avatar: Icon(
                          Icons.add_a_photo_outlined,
                          color: Colors.black,
                        ),
                        labelPadding: EdgeInsets.all(2),
                        label: Text(
                          'Add Photos',
                          style: TextStyle(color: Colors.black),
                        ),
                        shadowColor: Colors.blue,
                        backgroundColor: Colors.blue,
                        elevation: 10,
                        autofocus: true,
                      )),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 3.5,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) => Container(
                          margin: const EdgeInsets.fromLTRB(2, 8, 8, 8),
                          height: 180,
                          width: 300,
                          decoration: const BoxDecoration(
                              color: Colors.orange,
                              image: DecorationImage(
                                  image: AssetImage('assets/images/icon.png'),
                                  fit: BoxFit.cover),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              boxShadow: [
                                BoxShadow(blurRadius: 1.0, color: Colors.blue)
                              ]),
                        )),
              ),
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
                              color: Colors.blue, fontWeight: FontWeight.w500),
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
                        onChanged: (value) =>
                            setState(() => selectedExteriorelements = value),
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
//                         onSelectionChanged: (value) {
//                           if(value.any((item) => item.code == '5'))
//                           {
//                             selectedWaterproofingElements = waterproofingElements;
//                           }
//                           else{
// selectedWaterproofingElements.remove(value)
//                           }
//                         },
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
                              color: Colors.blue, fontWeight: FontWeight.w500),
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
                'Life expectancy assciated waterproofing elements (AWE)',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              radioWidget('AWE', 4),
            ],
          ),
        ))
        );
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

  VisualReview? _review = VisualReview.good;
  ConditionalAssessment? _assessment = ConditionalAssessment.pass;
  ExpectancyYears? _eee = ExpectancyYears.four;
  ExpectancyYears? _lbc = ExpectancyYears.four;
  ExpectancyYears? _awe = ExpectancyYears.four;

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
}

enum VisualReview { good, fair, bad }

enum ConditionalAssessment { pass, fail, futureinspection }

enum ExpectancyYears { one, four, seven, sevenplus }
