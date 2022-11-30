
# Camera for flutter
A package for taking a photo by camera.

## Features

* Capture photo

## Screenshots

<table align="center" style="border:1px solid black;">
  <tr>
    <th style="text-align: center">Inital Screen</th>
     <th style="text-align: center">After taking photo</th>
  </tr>
  <tr>
    <td valign="top"><img src="https://user-images.githubusercontent.com/68919043/204817622-00538960-73d1-4696-ab41-a525cd9705a5.jpg" width="260" height="560" ></td>
    <td valign="top"><img src="https://user-images.githubusercontent.com/68919043/204817662-61495d0c-cb5c-4440-9e9d-1b8b85e14114.jpg" width="260" height="560" ></td>
  </tr>
 </table>
 

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
Open your terminal and run `pub get` to get the package
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
            XFile? capturedImageXFile =
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
