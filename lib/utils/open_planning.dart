import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phoenix_club/planning/views/planning_screen.dart';
import 'package:phoenix_club/utils/attribs.dart';
import 'package:phoenix_club/utils/res/colors.dart';

class OpenPlanning{

  BuildContext context;

  OpenPlanning(this.context){
    getPath();
  }

  void getPath() async {
    double _width = Attributes.SCREEN_WIDTH;
    double _height = Attributes.SCREEN_HEIGHT;
    bool _pop = false;
    showDialog(context: context, builder: (context){
      return WillPopScope(
        onWillPop: () {
          if(_pop)
            Navigator.pop(context);
        },
        child: Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), gradient: LinearGradient(colors: [MyColors.secondaryColor, MyColors.primaryColor], begin: Alignment.topLeft, end: Alignment.bottomRight)),
              padding: EdgeInsets.all(7.0),
              child: Container(
                width: _width*0.7,
                height: _height*0.2,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(MyColors.secondaryColor),),
                    Container(height: _height*0.05,),
                    Text("Please wait...", style: TextStyle(color: Colors.black, fontSize: _width*0.05),)
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });

    String _path = "";
    String dir = (await getApplicationDocumentsDirectory()).path;
    String assets = "assets/calendar";

    dir += "/calendar";
    Directory(dir).create(recursive: true);
    Directory(dir + "/cal").create(recursive: true);

    File index = File("$dir/index.html"),
        calCss = File("$dir/cal/jquery.calendar.min.css"),
        calJs = File("$dir/cal/jquery.calendar.js"),
        jquery = File("$dir/cal/jquery-min.js");

    index.create();
    calCss.create();
    calJs.create();
    jquery.create();

    index.writeAsString(await rootBundle.loadString('$assets/index.html'));
    calCss.writeAsString(await rootBundle.loadString('$assets/cal/jquery.calendar.min.css'));
    calJs.writeAsString(await rootBundle.loadString('$assets/cal/calendar.js'));
    jquery.writeAsString(await rootBundle.loadString('$assets/cal/jquery-min.js'));

    _path = "file://" + dir + "/index.html";
    Attributes.PATH = _path;
    _pop = true;
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => PlanningScreen()));
  }
}