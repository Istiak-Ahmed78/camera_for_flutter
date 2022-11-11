import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:camera_for_flutter/camera_for_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _file;
  List<CameraDescription> cameras = [];
  @override
  void initState() {
    getCameras();
    super.initState();
  }

  getCameras() async {
    cameras = await availableCameras();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_file != null)
              Container(
                height: 500,
                width: 300,
                decoration: BoxDecoration(
                    image: DecorationImage(image: FileImage(_file!))),
              ),
            ElevatedButton(
                onPressed: () async {
                  XFile? pickedFile = await openCamera(context, cameras.first);
                  if (pickedFile != null) {
                    _file = File(pickedFile.path);
                    setState(() {});
                  }
                },
                child: const Text("Select file"))
          ],
        ),
      ),
    );
  }
}
