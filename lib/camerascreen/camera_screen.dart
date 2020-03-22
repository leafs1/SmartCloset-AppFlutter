import 'dart:io';

import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'package:camera/camera.dart';

import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
//https://www.raywenderlich.com/4333657-using-the-camera-on-flutter

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() {
    return _CameraScreenState();
  }
}

class _CameraScreenState extends State {
  CameraController controller;
  List cameras;
  int selectedCameraIdx;
  String imagePath;

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {

      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });

        _initCameraController(cameras[selectedCameraIdx]).then((void v) {});
      }else{
        print("No camera available");
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });
  }



  // Initialize the CameraController object (async). Holds information about the camera direction, resolution...
  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      print("no");
    }

    if (mounted) {
      setState(() {});
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Click To Share'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: _cameraPreviewWidget(),
              ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _cameraTogglesRowWidget(),
                  _captureControlRowWidget(context),
                  Spacer()
                ],
              ),
              SizedBox(height: 20.0)
            ],
          ),
        ),
      ),
    );
  }







  /// Display the control bar with buttons to take pictures
  Widget _captureControlRowWidget(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            FloatingActionButton(
                child: Icon(Icons.camera),
                backgroundColor: Colors.blueGrey,
                onPressed: () { 
                  _onCapturePressed(context);
                  
                })
          ],
        ),
      ),
    );
  }

  // Show dialog box when the take picture button is hit
  bool _showDialog(context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Would you like to save the photo?"),
          content: new Text("Alert Dialog body"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            //First Button
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
                return false;
              },
            ),
            // Second Button
            new FlatButton(
              child: new Text("Save"), 
              onPressed: () {
                Navigator.of(context).pop();
                return true;
              }
            )
          ],
        );
      },
    );
  }




  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FlatButton.icon(
          onPressed: _onSwitchCamera, 
          icon: Icon(_getCameraLensIcon(lensDirection)), 
          label: Text("${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1)}"
        )),
      )
    );
  }

  // Returns a specific icon based on the camera selected
  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  // Function to switch cameras 
  void _onSwitchCamera() {
    selectedCameraIdx = selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIdx];
    _initCameraController(selectedCamera);
  }



  // Logic to capture picture and save to path
  Future _onCapturePressed(context) async {
    try {
      // Store the picture in the temp directory.
      //getTemporaryDirectory
      final imageName = DateTime.now().toString();

      //getApplicationDocumentsDirectory
      final path = join(
        (await getTemporaryDirectory()).path,
        '$imageName.png',
      );
      // Capture image and save it to passed in path
      print("path = " + path.toString());
      await controller.takePicture(path);
      print("picture taken");
      print(controller.value.aspectRatio);

      print("getting file");
      File file = File(path);

      final newPath = join(
        (await getApplicationDocumentsDirectory()).path,
        '$imageName.png',
      );
      print("new path = " + newPath);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text("Would you like to save the photo?"),
            content: new Image.file(file),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              //First Button
              new FlatButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                  print("not moved");
                },
              ),
              // Second Button
              new FlatButton(
                child: new Text("Save"), 
                onPressed: () {
                  Navigator.of(context).pop();
                  file.rename(newPath);


                  print("moved");
                }
              )
            ],
          );
        },
      );

      // Displays the image taken
/* 
      Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: "/data/user/0/com.example.smart_closet_flutter/app_flutter/2020-03-21 21:37:41.154984.png", imageName: imageName),
              ),
            );
*/      
    } catch (e) {
      print(e);
    }
  }



  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);

    print('Error: ${e.code}\n${e.description}');
  }




  /// Display Camera preview.
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
  }
}


// In the new page have same layout as before and have a button that says "save". If button is pressed, img is saved and go back to 
//taking pictyre screen.

// A widget that displays the picture taken by the user.
/*
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final String imageName;

  const DisplayPictureScreen({Key key, this.imagePath, this.imageName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confrmation'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Image.file(File(imagePath), fit: BoxFit.fitWidth),
              ),
              
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Spacer(),
                  _captureControlRowWidget(context),
                  Spacer()
                ],
              ),
              SizedBox(height: 20.0)
            ],
          ),
        ),
      ),
    );
    
  }

    Widget _captureControlRowWidget(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            FloatingActionButton(
                child: Icon(Icons.add_a_photo),
                backgroundColor: Colors.blueGrey,
                onPressed: (                
                ) {
                  
                })
          ],
        ),
      ),
    );
  }

  
}

*/

