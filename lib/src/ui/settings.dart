import 'package:deckinspectors/src/bloc/settings_bloc.dart';
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

      ///var dayInString = describeEnum(Day.monday);
    });
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

  late RealmProjectServices realmServices;
  @override
  void initState() {
    super.initState();
    _loadImageSettings();
    realmServices = Provider.of<RealmProjectServices>(context, listen: false);
  }

  void setImageQuality(String quality) {
    _applyImageSettings(quality);
  }

  @override
  Widget build(BuildContext context) {
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
            child: Column(
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Online Sync Enabled ?',
                  style: TextStyle(fontSize: 15),
                ),
                Switch(
                  onChanged: (value) {
                    toggleSwitch(value);
                  },
                  value: isSyncOn,
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                    side: BorderSide.none,
                    // the height is 50, the width is full
                    minimumSize: const Size.fromHeight(40),
                    backgroundColor: Colors.white,
                    shadowColor: Colors.blue,
                    elevation: 0),
                onPressed: () {
                  forceSync(context, realmServices);
                },
                icon: const Icon(
                  Icons.sync_alt_rounded,
                  color: Colors.blue,
                ),
                label: const Text(
                  'Force Sync',
                  style: TextStyle(color: Colors.blue),
                )),
          ],
        )));
  }

  bool isSyncOn = true;
  void toggleSwitch(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    if (isSyncOn == false) {
      setState(() {
        isSyncOn = true;
        realmServices.sessionSwitch(true);
      });
    } else {
      setState(() {
        isSyncOn = false;
        realmServices.sessionSwitch(false);
      });
    }
    appSettings.isAppOfflineMode = !isSyncOn;
    await prefs.setString('appSync', isSyncOn.toString());
  }

  void forceSync(BuildContext context, RealmProjectServices realmServices) {
    realmServices.uploadLocalImages();
  }
}
