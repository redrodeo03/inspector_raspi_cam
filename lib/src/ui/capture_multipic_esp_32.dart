//import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
//import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:get/get.dart';
//import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:udp/udp.dart';
// import 'package:http/http.dart' as http;
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
    _listenForPiIpAddress();
  }

  @override
  void dispose() {
    _vlcViewController.dispose();
    super.dispose();
  }

  late VlcPlayerController _vlcViewController;
  //= VlcPlayerController.network(
  //"rtsp://192.168.129.126:8554/stream",
  // "rtsp://e3cam.local:8554/stream",
  //autoPlay: true,
  //options: VlcPlayerOptions());
  String streamingURL = '';
  String _raspberryIpAddress = 'Fetching...';

  Future<void> _listenForPiIpAddress() async {
    var receiver = await UDP.bind(Endpoint.any(port: const Port(5005)));
    //receiver.send([1, 2, 3, 4], Endpoint.any(port: const Port(5005)));
    receiver.asStream().listen((datagram) {
      if (datagram != null) {
        String message = String.fromCharCodes(datagram.data);

        setState(() {
          _raspberryIpAddress = message;
          _vlcViewController = VlcPlayerController.network(
              "rtsp://$_raspberryIpAddress:8554/stream",
              autoPlay: true,
              options: VlcPlayerOptions());
        });
        receiver.close();
      }
    });

    // Keep the receiver open for 60 seconds
    await Future.delayed(const Duration(seconds: 60));
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
            title: Text('E3 camera,IP: $_raspberryIpAddress'),
          ),
          //backgroundColor: const Color.fromARGB(255, 177, 85, 85),
          body: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _raspberryIpAddress != 'Fetching...'
                          ? VlcPlayer(
                              controller: _vlcViewController,
                              aspectRatio: 9 / 16,
                              virtualDisplay: true,
                              placeholder: const Center(
                                  child: CircularProgressIndicator(
                                color: Colors.blueAccent,
                              )),
                            )
                          : const CircularProgressIndicator(
                              color: Colors.blueAccent,
                            ),
                      const SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      8.0,
                      8.0,
                      8.0,
                      8.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                shape: (RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.0),
                                    side:
                                        const BorderSide(color: Colors.blue)))),
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
                                var imageBytes =
                                    await _vlcViewController.takeSnapshot();
                                if (imageBytes != null) {
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
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: 100,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: capturedImages.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return horizontalScrollChildren(
                                      context, index);
                                }),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
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
                        setState(() {
                          capturedImages.remove(capturedImages[index]);
                        });
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

  bool isPlaying = true;
  Future<void> _listenToRSTPStream() async {
    //isPlaying = (await _vlcViewController.isPlaying())!;zX
  }
}
