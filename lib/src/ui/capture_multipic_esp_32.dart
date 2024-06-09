import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:string_validator/string_validator.dart';
import 'package:usb_serial/transaction.dart';
import 'package:usb_serial/usb_serial.dart';

import '../bloc/serial_controller.dart';
import 'image_widget.dart';

class ESP32CameraScreen extends StatefulWidget {
  const ESP32CameraScreen({super.key});

  @override
  State<ESP32CameraScreen> createState() => ESP32CameraScreenState();
}

class ESP32CameraScreenState extends State<ESP32CameraScreen> {
//class ESP32CameraScreenState extends StatelessWidget {
  var _bytesImage;
  UsbPort? _port;
  String _status = "Idle";
  List<Widget> _ports = [];
  //List<String> _serialData = [];

  StreamSubscription<String>? _subscription;
  Transaction<String>? _transaction;
  UsbDevice? _device;
  List<XFile> capturedImages = [];
  bool hardwareKeyConnected = false;
  String base64data = "";
  Future<bool> _connectTo(device) async {
    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
    }

    if (_transaction != null) {
      _transaction!.dispose();
      _transaction = null;
    }

    if (_port != null) {
      _port!.close();
      _port = null;
    }

    if (device == null) {
      _device = null;

      return true;
    }

    _port = await device.create();
    if (await (_port!.open()) != true) {
      setState(() {
        _status = "Failed to open port";
      });
      return false;
    }
    _device = device;

    await _port!.setDTR(true);
    await _port!.setRTS(true);
    await _port!.setPortParameters(
        115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    _transaction = Transaction.stringTerminated(
        _port!.inputStream as Stream<Uint8List>, Uint8List.fromList([13, 10]));

    _subscription = _transaction!.stream.listen((String line) {
      setState(() {
        print(line);
        base64data = line;
      });
    });
    _status = "Connected";
    // setState(() {

    // });
    return true;
  }

  void _getPorts() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (!devices.contains(_device)) {
      _connectTo(null);
    }
    print(devices);
    bool targetDeviceFound = false;

    devices.forEach((device) {
      if (device.pid == 60000 && device.vid == 4292 || // CP210x UART
          device.pid == 24577 && device.vid == 1027 || // FT232R UART
          device.pid == 29987 && device.vid == 6790) // CAMERA_MODEL_AI_THINKER
      {
        targetDeviceFound = true;

        if (!hardwareKeyConnected) {
          _connectTo(device).then((res) {
            hardwareKeyConnected = res;
          });
        }
      }
    });

    if (!targetDeviceFound) {
      hardwareKeyConnected = false;

      _status = "Disconnected";
    }
  }

  @override
  void initState() {
    super.initState();

    UsbSerial.usbEventStream!.listen((UsbEvent event) {
      _getPorts();
    });

    _getPorts();
  }

  @override
  void dispose() {
    super.dispose();
    _connectTo(null);
  }

  //ESP32CameraScreenState({super.key});
  @override
  Widget build(BuildContext context) {
    if (hardwareKeyConnected) {
      if (isBase64(base64data)) {
        _bytesImage = const Base64Decoder().convert(base64data);
      }
    }
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 177, 85, 85),
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Column(
                      children: [
                        Text(_status),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Your ESP32CAM Connected?: ${hardwareKeyConnected.toString().toUpperCase()}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        showImageWithPinchZoom(),

                        // : const Padding(
                        //     padding: EdgeInsets.only(top: 16),
                        //     child: Text(
                        //       'Please connect\nyour ESP32CAM via USB',
                        //       textAlign: TextAlign.center,
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 20),
                        //     ),
                        //   ),
                        const SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16.0,
                        8.0,
                        16.0,
                        8.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  shape: (RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14.0),
                                      side: const BorderSide(
                                          color: Colors.blue)))),
                              onPressed: () {
                                Navigator.of(context).pop(
                                    capturedImages.map((e) => e.path).toList());
                              },
                              icon: const Icon(
                                Icons.done,
                                size: 40,
                              ),
                              label: Text(
                                'Save ${capturedImages.length}',
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: InkWell(
                              onTap: () async {
                                try {
                                  if (_bytesImage == null) return;

                                  final result =
                                      await ImageGallerySaver.saveImage(
                                          _bytesImage);
                                  if (result != null) {
                                    //setState(() {
                                    capturedImages.add(result.filePath);
                                    //});
                                  }

                                  Get.snackbar("Image Save",
                                      result != null ? "Success!" : "Fail!",
                                      duration: const Duration(seconds: 3));
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Error occured while taking picture: $e')),
                                  );

                                  return;
                                }
                              },
                              child: const Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.circle,
                                  color: Colors.white,
                                  size: 80,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: capturedImages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return horizontalScrollChildren(context, index);
                    }),
              ),
            ],
          )),
    );
  }

  Widget showImageWithPinchZoom() {
    if (_bytesImage == null) {
      return const CircularProgressIndicator();
    } else {
      return InteractiveViewer(
        child: Image.memory(
          _bytesImage,
          gaplessPlayback: true,
        ),
      );
    }
  }

  Widget horizontalScrollChildren(BuildContext context, int index) {
    return SizedBox(
        width: 100,
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                decoration: const BoxDecoration(
                    color: Colors.orange,
                    // image: networkImage(currentProject.url as String),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    boxShadow: [
                      BoxShadow(blurRadius: 1.0, color: Colors.blue)
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: networkImage(capturedImages[index].path),
                ),
              ),
              Positioned(
                top: 0,
                width: 30,
                height: 20,
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      if (capturedImages.isNotEmpty) {
                        //setState(() {
                        capturedImages.remove(capturedImages[index]);
                        //});
                      }
                    },
                    icon: const Icon(Icons.delete_forever,
                        size: 20, color: Colors.blueAccent),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
