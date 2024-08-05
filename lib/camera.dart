import 'dart:io';

import 'package:camera_app/gallery.dart';
import 'package:camera_app/openfolder.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class Camerascreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const Camerascreen({super.key, required this.cameras});

  @override
  State<Camerascreen> createState() => _CamerascreenState();
}

class _CamerascreenState extends State<Camerascreen> {
  late CameraController _controller;
  //to capture images
  bool isCapturing = false;
  bool isFlashOn = false;
  String? imagepath;

  @override
  void initState() {
    _controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    super.initState();
    // permission();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flashfunction() {
    if (isFlashOn) {
      _controller.setFlashMode(FlashMode.off);
      setState(() {
        isFlashOn = false;
      });
    } else {
      _controller.setFlashMode(FlashMode.always);
      setState(() {
        isFlashOn = true;
      });
    }
  }

  void captureimage() async {
    if (!_controller.value.isInitialized) {
      return;
    }

    final Directory appDir = await getApplicationSupportDirectory();
    final String capturePath = path.join(appDir.path, '${DateTime.now()}.jpeg');

    if (_controller.value.isTakingPicture) {
      return;
    }
    try {
      setState(() {
        isCapturing = true;
      });

      final XFile capturedImg = await _controller.takePicture();

      await capturedImg.saveTo(capturePath);

      print('\n image path : $capturePath');
      await GallerySaver.saveImage(capturePath);
      imagepath = capturePath;
      print('Photo captured and saved to the gallery');

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (ctx) => Imageview(imagePath: capturePath)),
        );
      }
    } catch (e) {
      print('Error while capturing photo: $e');
    } finally {
      setState(() {
        isCapturing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }

    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                AppBar(
                  backgroundColor: Colors.black,
                  title: Text('Camera '),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        onTap: _flashfunction,
                        child: isFlashOn
                            ? Icon(Icons.flash_on, color: Colors.yellow)
                            : Icon(Icons.flash_off, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Positioned.fill(
                  top: 50,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: CameraPreview(_controller),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(color: Colors.black),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Photo',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 70.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: captureimage,
                                child: Icon(
                                  Icons.circle_sharp,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (ctx) {
                                      return Openfolder();
                                    }));
                                  },
                                  icon: Icon(
                                    Icons.image,
                                    color: Colors.white,
                                    size: 30,
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
