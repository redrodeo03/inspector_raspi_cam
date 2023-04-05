import 'package:flutter/material.dart';

class SectionPage extends StatefulWidget {
  const SectionPage({Key? key}) : super(key: key);

  @override
  State<SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: const Color(0xFF3F3F3F),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Location Name',
                  style: TextStyle(color: Colors.blue),
                ),
                InkWell(
                    onTap: () {},
                    child: const Chip(
                      avatar: Icon(
                        Icons.save_outlined,
                        color: Color(0xFF3F3F3F),
                      ),
                      labelPadding: EdgeInsets.all(2),
                      label: Text(
                        'Save Location',
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
            children: const [
              SectionForm(),
            ],
          ),
        ));
  }
}

// Create a Form widget.
class SectionForm extends StatefulWidget {
  const SectionForm({super.key});

  @override
  SectionFormState createState() {
    return SectionFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class SectionFormState extends State<SectionForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  bool hasSignsOfLeak = false;
  bool invasiveReviewRequired = false;
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
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
              inputWidgetwithValidation(
                  'Location Name', 'Please enter location name', 1),
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
                          color: Colors.white,
                        ),
                        labelPadding: EdgeInsets.all(2),
                        label: Text(
                          'Add Photos',
                          style: TextStyle(color: Colors.white),
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
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '0 Selected',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        child: const Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 14,
                          color: Colors.blue,
                        ),
                        onTap: () {},
                      ),
                    ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Waterproofing Elements',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '0 Selected',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        child: const Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 14,
                          color: Colors.blue,
                        ),
                        onTap: () {},
                      ),
                    ],
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
                'Visual Review',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const RadioWidget('visual',3),
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
              const RadioWidget('conditional',3),
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
              inputWidgetwithValidation(
                  'Additonal Considerations', 'Please enter details', 5),
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
              const RadioWidget('EEE',4),
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
              const RadioWidget('LBC',4),
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
              const RadioWidget('AWE',4),
            ],
          ),
        ));
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

  Widget inputWidgetwithValidation(String hint, String message, int lines) {
    return TextFormField(

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
}

enum VisualReview { good, fair, bad }

enum ConditionalAssessment { pass, fail, futureinspection }

enum ExpectancyYears{ one,four,seven,sevenplus}

class RadioWidget extends StatefulWidget {
  final String radiotype;
  final int radioCount;
  const RadioWidget(this.radiotype,this.radioCount, {Key? key}) : super(key: key);

  @override
  State<RadioWidget> createState() => _RadioWidgetState();
}

class _RadioWidgetState extends State<RadioWidget> {
  @override
  void initState() {
    radioType = widget.radiotype;
    radioCount=widget.radioCount;
    super.initState();
  }

  String radioType = "";
int radioCount=3;
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
    } 
    else if(radioType=="EEE"){
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
    }
    else if(radioType=="LBC"){
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
    }
    else if(radioType=="AWE"){
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
    }
    else {
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

  @override
  Widget build(BuildContext context) {
if  (radioCount==4){
return Column(
  mainAxisSize: MainAxisSize.min,
  children: [
Row(
      children: <Widget>[
        Expanded(
          child: getListTile(radioType, 1)),
        Expanded(
          child:getListTile(radioType, 2)),
],),
Row(
      children: <Widget>[
        Expanded(
          child: getListTile(radioType, 3)),
        Expanded(
          child:getListTile(radioType, 4)),
        
      ],
    )]);
}
    return Row(
      children: <Widget>[
        Expanded(flex:2,
          child: getListTile(radioType, 1)),
        Expanded(flex: 2,
          child:getListTile(radioType, 2)),
        Expanded(
          flex: 3,
          child: getListTile(radioType, 3))
      ],
    );
  }
}
