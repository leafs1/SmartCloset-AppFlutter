import 'dart:io';
import 'dart:io' as io;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:smart_closet_flutter/DrawerScreen.dart';
import 'camera_screen.dart';
import 'package:camera/camera.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  String directory;
  List file = new List();

  File _imageFile;
  List _list;

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
        title: const Text('Add Clothes'),
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
      drawer: new DrawerOnly()
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

      // create image directory
      final startDir = (await getApplicationDocumentsDirectory()).path;
      new Directory(startDir + "/images/").create().then((Directory directory) {
      print(directory.path);
  });

      // get permanent path
      final newPath = join(
        (await getApplicationDocumentsDirectory()).path,
        'images/$imageName.png',
      );
      print("new path = " + newPath);

      // bring up message
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
                  _saveJson(newPath);





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



  void _saveJson(String imgPath) async {
    

    print(file);
    File jsonn = File((await getApplicationDocumentsDirectory()).path + '/clothing_info.json');
    jsonn.writeAsStringSync("{ \"images\": [{\"name\": \"img1\", \"type\": \"shirt\", \"colour\": \"black\"   }, {\"name\": \"img2\", \"type\": \"pants\", \"colour\": \"white\"}]}");
    print("reading json");
    



    // Read from json
    String s = (await read(jsonn));
    print(s);
    //Convert String copy of json to actual JSON or Map type idk
    var parsedJson = json.decode(s) as Map;
    print(parsedJson);
    
    List imageNames = new List();
    List clothingTypes = new List();
    List clothingColour = new List();

    // Parse json and add image info the their respected lists.
    for (final i in parsedJson["images"]){
      imageNames.add(i["name"]);  
      clothingTypes.add(i["type"]);
      clothingColour.add(i["colour"]);
    }

    print(imageNames);
    print(clothingTypes);
    print(clothingColour);

    
    //Add new Data to lists
    //Add image path to list
    imageNames.add(imgPath);

    // Add clothing types and colour to lists
    List info = (await _getImageAndDetectClothes(imgPath));
    print("info2 = ");
    print(info);
    clothingTypes.add(info[0]);
    clothingColour.add(info[1]);

    print(imageNames);
    print(clothingTypes);
    print(clothingColour);

    //Convert Lists to JSON

    String startJSON = "{ \"images\": [";

    for (int i = 0; i < imageNames.length; i++){
      if (i == imageNames.length-1) {
        String addition = "{\"name\": \"" + imageNames[i] + "\", \"type\": \"" + clothingTypes[i] + "\", \"colour\": \"" + clothingColour[i] + "\"}";
        startJSON += addition;
      } else {
        String addition = "{\"name\": \"" + imageNames[i] + "\", \"type\": \"" + clothingTypes[i] + "\", \"colour\": \"" + clothingColour[i] + "\"}, ";
        startJSON += addition;
      }
    }

    startJSON += "]}";
    print(startJSON);

    jsonn.writeAsStringSync(startJSON);
    String testttt = (await read(jsonn));
    print("test");
    print(testttt);

    
  }



  //Read from json
  Future<String> read(File json) async{
    return (await json.readAsString());
  }


  Future<List> _getImageAndDetectClothes(String imgPath) async {
    final imageFile = File(imgPath);
    print("1");
    final image = FirebaseVisionImage.fromFile(imageFile);
    print("2"); 
    final ImageLabeler clothingDetector = FirebaseVision.instance.cloudImageLabeler();
    print("3");
    // clothingDetector needs to be of type LabelDetector
    //.detectInImage() not here
    final list = await clothingDetector.processImage(image);
    List info = new List();

    for (ImageLabel label in list) {
      final String text = label.text;
      final String entityId = label.entityId;
      final double confidence = label.confidence;
      print("text = " + text);
      //print("entity id = " + entityId);
      print("confidence = " + confidence.toString());
    }
    print("4");

    info.add(list[0].text);
    info.add(list[1].text);
    print("info = ");
    print(info);

    //print("list = " + list.toString());
    if (mounted) {
      setState(() {
      _imageFile = imageFile;
      _list = list;
    });
    }
    return info;
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

