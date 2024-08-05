import 'package:camera/camera.dart';
import 'package:camera_app/camera.dart';
import 'package:flutter/material.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(Cameraapp());
}

class Cameraapp extends StatelessWidget {
  const Cameraapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: Camerascreen(cameras: cameras),
    );
  }
}
