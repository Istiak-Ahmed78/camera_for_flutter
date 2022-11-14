
# Camera for flutter
A package for taking a photo by camera.

## Features

* Capture photo

## Installation
#### Add dependency
Open  your `pubspec.yaml` file add the dependencies like this way.
```yaml
dependencies:

  camera: ^0.10.0+4
  camera_for_flutter:
    git:
      url: https://github.com/Istiak-Ahmed78/camera_for_flutter.git
```
#### Change `minSDK` version
Navigate to the file `YOUR PROJECT/android/app/build.gradle` and `minSdkVersion` and change it to `21`
```groovy
minSdkVersion 21
```

#### Run `Get packages`
Open your terminal and run `pub get` the get the package
## How to use
#### Import the package
```dart
import 'package:camera_for_flutter/camera_for_flutter.dart';
```
#### Code
```dart
import 'package:camera/camera.dart';
import 'package:camera_for_flutter/camera_for_flutter.dart';
import 'package:flutter/material.dart';

class CameraForFlutterExampleScreen extends StatefulWidget {
  const CameraForFlutterExampleScreen({super.key});

  @override
  State<CameraForFlutterExampleScreen> createState() =>
      _CameraForFlutterExampleScreenState();
}

class _CameraForFlutterExampleScreenState
    extends State<CameraForFlutterExampleScreen> {
  late List<CameraDescription> _availableCameraList;
  @override
  void initState() {
    _getCameras();
    super.initState();
  }

  _getCameras() async {
    _availableCameraList = await availableCameras();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
          /// Opens a camera. returns a [XFile] after taking a photo
            XFile? pickedFile =
                await openCamera(context, _availableCameraList.first);
          },
          child: const Text("Open camera"),
        ),
      ),
    );
  }
}

```
(File an issue for any query or any issue. Contribution is welcomed)
