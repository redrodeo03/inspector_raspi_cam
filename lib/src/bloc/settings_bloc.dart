import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppSettings extends ChangeNotifier {
  ImageQuality currentQuality = ImageQuality.high;
  bool isAppOfflineMode = false;
  bool isInvasiveMode = false;
  String companyName = 'DeckInspectors';
  int reportImageQuality = 100;
  int imageinRowCount = 4;
  bool activeConnection = true;

  ConnectivityResult connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;

  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    // Platform messages may fail, so we use a try/catch PlatformException.
    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      //Console.log('Couldn\'t check connectivity status', error: e);
      return;
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    connectionStatus = result;
    activeConnection = connectionStatus != ConnectivityResult.none;
    if (activeConnection) {
      notifyListeners();
    }
  }
}

enum ImageQuality { high, medium, low }

final appSettings = AppSettings();
