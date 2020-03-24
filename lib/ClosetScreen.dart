import 'dart:io' as io;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_closet_flutter/DrawerScreen.dart';
import 'package:path_provider/path_provider.dart';

class Closet extends StatefulWidget {
  @override
  _ClosetState createState() {
    return _ClosetState();
  }
}

class _ClosetState extends State {
  @override

  String directory;
  List file = new List();
  
  void initState() {
        // TODO: implement initState
        super.initState();
        _listofFiles();
      }

  void _listofFiles() async {
    directory = (await getApplicationDocumentsDirectory()).path;
    setState(() {
      file = io.Directory("$directory/images/").listSync();  //use your folder name insted of resume.
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("My Closet"), backgroundColor: Colors.blueGrey),
      drawer: new DrawerOnly(),
      body: Container(
              child: Column(
                children: <Widget>[
                  // your Content if there
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                          //print(file[0].toString());

                          String fileWExtra = file[index].toString();
                          int startIdx = fileWExtra.indexOf("/data");

                          String path = fileWExtra.substring(startIdx, fileWExtra.length-1);
                          //print(fileWExtra.substring(startIdx, fileWExtra.length-1));
                          
                          return Image.file(File(path));
                        }, 
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      }, 
                      itemCount: file.length),
                  )
                ],
              ),
            ),
    );
  }

  


}

