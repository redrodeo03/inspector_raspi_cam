import 'package:flutter/material.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'dart:io' show Platform;

import '../resources/keys.dart';

class GoogleMapsView extends StatefulWidget {
  final double latitude;
  final double longitude;
  GoogleMapsView(this.latitude, this.longitude, {super.key});

  @override
  State<GoogleMapsView> createState() => _GoogleMapsViewState();
  //static final kInitialPosition = LatLng(latitude, longitude);

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
}

class _GoogleMapsViewState extends State<GoogleMapsView> {
  PickResult? selectedPlace;

  //bool _mapsInitialized = false;
  late LatLng projectCoordinates;

  @override
  void initState() {
    projectCoordinates = LatLng(widget.latitude, widget.longitude);
    initRenderer();
    super.initState();
  }

  void initRenderer() {
    // if (_mapsInitialized) return;
    // if (widget.mapsImplementation is GoogleMapsFlutterAndroid) {
    //   (widget.mapsImplementation as GoogleMapsFlutterAndroid)
    //       .initializeWithRenderer(AndroidMapRenderer.latest);
    // }

    // setState(() {
    //   _mapsInitialized = true;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Search and Select the project site"),
        ),
        body: Center(
            child: PlacePicker(
          resizeToAvoidBottomInset:
              false, // only works in page mode, less flickery
          apiKey:
              Platform.isAndroid ? APIKeys.androidApiKey : APIKeys.iosApiKey,
          hintText: "Find a place ...",
          searchingText: "Please wait ...",
          selectText: "Select place",
          outsideOfPickAreaText: "Place not in area",
          initialPosition: projectCoordinates,
          useCurrentLocation: false,

          selectInitialPosition: true,
          usePinPointingSearch: true,
          usePlaceDetailSearch: true,
          zoomGesturesEnabled: true,
          automaticallyImplyAppBarLeading: false,
          zoomControlsEnabled: true,
          ignoreLocationPermissionErrors: true,
          onMapCreated: (GoogleMapController controller) {
            print("Map created");
            // controller
            //     .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            //   target: projectCoordinates,
            //   zoom: 16,
            // )));
          },
          onPlacePicked: (PickResult result) {
            print("Place picked: ${result.formattedAddress}");
            setState(() {
              selectedPlace = result;
              Navigator.of(context).pop({
                "address": selectedPlace?.formattedAddress,
                "latitude": selectedPlace?.geometry?.location.lat,
                "longitude": selectedPlace?.geometry?.location.lng
              });
            });
          },
          onMapTypeChanged: (MapType mapType) {
            print("Map type changed to ${mapType.toString()}");
          },
        )));
  }
}
