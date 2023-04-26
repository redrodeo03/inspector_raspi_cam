import 'package:deckinspectors/src/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _loadImageSettings();
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
            'Image Settings',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Center(
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              Container(
                color: Colors.blue[50],
                child: ListTile(
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
              ),
              Container(
                color: Colors.blue[50],
                child: ListTile(
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
              ),
              Container(
                color: Colors.blue[50],
                child: ListTile(
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
              )
            ],
          ),
        ));
  }
}
