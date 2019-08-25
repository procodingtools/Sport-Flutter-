import 'package:flutter/material.dart';
import 'package:phoenix_club/utils/attribs.dart';
import 'package:phoenix_club/utils/dialogs/dialog_body.dart';
import 'package:phoenix_club/utils/res/strings.dart';

class ReservationDialog {
  BuildContext context;
  String title;
  int id;
  bool delete;
  String text;

  ReservationDialog(
      {@required this.context, @required this.title, @required this.id, @required this.delete, this.text});

  void show() {
    double _width = Attributes.SCREEN_WIDTH;
    double _height = Attributes.SCREEN_HEIGHT;
    showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: DialogBody.createWithTitle(
                  title: title,
                  child: Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text( text != null ?
                            text :
                          Strings.DELETE_RESERVATION,
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                          textAlign: TextAlign.center,
                        ),

                        Container(height: _height*0.03,),

                        Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("${Strings.YES}", style: TextStyle(color: Colors.white),),
                                padding: EdgeInsets.all(10.0),
                                color: Colors.lightGreen,
                              ),

                              Container(width: _width*0.1, ),

                              RaisedButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("${Strings.NO}", style: TextStyle(color: Colors.white)),
                                padding: EdgeInsets.all(10.0),
                                color: Colors.redAccent,
                              ),
                            ],
                          ),
                      ],
                    ),
                  )));
        });
  }
}
