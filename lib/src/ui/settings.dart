import 'package:deckinspectors/src/app.dart';
import 'package:deckinspectors/src/bloc/settings_bloc.dart';
import 'package:deckinspectors/src/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resources/realm/realm_services.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ImageQuality selectedQuality;
  bool isLowQuality = false;
  bool isHighQuality = false;
  bool isMediumQuality = true;

  Future<void> _loadImageSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      var quality = prefs.getString('imagequality') ?? 'medium';
      var repQuality = prefs.getInt('reportimagequality') ?? 100;
      reportImageQuality =
          reportQulityList.firstWhere((element) => element == repQuality);
      var count = prefs.getInt('imageCount') ?? 4;
      imageCount = imageCountList.firstWhere((element) => element == count);

      var compName = prefs.getString('companyName') ?? 'DeckInspectors';
      companyName = list.firstWhere((element) => element == compName);
      var appSync = prefs.getString('appSync') ?? 'true';
      isSyncOn = appSync == 'true';
      appSettings.currentQuality = ImageQuality.values.byName(quality);
      switch (quality) {
        case 'medium':
          isHighQuality = false;
          isLowQuality = false;
          isMediumQuality = true;
          break;
        case 'high':
          isHighQuality = true;
          isLowQuality = false;
          isMediumQuality = false;
          break;
        case 'low':
          isHighQuality = false;
          isLowQuality = true;
          isMediumQuality = false;
          break;

        default:
      }
    });

    ///var dayInString = describeEnum(Day.monday);
  }

  Future<void> savereportSettings() async {
    appSettings.companyName = companyName;
    appSettings.imageinRowCount = imageCount;
    appSettings.reportImageQuality = reportImageQuality;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reportimagequality', reportImageQuality);
    await prefs.setString('companyName', companyName);
    await prefs.setInt('imageCount', imageCount);
  }

  Future<void> _applyImageSettings(String quality) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      appSettings.currentQuality = ImageQuality.values.byName(quality);

      switch (quality) {
        case 'medium':
          isHighQuality = false;
          isLowQuality = false;
          isMediumQuality = true;
          break;
        case 'high':
          isHighQuality = true;
          isLowQuality = false;
          isMediumQuality = false;
          break;
        case 'low':
          isHighQuality = false;
          isLowQuality = true;
          isMediumQuality = false;
          break;

        default:
      }

      ///var dayInString = describeEnum(Day.monday);
    });
    await prefs.setString('imagequality', quality);
  }

  int reportImageQuality = 100;
  int imageCount = 4;
  String companyName = 'DeckInspectors';
  late RealmProjectServices realmServices;
  bool isImageUploading = false;
  @override
  void initState() {
    super.initState();
    realmServices = Provider.of<RealmProjectServices>(context, listen: false);
    imageCount = imageCountList.first;
    companyName = list.first;
    reportImageQuality = reportQulityList.first;

    _loadImageSettings();
    // realmServices.addListener(() {
    //   isImageUploading = App.isImageUploading;
    // });
  }

  void setImageQuality(String quality) {
    _applyImageSettings(quality);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(App.isImageUploading.toString());
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 20,
        backgroundColor: Colors.white,
        foregroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'App Settings',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
          child: ListView(children: [
        Column(
          children: [
            const SizedBox(
              height: 4,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Image Settings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Divider(
              color: Color.fromARGB(255, 222, 213, 213),
              height: 0,
              thickness: 1,
              indent: 2,
              endIndent: 2,
            ),
            SizedBox(
              height: 200,
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  ListTile(
                    onTap: () => {setImageQuality('high')},
                    selected: isHighQuality,
                    leading: isHighQuality
                        ? const Icon(
                            Icons.check,
                            color: Colors.blue,
                          )
                        : const SizedBox(
                            width: 40,
                          ),
                    title: const Text('High Quality'),
                  ),
                  ListTile(
                    onTap: () => {setImageQuality('medium')},
                    selected: isMediumQuality,
                    leading: isMediumQuality
                        ? const Icon(
                            Icons.check,
                            color: Colors.blue,
                          )
                        : const SizedBox(
                            width: 40,
                          ),
                    title: const Text('Medium Quality'),
                  ),
                  ListTile(
                    onTap: () => {setImageQuality('low')},
                    selected: isLowQuality,
                    leading: isLowQuality
                        ? const Icon(
                            Icons.check,
                            color: Colors.blue,
                          )
                        : const SizedBox(
                            width: 40,
                          ),
                    title: const Text('Low Quality'),
                  ),
                ],
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Sync Settings',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Divider(
              color: Color.fromARGB(255, 222, 213, 213),
              height: 0,
              thickness: 1,
              indent: 2,
              endIndent: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Offline ',
                  style: TextStyle(fontSize: 15),
                ),
                Switch(
                  onChanged: (value) {
                    toggleSwitch(value);
                  },
                  value: isSyncOn,
                ),
                const Text(
                  'Online',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            Visibility(
              visible: App.isImageUploading,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.orange,
                  color: Colors.blue,
                ),
              ),
            ),

            // OutlinedButton.icon(
            //     style: OutlinedButton.styleFrom(
            //         side: BorderSide.none,
            //         // the height is 50, the width is full
            //         minimumSize: const Size.fromHeight(40),
            //         backgroundColor: Colors.white,
            //         shadowColor: Colors.blue,
            //         elevation: 0),
            //     onPressed: () {
            //       forceSync(context, realmServices);
            //     },
            //     icon: const Icon(
            //       Icons.sync_alt_rounded,
            //       color: Colors.blue,
            //     ),
            //     label: const Text(
            //       'Force Sync',
            //       style: TextStyle(color: Colors.blue),
            //     )),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              color: Color.fromARGB(255, 222, 213, 213),
              height: 0,
              thickness: 1,
              indent: 2,
              endIndent: 2,
            ),
            const SizedBox(
              height: 20,
            ),
            OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                    side: BorderSide.none,
                    // the height is 50, the width is full
                    minimumSize: const Size.fromHeight(40),
                    backgroundColor: Colors.white,
                    shadowColor: Colors.orange,
                    elevation: 0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                icon: const Icon(
                  Icons.logout_outlined,
                  color: Colors.blue,
                ),
                label: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.orange),
                )),
            // const Align(
            //   alignment: Alignment.centerLeft,
            //   child: Padding(
            //     padding: EdgeInsets.all(8),
            //     child: Text(
            //       'Report Settings',
            //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
            // const Divider(
            //   color: Color.fromARGB(255, 222, 213, 213),
            //   height: 0,
            //   thickness: 1,
            //   indent: 2,
            //   endIndent: 2,
            // ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Text(
            //         'Company Name',
            //         style: TextStyle(fontSize: 15),
            //       ),
            //       DropdownButton<String>(
            //         value: companyName,
            //         icon: const Icon(Icons.arrow_drop_down_circle_outlined),
            //         elevation: 16,
            //         style: const TextStyle(color: Colors.blue),
            //         underline: Container(
            //           height: 2,
            //           color: Colors.blue,
            //         ),
            //         onChanged: (String? value) {
            //           // This is called when the user selects an item.
            //           setState(() {
            //             companyName = value!;
            //             savereportSettings();
            //           });
            //         },
            //         items: list.map<DropdownMenuItem<String>>((String value) {
            //           return DropdownMenuItem<String>(
            //             value: value,
            //             child: Text(value),
            //           );
            //         }).toList(),
            //       )
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Text(
            //         'Image Quality(%)',
            //         style: TextStyle(fontSize: 15),
            //       ),
            //       DropdownButton<int>(
            //         value: reportImageQuality,
            //         icon: const Icon(Icons.arrow_drop_down_circle_outlined),
            //         elevation: 16,
            //         style: const TextStyle(color: Colors.blue),
            //         underline: Container(
            //           height: 2,
            //           color: Colors.blue,
            //         ),
            //         onChanged: (int? value) {
            //           // This is called when the user selects an item.
            //           setState(() {
            //             reportImageQuality = value!;
            //             savereportSettings();
            //           });
            //         },
            //         items: reportQulityList
            //             .map<DropdownMenuItem<int>>((int value) {
            //           return DropdownMenuItem<int>(
            //             value: value,
            //             child: Text(value.toString()),
            //           );
            //         }).toList(),
            //       )
            //     ],
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Text(
            //         'Images in a row',
            //         style: TextStyle(fontSize: 15),
            //       ),
            //       DropdownButton<int>(
            //         value: imageCount,
            //         icon: const Icon(Icons.arrow_drop_down_circle_outlined),
            //         elevation: 16,
            //         style: const TextStyle(color: Colors.blue),
            //         underline: Container(
            //           height: 2,
            //           color: Colors.blue,
            //         ),
            //         onChanged: (int? value) {
            //           // This is called when the user selects an item.
            //           setState(() {
            //             imageCount = value!;
            //             savereportSettings();
            //           });
            //         },
            //         items:
            //             imageCountList.map<DropdownMenuItem<int>>((int value) {
            //           return DropdownMenuItem<int>(
            //             value: value,
            //             child: Text(value.toString()),
            //           );
            //         }).toList(),
            //       )
            //     ],
            //   ),
            // ),
            const SizedBox(
              height: 30,
            ),
          ],
        )
      ])),
    );
  }

  List<String> list = <String>['DeckInspectors', 'Wicr'];
  List<int> reportQulityList = <int>[100, 50, 25];
  List<int> imageCountList = <int>[4, 3, 5];

  bool isSyncOn = true;
  void toggleSwitch(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    if (isSyncOn == false) {
      setState(() {
        isSyncOn = true;
        realmServices.sessionSwitch(true);
        appSettings.activeConnection = true;
      });
    } else {
      setState(() {
        isSyncOn = false;
        realmServices.sessionSwitch(false);
        appSettings.activeConnection = false;
      });
    }
    appSettings.isAppOfflineMode = !isSyncOn;
    await prefs.setString('appSync', isSyncOn.toString());
  }

  // void forceSync(BuildContext context, RealmProjectServices realmServices) {
  //   if (appSettings.activeConnection) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //           duration: Duration(seconds: 20),
  //           content: Text('Checking for unsynced images, please wait...')),
  //     );
  //     isImageUploading = true;
  //     realmServices.uploadLocalImages();
  //   }
  // }
}
