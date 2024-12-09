//import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
//import 'package:flutter_vlc_player/flutter_vlc_player.dart';

import 'package:get/get.dart';
//import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:udp/udp.dart';
// import 'package:http/http.dart' as http;
import '../services/signalling.service.dart';
import 'image_widget.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ESP32CameraScreen extends StatefulWidget {
  const ESP32CameraScreen({super.key});

  @override
  State<ESP32CameraScreen> createState() => ESP32CameraScreenState();
}

class ESP32CameraScreenState extends State<ESP32CameraScreen> {
  // generate callerID of local user
  final String selfCallerID = 'e3camReceiver';
  final String calleeId = 'e3camTransmitter';
  final remoteRTCVideoRenderer = RTCVideoRenderer();

  // RTC peer connection
  RTCPeerConnection? _rtcPeerConnection;

  // list of rtcCandidates to be sent over signalling
  List<RTCIceCandidate> rtcIceCadidates = [];

  //Random().nextInt(999999).toString().padLeft(6, '0');
  late WebSocketChannel _channel;
  late Uint8List _imageData = Uint8List(0);

  List<XFile> capturedImages = [];
  bool hardwareKeyConnected = false;
  String base64data = "";

  @override
  void initState() {
    super.initState();
    setupPeerConnection();
  }

  setupPeerConnection() async {
    await remoteRTCVideoRenderer.initialize();

    // create peer connection
    _rtcPeerConnection = await createPeerConnection({
      'iceServers': [
        // {
        //   'urls': [
        //     'stun:stun1.l.google.com:19302',
        //     'stun:stun2.l.google.com:19302'
        //   ]
        // }
      ],
      'iceTransportPolicy': 'all'
    });
    final socket = SignallingService.instance.socket;
    // listen for remotePeer mediaTrack event
    _rtcPeerConnection!.onTrack = (event) {
      if (event.track.kind == 'video') {
        log('Remote video track added');
        setState(() {
          remoteRTCVideoRenderer.srcObject = null;
          remoteRTCVideoRenderer.srcObject = event.streams[0];
        });
      }
    };
    remoteRTCVideoRenderer.onFirstFrameRendered = () {
      log('First frame received');
    };

    _rtcPeerConnection!.onIceCandidate =
        (RTCIceCandidate candidate) => rtcIceCadidates.add(candidate);

    _rtcPeerConnection!.onIceConnectionState = (state) {
      log('ICE Connection State: $state');
    };
    // when call is accepted by remote peer
    socket!.on("callAnswered", (data) async {
      // set SDP answer as remoteDescription for peerConnection
      try {
        await _rtcPeerConnection!.setRemoteDescription(
          RTCSessionDescription(
            data["sdpAnswer"]["sdp"],
            data["sdpAnswer"]["type"],
          ),
        );
      } catch (e) {}

      // send iceCandidate generated to remote peer over signalling
      for (RTCIceCandidate candidate in rtcIceCadidates) {
        socket!.emit("IceCandidate", {
          "calleeId": calleeId,
          "iceCandidate": {
            "id": candidate.sdpMid,
            "label": candidate.sdpMLineIndex,
            "candidate": candidate.candidate
          }
        });
      }
    });

    // get localStream
    // var _localStream = await nav.navigator.mediaDevices
    //     .getUserMedia({'audio': true, 'video': false});

    // // add mediaTrack to peerConnection
    // _localStream!.getTracks().forEach((track) {
    //   _rtcPeerConnection!.addTrack(track, _localStream);
    // });

    //create SDP Offer
    makeCall();
  }

  void makeCall() async {
    RTCSessionDescription offer = await _rtcPeerConnection!.createOffer();

    // set SDP offer as localDescription for peerConnection
    await _rtcPeerConnection!.setLocalDescription(offer);

    // make a call to remote peer over signalling
    SignallingService.instance.socket!.emit('makeCall', {
      "calleeId": calleeId,
      "sdpOffer": offer.toMap(),
    });
  }

  @override
  void dispose() {
    remoteRTCVideoRenderer.dispose();
    _rtcPeerConnection?.close();
    _rtcPeerConnection?.dispose();
    SignallingService.instance.socket!.emit('endCall', {"calleeId": calleeId});
    super.dispose();
  }

  String streamingURL = '';
  String _raspberryIpAddress = 'Fetching...';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: refresh,
          tooltip: 'Refresh',
          child: const Icon(Icons.video_call),
        ),
        appBar: AppBar(
          title: const Text('Live Stream from E3 Camera'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          // Use Expanded to ensure this section takes available space
                          child: remoteRTCVideoRenderer.srcObject != null
                              ? RTCVideoView(
                                  remoteRTCVideoRenderer,
                                  objectFit: RTCVideoViewObjectFit
                                      .RTCVideoViewObjectFitCover,
                                )
                              : const Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Waiting for the feed',
                                    style: TextStyle(fontSize: 15),
                                  ))),
                      const SizedBox(height: 8),
                    ],
                  ),
                  // Padding for the buttons and image capture area
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.0),
                                side: const BorderSide(color: Colors.blue),
                              ),
                            ),
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
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () async {
                              try {
                                // capture image from mediastream
                                final videoTrack = remoteRTCVideoRenderer
                                    .srcObject!
                                    .getVideoTracks()
                                    .first;
                                final frameBuffer =
                                    await videoTrack.captureFrame();

                                var imageBytes = frameBuffer.asUint8List();
                                final directory = await getTemporaryDirectory();
                                final imagePath =
                                    '${directory.path}/${UniqueKey().toString()}.jpg';
                                final file = File(imagePath);
                                await file.writeAsBytes(imageBytes);

                                setState(() {
                                  capturedImages.add(XFile(imagePath));
                                });

                                Get.snackbar("Image Save", "Success!",
                                    duration: const Duration(seconds: 3));
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Error occurred while taking picture: $e'),
                                  ),
                                );
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
                                return horizontalScrollChildren(context, index);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void refresh() {
    makeCall();
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
}
