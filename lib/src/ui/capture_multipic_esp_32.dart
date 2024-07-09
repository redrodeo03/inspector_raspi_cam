import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:udp/udp.dart';
import 'package:http/http.dart' as http;
import 'image_widget.dart';

class ESP32CameraScreen extends StatefulWidget {
  const ESP32CameraScreen({super.key});

  @override
  State<ESP32CameraScreen> createState() => ESP32CameraScreenState();
}

class ESP32CameraScreenState extends State<ESP32CameraScreen> {
//class ESP32CameraScreenState extends StatelessWidget {

  List<XFile> capturedImages = [];
  bool hardwareKeyConnected = false;
  String base64data = "";

  @override
  void initState() {
    super.initState();
    _listenForEsp32IpAddress();
  }

  String streamingURL = '';
  String _esp32IpAddress = 'Fetching...';
  Future<void> _listenForEsp32IpAddress() async {
    var receiver = await UDP.bind(Endpoint.any(port: const Port(4210)));

    receiver.asStream().listen((datagram) {
      if (datagram != null) {
        String message = String.fromCharCodes(datagram.data);
        setState(() {
          _esp32IpAddress = message;
        });
      }
    });

    // Keep the receiver open for 10 seconds
    await Future.delayed(const Duration(seconds: 10));
    receiver.close();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: refresh,
            tooltip: 'Refresh',
            child: const Icon(Icons.refresh),
          ),
          appBar: AppBar(
            title: Text('External camera, IP: $_esp32IpAddress'),
          ),
          backgroundColor: const Color.fromARGB(255, 177, 85, 85),
          body: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Column(
                      children: [
                        _esp32IpAddress == 'Fetching...'
                            ? const CircularProgressIndicator()
                            : Center(
                                child: Mjpeg(
                                  stream: 'http://$_esp32IpAddress:81/stream',
                                  isLive: true,
                                ),
                              ),
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
                                  final url =
                                      'http://$_esp32IpAddress/capture'; // Replace with your image endpoint
                                  final response =
                                      await http.get(Uri.parse(url));

                                  if (response.statusCode == 200) {
                                    var imageBytes = response.bodyBytes;
                                    final directory =
                                        await getTemporaryDirectory();
                                    final imagePath =
                                        '${directory.path}/${UniqueKey().toString()}.jpg';
                                    final file = File(imagePath);
                                    await file.writeAsBytes(imageBytes);

                                    setState(() {
                                      capturedImages.add(XFile(imagePath));
                                    });

                                    Get.snackbar("Image Save", "Success!",
                                        duration: const Duration(seconds: 3));
                                  } else {
                                    Get.snackbar(
                                        "Image Save", "Faild to save image!",
                                        duration: const Duration(seconds: 3));
                                    throw Exception(
                                        'Failed to load image: ${response.statusCode}');
                                  }
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

  void refresh() {
    setState(() {});
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
