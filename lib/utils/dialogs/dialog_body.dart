import 'package:flutter/material.dart';
import 'package:phoenix_club/utils/res/colors.dart';

class DialogBody {
  static Widget create({@required Widget child, bool cancellable}) {
    cancellable == null ? cancellable = true : cancellable = cancellable;

    Widget _body = Center(
      child: Container(
        margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [MyColors.secondaryColor, MyColors.primaryColor],
                  end: Alignment.bottomRight,
                  begin: Alignment.topLeft),
              borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
              padding: EdgeInsets.all(10.0),
              child: Material(type: MaterialType.transparency, child: child),
            ),
          ),
        ),
    );

    if (!cancellable)
      return Material(
        type: MaterialType.transparency,
        child: _body,
      );
    else
      return _body;
  }

  static Widget createWithTitle(
      {@required String title, @required Widget child, bool cancellable}) {
    cancellable??true;

    Widget _body = Center(
      child: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [MyColors.secondaryColor, MyColors.primaryColor],
                end: Alignment.bottomRight,
                begin: Alignment.topLeft),
            borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "$title",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)),
                  padding: EdgeInsets.all(10.0),
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (!cancellable)
      return Material(
        type: MaterialType.transparency,
        child: _body,
      );
    else
      return _body;
  }
}
