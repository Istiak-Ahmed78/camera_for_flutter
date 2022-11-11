import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

Future<XFile?> openCamera(BuildContext context,
    [CameraDescription? cameraToOpen]) async {
  XFile? rawFile = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => _CameraScreen(
                cameraToCapture: cameraToOpen,
              )));
  return rawFile;
}

class _CameraScreen extends StatefulWidget {
  final CameraDescription? cameraToCapture;
  const _CameraScreen({super.key, this.cameraToCapture});

  @override
  State<_CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<_CameraScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  late List<CameraDescription> _availableCameras;
  late CameraDescription currentUsingCamera;
  final Color _buttonColor = const Color.fromRGBO(52, 52, 52, 0.5);
  final Color _buttonIconColor = const Color.fromRGBO(250, 249, 246, 1);

  XFile? file;

  bool get isFileSelected => file != null;

  @override
  void initState() {
    _getAvailableCameras();
    currentUsingCamera = widget.cameraToCapture ?? _availableCameras.first;
    _cameraController =
        CameraController(currentUsingCamera, ResolutionPreset.high);
    _initializeCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _getAvailableCameras() async {
    _availableCameras = await availableCameras();
    setState(() {});
  }

  void _initializeCamera() {
    _initializeControllerFuture = _cameraController.initialize();
  }

  void _changeCamera() async {
    if (_availableCameras.isNotEmpty && _availableCameras.length == 2) {
      if (currentUsingCamera == _availableCameras[0]) {
        currentUsingCamera = _availableCameras[1];
      } else {
        currentUsingCamera = _availableCameras[0];
      }
      setState(() {});
      _cameraController =
          CameraController(currentUsingCamera, ResolutionPreset.high);
      _initializeCamera();
    }
  }

  void _capturePhoto() async {
    try {
      await _initializeControllerFuture;
      XFile pickedFile = await _cameraController.takePicture();

      if (currentUsingCamera.lensDirection == CameraLensDirection.front) {
        XFile? rotatedImage = await _rotateImage(pickedFile);
        if (rotatedImage != null) {
          pickedFile = rotatedImage;
        }
      }
      file = pickedFile;
      setState(() {});
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<XFile?> _rotateImage(XFile givenFile) async {
    List<int> imageBytes = await givenFile.readAsBytes();

    img.Image? originalImage = img.decodeImage(imageBytes);
    img.Image? fixedImage;
    if (originalImage != null) {
      img.Image verticallyRotatedImage = img.flipVertical(originalImage);
      fixedImage = img.copyRotate(verticallyRotatedImage, 180);
    } else {
      return null;
    }

    File file = File(givenFile.path);

    File fixedFile = await file.writeAsBytes(
      img.encodeJpg(fixedImage),
      flush: true,
    );
    return XFile(fixedFile.path);
  }

  void triggerCloseButton() {
    if (isFileSelected) {
      file = null;
      setState(() {});
    } else {
      Navigator.pop(context);
    }
  }

  void triggerCaptureImageButton() {
    if (isFileSelected) {
      Navigator.pop(context, file);
    } else {
      _capturePhoto();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget photoWidget = CameraPreview(_cameraController);
    if (isFileSelected) {
      photoWidget = Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: FileImage(File(file!.path)), fit: BoxFit.fitWidth)),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, sn) {
          late Widget child;

          if (sn.connectionState == ConnectionState.done) {
            child = Center(
                child: Stack(
              children: [
                Align(alignment: Alignment.center, child: photoWidget),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton(
                          heroTag: "closeButton",
                          backgroundColor: _buttonColor,
                          elevation: 0,
                          onPressed: triggerCloseButton,
                          child: Icon(
                            Icons.close,
                            color: _buttonIconColor,
                          ),
                        ),
                        FloatingActionButton(
                          heroTag: "captureButton",
                          backgroundColor: _buttonColor,
                          elevation: 0,
                          onPressed: triggerCaptureImageButton,
                          child: Icon(
                            isFileSelected ? Icons.check : Icons.camera,
                            color: _buttonIconColor,
                          ),
                        ),
                        FloatingActionButton(
                          heroTag: "rotateButton",
                          backgroundColor: isFileSelected
                              ? _buttonColor.withOpacity(0.3)
                              : _buttonColor,
                          elevation: 0,
                          onPressed: isFileSelected ? null : _changeCamera,
                          child: Icon(
                            Icons.rotate_left_outlined,
                            color: isFileSelected
                                ? _buttonIconColor.withOpacity(0.3)
                                : _buttonIconColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ));
          } else if (sn.hasError) {
            child = Center(child: Text(sn.error.toString()));
          } else {
            child = const SizedBox();
          }
          return child;
        },
      ),
    );
  }
}
