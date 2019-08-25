import 'package:flutter/material.dart';
import 'package:phoenix_club/activities_list/entity/acivity_entity.dart';
import 'package:phoenix_club/utils/attribs.dart';
import 'package:phoenix_club/utils/res/colors.dart';

class ActivityDialog {
  static double _width = Attributes.SCREEN_WIDTH;
  static double _height = Attributes.SCREEN_HEIGHT;

  static void show(BuildContext context, ActivityEntity activity) {
    String _courseName = activity.label;
    String _coursePeriod = activity.description;
    showDialog(
      context: context,
      builder: (context) => Center(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: LinearGradient(
                      colors: [MyColors.secondaryColor, MyColors.primaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight)),
              width: _width * 0.9,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Material(
                        type: MaterialType.transparency,
                        child: Text("$_courseName",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: _width * 0.05))),
                  ),
                  Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(
                          left: _width * 0.02,
                          right: _width * 0.02,
                          bottom: _height * 0.01),
                      width: _width * 0.86,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white),
                      child: Material(
                        type: MaterialType.transparency,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            Text(
                              "Période : $_coursePeriod",
                              style: TextStyle(fontSize: _width * 0.05),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
    );
  }
}
