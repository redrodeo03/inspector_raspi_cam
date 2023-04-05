import 'package:flutter/material.dart';

import '../models/location_model.dart';

class AddEditSubProjectPage extends StatefulWidget {
  final Location currentLocation;
 // final Object currentBuilding;
  const AddEditSubProjectPage(this.currentLocation, {Key? key}) : super(key: key);
  
  @override
  State<AddEditSubProjectPage> createState() => _AddEditSubProjectPageState();
}

class _AddEditSubProjectPageState extends State<AddEditSubProjectPage> {

final TextEditingController _nameController = TextEditingController(text: '');
  
  final TextEditingController _descriptionController =
      TextEditingController(text: '');
@override
  void initState() {
    name = widget.currentLocation.type as String;
    currentLocation = widget.currentLocation;
    pageTitle = 'Add $name';
    super.initState();
  }
late Location currentLocation;  
String name="";
String pageTitle = 'Add';

save (){
  Navigator.pop(context);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
            foregroundColor: Colors.blue,
             leadingWidth: 25,
             elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [              
              const Text(
                'Project',  
                style: TextStyle(color: Colors.blue,fontSize: 15),
              ),
               Text(
                  pageTitle,
                  style: const TextStyle(color: Colors.black,fontWeight: FontWeight.normal),
                ),
             InkWell(
                onTap:() {
                  save();
                },
                child: Chip(
                  avatar: const Icon(
                    Icons.save_outlined,
                    color: Colors.black,
                  ),
                  labelPadding:const EdgeInsets.all(2),
                  label: Text(
                    'Save $name',
                    style: const TextStyle(color: Colors.black),
                    selectionColor: Colors.white,
                  ),
                  shadowColor: Colors.blue,
                  backgroundColor: Colors.blue,
                  elevation: 10,
                  autofocus: true,
                )
                
              ),
            ],
          )),
      body: SingleChildScrollView(child: 
      Form(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: SizedBox(
          height: MediaQuery.of(context).size.height*.9,
          child:
        Column(          
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
            Expanded(
              flex: 1,              
              child: 
            inputWidgetNoValidation('Description', 3),),
            const SizedBox(
              height: 16,
            ),
           
            Expanded(
              flex: 3,
                child: Card(
              borderOnForeground: false,
              elevation: 8,
              child: GestureDetector(
                  onTap: () {
//add logic to open camera.
print('tapped on image');
                  },
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(                        
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
      ),)
    )
  
      ,)
    );
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

