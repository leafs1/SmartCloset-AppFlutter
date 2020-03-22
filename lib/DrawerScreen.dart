import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_closet_flutter/SecondScreen.dart';
import 'package:smart_closet_flutter/camerascreen/camera_screen_no_appbar.dart';
import 'camerascreen/camera_screen.dart';

class DrawerScreen extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
    return new MaterialApp(
      home: new DrawerWidget()
    );
  }
}

class DrawerWidget extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Add Clothes"), 
        backgroundColor: Colors.blueGrey,
      ),
      body: new CameraScreenNoAppbar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,

          children: <Widget>[
            DrawerHeader(
              child: Text("null"),
              decoration: BoxDecoration(
                color: Colors.blueGrey
              ),
            ),
            ListTile(
              title: Text('Add Clothes'),
              onTap: () {
                Navigator.push(context,
              new MaterialPageRoute(builder: (ctxt) => new CameraScreen()));
              print("changed");
                // Update the state of the app
                // ...
                // Then close the drawer
                //Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('My Closet'),
              onTap: () {
                Navigator.push(context,
              new MaterialPageRoute(builder: (ctxt) => new SecondScreen()));
                // Update the state of the app
                // ...
                // Then close the drawer
                //Navigator.pop(context);
              },
            ),

          ],
        ),
      ),
      
    );
  }
}

