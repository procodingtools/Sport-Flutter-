import 'package:flutter/material.dart';
import 'package:phoenix_club/utils/attribs.dart';
import 'package:phoenix_club/utils/res/colors.dart';

class ProgressDialog{
  BuildContext context;
  bool _isFinished = false;

  ProgressDialog({@required this.context});

  void show({String text}){
    showDialog(context: context, builder: (context){
      double _width = Attributes.SCREEN_WIDTH;
      double _height = Attributes.SCREEN_HEIGHT;
      return  Material(
          type: MaterialType.transparency,
          child: WillPopScope(
            onWillPop: (){
              if (_isFinished)
                Navigator.pop(context);
            },
            child: Center(
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), gradient: LinearGradient(colors: [MyColors.secondaryColor, MyColors.primaryColor], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                padding: EdgeInsets.all(7.0),
                child: Container(
                  width: _width*0.7,
                  height: _height*0.2,
                  decoration: BoxDecoration(color: Colors.white.withAlpha(230), borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),),
                      Container(height: _height*0.05,),
                      Text(text != null ? "$text" : "Please wait...", style: TextStyle(color: Colors.black, fontSize: _width*0.05),)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
    });
  }

  void hide(){
    _isFinished = true;
    Navigator.of(context).pop();
  }
}