import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_closet_flutter/DrawerScreen.dart';


class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("My Closet"), backgroundColor: Colors.blueGrey),
      body: new Text("I belongs to Second Page"),
      drawer: new DrawerOnly(),
    );
  }
}