import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_closet_flutter/ClosetScreen.dart';
import 'package:smart_closet_flutter/camerascreen/camera_screen_no_appbar.dart';
import 'package:smart_closet_flutter/test.dart';
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
                Navigator.pop(context);
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
                Navigator.pop(context);
                Navigator.push(context,
              new MaterialPageRoute(builder: (ctxt) => new Closet()));
                // Update the state of the app
                // ...
                // Then close the drawer
                //Navigator.pop(context);
              },
            ),

            ListTile(
              title: Text('test'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
              new MaterialPageRoute(builder: (ctxt) => new test()));
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


class DrawerOnly extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
    return new Drawer(
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
                Navigator.pop(context);
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
                Navigator.pop(context);
                Navigator.push(context,
              new MaterialPageRoute(builder: (ctxt) => new Closet()));
                // Update the state of the app
                // ...
                // Then close the drawer
                //Navigator.pop(context);
              },
            ),

            ListTile(
              title: Text('test'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
              new MaterialPageRoute(builder: (ctxt) => new test()));
                // Update the state of the app
                // ...
                // Then close the drawer
                //Navigator.pop(context);
              },
            ),

          ],
        ),
    );
  }
}