import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoenix_club/home/views/home_screen.dart';
import 'package:phoenix_club/planning/views/planning_screen.dart';
import 'package:phoenix_club/utils/res/colors.dart';


void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  String title = "Phoenix Club";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: this.title,
      color: MyColors.secondaryColor,
      initialRoute: '/',
      routes: {
        '/' : (context) => HomeScreen(),
        '/planning' : (context) => PlanningScreen(),
      },
    );
  }
}

