import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//https://www.youtube.com/watch?v=ymyYUCrJnxU 1:55
//https://pub.dev/packages/firebase_ml_vision/versions/0.1.2
class test extends StatefulWidget {
  @override
  createState() => _test();
}

class _test extends State<test> {
  File _imageFile;
  List _list;

  void _getImageAndDetectClothes() async {
    final imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    print("1");
    final image = FirebaseVisionImage.fromFile(imageFile);
    print("2"); 
    final ImageLabeler clothingDetector = FirebaseVision.instance.cloudImageLabeler();
    print("3");
    // clothingDetector needs to be of type LabelDetector
    //.detectInImage() not here
    final list = await clothingDetector.processImage(image);

    for (ImageLabel label in list) {
      final String text = label.text;
      final String entityId = label.entityId;
      final double confidence = label.confidence;
      print("text = " + text);
      //print("entity id = " + entityId);
      print("confidence = " + confidence.toString());
    }
    print("4");
    //print("list = " + list.toString());
    if (mounted) {
      setState(() {
      _imageFile = imageFile;
      _list = list;
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),

      body: Container(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _getImageAndDetectClothes();

        },
        tooltip: 'Pick an image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
