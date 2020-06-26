import 'dart:developer';
import 'dart:io' as io;
import 'dart:io';
import 'dart:core';

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
  String _value = "1";
  String directory;
  List file = new List();

  List currentList = ["null"];
  //List shirts = ["Shirt", "shirt", "t-shirt", "top"];
  List shirts = ["Property", "kitchen", "Kitchen"];
  List pants = ["idk"];
  
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

  Future getClothingName(String imgPath, String imgPath2) async{

    if (imgPath2 == "none"){
      File jsonn = File((await getApplicationDocumentsDirectory()).path + '/clothing_info.json');

      // Read from json
      String s = (await read(jsonn));
      //print(s);
      //Convert String copy of json to actual JSON or Map type idk
      var parsedJson = json.decode(s) as Map;
      //print(parsedJson);
      //print("please work hreee");

      print("path = " + imgPath);

      for (var i in parsedJson["images"]) {
        print("images = " + parsedJson["images"].toString());
        //print(i["name"].toString());
        //print(imgPath);
        if (i["name"].toString() == imgPath) {
          return i["allTypes"].toString();
        } else {
          //print("not here");
        }
        //print("done");
      }
      return "none";
      //return finished;
    } else {
      File jsonn = File((await getApplicationDocumentsDirectory()).path + '/clothing_info.json');
      //print("path1 = " + imgPath);
     // print("path2 = " + imgPath2);

      // Read from json
      String s = (await read(jsonn));
      //print(s);
      //Convert String copy of json to actual JSON or Map type idk
      var parsedJson = json.decode(s) as Map;
      //print(parsedJson);

      List names = new List();

      for (var i in parsedJson["images"]) {
                print("images = " + parsedJson["images"].toString());

       // print(i["name"].toString());
       // print(imgPath);
        if (i["name"].toString() == imgPath) {
          names.add(i["allTypes"].toString());
          //return i["type"].toString();
        } else {
          //names.add("none");
          //return "None";
        }
      }

      for (var i in parsedJson["images"]) {
      //  print(i["name"].toString());
     //   print(imgPath);
        if (i["name"].toString() == imgPath2) {
          names.add(i["allTypes"].toString());
          //return i["type"].toString();
        } else {
          //names.add("none");
          //return "None";
        }
      }

      //print("names = (down)");
      //print(names);
    //  print("names = " + names.toString());
      return names;
    }

    
  }

  Future<String> read(File json) async{
    return (await json.readAsString());
  }

  Widget card(path, text) {
    return new Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Image.asset('lib/images/coathanger3.png'),
                  Card(
                    margin: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                    child: Container(
                      child: 
                        Column(
                          children: <Widget>[
                            Image.file(File(path)),
                            Text(text)
                            ],
                          ),                      
                        ),
                      ),
                    ],)
            ],
          );  
  }


  Widget getRow(cardsList) {
    if (cardsList.length == 1){
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded( 
              child: Align(
                alignment: Alignment.center,
                child: Wrap (
                  children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Transform(
                            transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.01)
                            ..rotateY(0.3),
                            alignment: FractionalOffset.center,
                            
                            child: Stack(
                              children: <Widget>[
                                cardsList[0],
                              ],)
                          ),
                        Column(
                          children: <Widget>[
                            SizedBox(height: 33),
                            Image.asset('lib/images/bar.png')
                          ],
                       ),

      new Positioned.fill(
        child: Stack(
          children: <Widget>[
            Container(), 
            Transform(
              transform: Matrix4.identity()
              ..setEntry(3, 2, 0.01)
              ..rotateY(0.3),
              alignment: FractionalOffset.center,
              child: Stack(
                children: <Widget>[
                  Container(), Image.asset('lib/images/coathanger3cut2.png')
              ],)         
              ),
      ],),
    ),                     
                    ],)
                  ],
                ),
              )
            
              
          ),
          Expanded(
            child: Align(
                alignment: Alignment.center,
                child: Wrap (
                  children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Transform(
                            transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.01)
                            ..rotateY(0.3),
                            alignment: FractionalOffset.center,
                            
                            child:
                              Stack(
                                children: <Widget>[
                                  Opacity(opacity: 0, child: cardsList[0],),
                                  new Positioned.fill(
                                    child: 
                                    Opacity(opacity: 0.0, child: Container(color: Color.fromRGBO(144, 205, 240, 100),),),
                              ),
                          ],))
                        ,

                        Column(
                          children: <Widget>[
                            SizedBox(height: 33),
                            Image.asset('lib/images/bar.png')
                          ],
                       ),         
                       ],)
                  ],
                ),
              )
          )
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          Expanded(
            child: Align(
                alignment: Alignment.center,
                child: Wrap (
                  children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Transform(
                            transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.01)
                            ..rotateY(0.3),
                            alignment: FractionalOffset.center,
                            child: Stack(
                              children: <Widget>[
                                cardsList[0],
                          ],)
                          ),

                        Column(
                          children: <Widget>[
                            SizedBox(height: 33),
                            Image.asset('lib/images/bar.png')
                          ],
                       ),
   
      new Positioned.fill(
        child: Stack(
          children: <Widget>[
            Container(), 
            Transform(
              transform: Matrix4.identity()
              ..setEntry(3, 2, 0.01)
              ..rotateY(0.3),
              alignment: FractionalOffset.center,
              
              child: Stack(
                children: <Widget>[
                Container(), 
                Image.asset('lib/images/coathanger3cut2.png')
              ],) 
            ),
      ],),
    ),                        
                       ],)
                  ],
                ),
              )
          ),
          Expanded(
            child: Align(
                alignment: Alignment.center,
                child: Wrap (
                  children: <Widget>[
                      Stack(
                        children: <Widget>[
                        Transform(
                          transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.01)
                          ..rotateY(0.3),
                          alignment: FractionalOffset.center,
                          child: Stack(
                            children: <Widget>[
                              cardsList[1],
                        ],)
                        ),

                        Column(
                          children: <Widget>[
                            SizedBox(height: 33),
                            Image.asset('lib/images/bar.png')
                          ],
                       ),
      new Positioned.fill(
        child: Stack(
          children: <Widget>[
            Container(), 
            Transform(
              transform: Matrix4.identity()
              ..setEntry(3, 2, 0.01)
              ..rotateY(0.3),
              alignment: FractionalOffset.center,
              
              child: Stack(
                children: <Widget>[
                  Container(), 
                  Image.asset('lib/images/coathanger3cut2.png')
              ],)              
                        ),
      ],),
    ),          
                       ],)
                                         
                  ],
            
                ),
              )
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





  Widget main() {
return new Scaffold(
      appBar: new AppBar(
        title: new Text("My Closet"), 
        backgroundColor: Colors.blueGrey, 
        actions: <Widget>[
          DropdownButton(
            value: _value,
            items: [
              DropdownMenuItem(
                value: "1",
                child: Row(
                 // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.build),
                    SizedBox(width: 15),
                    Text(
                      "All Clothes",
                    ),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: "2",
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.settings),
                    SizedBox(width: 10),
                    Text(
                      "Shirts", 
                    ),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: "3",
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.settings),
                    SizedBox(width: 10),
                    Text(
                      "Pants", 
                    ),
                  ],
                ),
              ),
              DropdownMenuItem(
                value: "4",
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.settings),
                    SizedBox(width: 10),
                    Text(
                      "Other", 
                    ),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                if (value == "1"){
                  currentList = ["null"];
                } else if (value == "2") {
                  currentList = shirts;
                } else if (value == "3") {
                  currentList = pants;
                }
                _value = value;
                build(context);
              });
            },
            //isExpanded: true,
          )
      ],),
      drawer: new DrawerOnly(),
      body: Container(
        color: Color.fromRGBO(144, 205, 240, 100),
              child: 
              Stack(children: <Widget>[
                
                Row(
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



                            return FutureBuilder(
                    
                                  future: getClothingName(path1, "none"),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      
                                      // Get the list of types and convert it to a list of strings
                                      print("data solo = " + snapshot.data.toString());

                                      print("pleaseeeeeeee = " + snapshot.data[0]);
                                      List types = snapshot.data.split(",");
                                      print("1 after" + types.toString());
                                      
                                      for (int i = 0; i < types.length; i ++) {
                                        if (types[i][0] == "[") {
                                          print("yes");
                                          types[i] = types[i].toString().substring(1);
                                        } 

                                        if (types[i][types[i].length-1] == "]") {
                                          types[i] = types[i].toString().substring(0, types[i].length-1);
                                        }
                                      }


                                      // If the item is in the selected closet, display
                                      for (var i in types) {
                                        print("current shirt new = " + shirts.toString());
                                        print("current list = " + currentList.toString());
                                        if (currentList.contains(i) | currentList.contains("null")) {
                                          print("containes");
                                          Column card1 = new Column(children: <Widget>[card(path1, types[0])] );

                                          List cards = [card1];
                                          return Container(child: getRow(cards), width: MediaQuery.of(context).size.width);
                                        } 
                                      } 



                                      return Opacity(opacity: 0,);

                                      

                                      //return Text(snapshot.data);
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  }
                                );
                          } else {
                            String path1 = getPath(usedIndex);
                            String path2 = getPath(usedIndex+1);
                            List cards = new List();
                            return FutureBuilder(
                                  future: getClothingName(path1, path2),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (snapshot.hasData) {
                                      
                                      print("data duo = " + snapshot.data.toString());
                                      
                                      print("pleaseeeeeeee = " + snapshot.data[0]);
                                      // types is all possible things that the AI thinks the image can be 
                                      List types = snapshot.data[0].split(",");
                                      print("1 after" + types.toString());
                                      
                                      for (int i = 0; i < types.length; i ++) {
                                        if (types[i][0] == "[") {
                                          print("yes");
                                          types[i] = types[i].toString().substring(1);
                                        } 

                                        if (types[i][types[i].length-1] == "]") {
                                          types[i] = types[i].toString().substring(0, types[i].length-1);
                                        }
                                        
                                      print("2 after = " + types.toString());
                                      }
                                      
                                      //Do the logic for closet selection

                                      print("types 1 = " + types.toString());                        
                                      for (var i in types) {
                                        print("current shirt new = " + shirts.toString());
                                        print("current list = " + currentList.toString());
                                        if (currentList.contains(i) | currentList.contains("null")) {
                                          print("containes");

                                          Column cardd = card(path1, types[0]);
                                          print("please do not be null");
                                          Column card1 = new Column(children: <Widget>[cardd]);
                                          cards.add(card1);
                                          break;
                                        } 
                                      } 
                                      

                                      //End 

                                      //Column cardd = card(path1, types[0]);
                                      //print("please do not be null");
                                      //Column card1 = new Column(children: <Widget>[cardd]);
                                      

                                      print("pleaseeeeeeee = " + snapshot.data[1]);
                                      List types2 = snapshot.data[1].split(",");
                                      print("1 after" + types2.toString());
                                      
                                      for (int i = 0; i < types2.length; i ++) {
                                        if (types2[i][0] == "[") {
                                          print("yes");
                                          types2[i] = types2[i].toString().substring(1);
                                        } 

                                        if (types2[i][types2[i].length-1] == "]") {
                                          types2[i] = types2[i].toString().substring(0, types2[i].length-1);
                                        }

                                      // Do logic for closet selection

                                      print("types 2 = " + types2.toString());                        
                                      for (var i in types2) {
                                        print("current shirt new = " + shirts.toString());
                                        print("current list = " + currentList.toString());
                                        if (currentList.contains(i) | currentList.contains("null")) {
                                          print("containes");

                                          Column card2 = card(path2, types2[1]);
                                          cards.add(card2);
                                          break;
                                        } 
                                      } 


                                      // End
                                        
                                      print("2 after = " + types2.toString());

                                      }
                                      //Column card2 = card(path2, types2[1]);
                                      //cards.add(card1);
                                      //cards.add(card2);
                                      //Widget container = new Container(child: getRow(cards), width: MediaQuery.of(context).size.width);
                                      return Container (child: Stack(children: <Widget>[getRow(cards)],), width: MediaQuery.of(context).size.width, );
                                      //return Text(snapshot.data);
                                    } else {
                                      return CircularProgressIndicator();
                                    }
                                  }
                                );
                          }

                        }, scrollDirection: Axis.horizontal,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      }, 
                      itemCount: (file.length/2).ceil()),
                  )
                ],
              ),
            
              ],)
              
            ),
    );
  }

  Widget build(BuildContext context) {
    print("building again");
    return main();
    
  }

  


}