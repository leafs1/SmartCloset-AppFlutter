import 'package:flutter/material.dart';
import 'package:smart_closet_flutter/DrawerScreen.dart';
import 'camerascreen/camera_screen.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';
// https://medium.com/@dev.n/the-complete-flutter-series-article-3-lists-and-grids-in-flutter-b20d1a393e39
void main() => runApp(SmartCloset());

class SmartCloset extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    print("starting json");
    makeJson();
    print("ending json");

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: DrawerScreen(),
      
    );
  }

  void makeJson() async{
    String path = (await getApplicationDocumentsDirectory()).path + '/clothing_info.json';
    print("path = " + path );
    File json = File((await getApplicationDocumentsDirectory()).path + '/clothing_info.json');
  }

}


