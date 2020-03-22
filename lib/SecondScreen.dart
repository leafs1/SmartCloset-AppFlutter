import 'dart:io';

import 'package:flutter/material.dart';


class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("My Closet"),),
      body: new Text("I belongs to Second Page"),
    );
  }
}