import 'dart:io' as io;
import 'dart:io';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_closet_flutter/DrawerScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

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
        //_secondListOfFiles();
        _listofFiles();
      }

  void _listofFiles() async {
    directory = (await getApplicationDocumentsDirectory()).path;
    setState(() {
      file = io.Directory("$directory/images/").listSync();  //use your folder name insted of resume.
    });
  }

/*
  void _secondListOfFiles() async {
    directory = (await getApplicationDocumentsDirectory()).path;
    setState(() {
      file = io.Directory("$directory").listSync();  //use your folder name insted of resume.
    });

    print(file);
    File jsonn = File((await getApplicationDocumentsDirectory()).path + '/clothing_info.json');
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

    

    

  }
  //Read from json
  Future<String> read(File json) async{
    json.writeAsStringSync("{ \"images\": [{\"name\": \"img1\", \"type\": \"shirt\", \"colour\": \"black\"   }, {\"name\": \"img2\", \"type\": \"pants\", \"colour\": \"white\"}]}");
    //json.writeAsStringSync("{\"images\": [\"img1\":\"h\"]}");
    return (await json.readAsString());
  }

  */

  //Read from json

  void getClothingName() async{
    File jsonn = File((await getApplicationDocumentsDirectory()).path + '/clothing_info.json');

    // Read from json
    String s = (await read(jsonn));
    print(s);
    //Convert String copy of json to actual JSON or Map type idk
    var parsedJson = json.decode(s) as Map;
    print(parsedJson);

  }

  Future<String> read(File json) async{
    return (await json.readAsString());
  }

  Widget card(path){
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      child: Column(
        children: <Widget>[
          Image.file(File(path)),
          Text("Image")
        ],
      ),
    );
  }

  Widget getRow(cardsList) {
    if (cardsList.length == 1){
      return Row(
        children: <Widget>[
          Expanded(
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: cardsList[0],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
            ),
          )


        ],
      );
    } else {
      return Row(
        children: <Widget>[
          Expanded(
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: cardsList[0],
            ),
          ),
          Expanded(
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: cardsList[1],
            ),
          ),
        ],
      );
    }
  }

  String getPath(index) {
    String fileWExtra = file[index].toString();
    int startIdx = fileWExtra.indexOf("/data");
    String path = fileWExtra.substring(startIdx, fileWExtra.length-1);
    return path;
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
                          //print("length = " + file.length.toString());
                          //print(file.toString());

                          //print(fileWExtra.substring(startIdx, fileWExtra.length-1));
                          
                          //Image image = Image.file(File(path));
                          int usedIndex = index * 2;

                          //print("index = " + usedIndex.toString());

                          if (file.length % 2 == 1 && usedIndex == file.length-1) {
                            String path1 = getPath(usedIndex);
                            Card card1 = card(path1);
                            List cards = [card1];
                            //print("second");
                            return getRow(cards);

                          } else {
                            String path1 = getPath(usedIndex);
                            Card card1 = card(path1);

                            String path2 = getPath(usedIndex+1);
                            Card card2 = card(path2);

                            List cards = [card1,card2];
                            //print("first");
                            return getRow(cards);
                          }

                        }, 
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      }, 
                      itemCount: (file.length/2).ceil()),
                  )
                ],
              ),
            ),
    );
  }

  


}

