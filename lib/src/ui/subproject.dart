import 'location.dart';
import 'package:flutter/material.dart';


class SubProjectDetailsPage extends StatefulWidget {
  const SubProjectDetailsPage({Key? key}) : super(key: key);
  @override
  State<SubProjectDetailsPage> createState() => _SubProjectDetailsPageState();
}

//Add New Project
class _SubProjectDetailsPageState extends State<SubProjectDetailsPage>
    with SingleTickerProviderStateMixin {
  late int selectedTabIndex=0;
//Tab Controls
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
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
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const AddEditSubProjectPage('Building')),
    // );
  }
void addNewChild(){
  setState(() {});
  if  (selectedTabIndex==0){
// Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const AddEditSubProjectPage('Location')),
//     );
//   }
//   else{
// Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const AddEditSubProjectPage('Building')),
//     );
//   }
 }
}
void gotoDetails(){
  if  (selectedTabIndex==0){
Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>const LocationPage('Location',"tets")),
    );
  }
  else{
// Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const SubProjectPage('Building')),
//     );
  }
}
  void gotoLocationDetails() {
    setState(() {});
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const AddEditProjectPage()),
    // );
  }

  void gotoSubProjectDetails() {
    setState(() {});
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const AddEditProjectPage()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leadingWidth: 25,
            backgroundColor: const Color(0xFF3F3F3F),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Buildings',
                  style: TextStyle(color: Colors.blue),
                ),
                
              ],
            )),
        body: SingleChildScrollView(
            child: Column(
          children: [
            buildingDetails(),
            subProjectChildrenTab(context),
// Expanded(child: projectChildrenTab())
          ],
        )));
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
                image: DecorationImage(
                    image: AssetImage('assets/images/icon.png'),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [BoxShadow(blurRadius: 1.0, color: Colors.blue)]),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 4, 8, 0),
              child: Text(
                'Building Name',
                maxLines: 2,
                style: TextStyle(
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
                    const Expanded(
                      child: Text(
                        maxLines: 2,
                        'Description of the project dfkdflssf sdfksdf asd akdsa asdjnajkd askdnakjsd',
                        style: TextStyle(
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
                            Icons.edit_document,
                            color: Color(0xFF3F3F3F),
                          ),
                          labelPadding: EdgeInsets.all(2),
                          label: Text(
                            'Edit Building ',
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
          ),          
          
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0.0),
            child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                    side: BorderSide.none,
                    // the height is 50, the width is full
                    minimumSize: const Size.fromHeight(30),
                    backgroundColor: Colors.white,
                    shadowColor: Colors.red,
                    elevation: 2),
                onPressed: () {
                  print('delete building');
                },
                icon: const Icon(Icons.delete_outlined, color: Colors.red,),
                label: const Text('Delete Building',style: TextStyle(color: Colors.red),)),
          )
        ],
      ),
    );
  }

  Widget subProjectChildrenTab(BuildContext context) {
    // return DefaultTabController(
    //   length: 2,
    //   child:
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: "Building Locations",
              height: 32,
            ),
            Tab(
              text: "Apartments",
              height: 32,
            ),
          ],
          labelColor: Colors.black,
        ),
        Container(
            height: MediaQuery.of(context).size.height / 2,
            child: TabBarView(
              controller: _tabController,
              children: [
              locationsWidget('Building Location'),
              locationsWidget('Apartment'),
            ])),
      ],
      // ),
    );
  }

  Widget locationsWidget(String type) {
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
                      color: Color(0xFF3F3F3F),
                    ),
                    labelPadding: const EdgeInsets.all(2),
                    label: Text(
                      'Add $type',
                      style: const TextStyle(color: Color(0xFF3F3F3F)),
                      selectionColor: Colors.white,
                    ),
                    shadowColor: Colors.blue,
                    backgroundColor: Colors.blue,
                    elevation: 10,
                    autofocus: true,
                  )),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) =>
                      horizontalScrollChildren(context)),
            )
          ],
        ));
  }

  //Todo create widget for locations
  Widget horizontalScrollChildren(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 140,
                width: 192,
                decoration: const BoxDecoration(
                    color: Colors.orange,
                    image: DecorationImage(
                        image: AssetImage('assets/images/icon.png'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    boxShadow: [
                      BoxShadow(blurRadius: 1.0, color: Colors.blue)
                    ]),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(4, 4, 4, 0),
                  child: Text(
                    'Child Name',
                    maxLines: 2,
                    style: TextStyle(
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
                      children: const [
                        Expanded(
                          child: Text(
                            maxLines: 2,
                            'Description of the project dfkdflssf sdfksdf asd akdsa asdjnajkd askdnakjsd',
                            style: TextStyle(
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
              Padding(
                  padding: const EdgeInsets.fromLTRB(4, 2, 16, 2),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Text(
                          maxLines: 1,
                          'Locations  Count:',
                          style:  TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          textAlign: TextAlign.left,
                          '2',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          selectionColor: Colors.white,
                        ),
                      ])),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 4, 0.0),
                child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        // the height is 50, the width is full
                        minimumSize: const Size.fromHeight(30),
                        backgroundColor: Colors.white,
                        shadowColor: Colors.blue,
                        elevation: 2),
                    onPressed: () {
                      gotoDetails();
                    },
                    icon: const Icon(Icons.view_carousel_outlined),
                    label: const Text('View Details')),
              ),
            ],
          ),
        ));
  }
 }
