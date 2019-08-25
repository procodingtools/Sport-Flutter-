import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:phoenix_club/utils/dialogs/dialog_body.dart';

typedef ReserveCoach(String startDate, String Duration);

class Dialogs{

  BuildContext context;

  Dialogs(this.context);

  void showErrorDialog(String s) {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBody.createWithTitle(
              title: "Error",
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 50.0,
                  ),
                  Container(
                    height: 10.0,
                  ),
                  Text(
                    "$s",
                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              cancellable: true);
        });//.whenComplete(() => Navigator.pop(context));
  }


  void showSuccessDialog(String s) {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBody.createWithTitle(
              title: "Success",
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.check_circle,
                    color: Colors.lightGreen,
                    size: 50.0,
                  ),
                  Container(
                    height: 10.0,
                  ),
                  Text(
                    "$s",
                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              cancellable: true);
        });//.whenComplete(() => Navigator.pop(context));
  }

  void showAlertDialog(String s) {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBody.createWithTitle(
              title: "Alert!",
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.error,
                    color: Colors.yellow,
                    size: 50.0,
                  ),
                  Container(
                    height: 10.0,
                  ),
                  Text(
                    "$s",
                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              cancellable: true);
        });//.whenComplete(() => Navigator.pop(context));
  }

  void showCoachDisponibilityAlertDialogList(String s, List<dynamic> dispo, ReserveCoach func) {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBody.createWithTitle(
              title: "Alert!",
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.error,
                    color: Colors.yellow,
                    size: 50.0,
                  ),
                  Container(
                    height: 10.0,
                  ),
                  Text(
                    "$s",
                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                    textAlign: TextAlign.center,
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    height: 100,
                      child: ListView.builder(itemBuilder: (context, index){
                    String startTime = dispo[index]["TempDebut"].toString();
                    String endTime = dispo[index]["TempFin"].toString();
                    DateTime date = DateTime.parse(dispo[index]['DateDisponibilite']);
                    return ListTile(

                      onTap: (){
                        DateTime dateToSend = date.add(Duration(hours: int.parse(startTime.split(':')[0]), minutes: int.parse(startTime.split(':')[1])));
                        final st = date.add(Duration(hours: int.parse(startTime.split(':')[0]),minutes: int.parse(startTime.split(':')[1])));
                        final et = date.add(Duration(hours: int.parse(endTime.split(':')[0]),minutes: int.parse(endTime.split(':')[1])));
                        func(formatDate(dateToSend, [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]), (et.difference(st).inMinutes/60).toString().replaceAll('.', ','));
                        Navigator.pop(context);
                      },
                      //padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                      title: Text("De ${startTime.substring(0, startTime.lastIndexOf(':'))} à ${endTime.substring(0, endTime.lastIndexOf(':'))}"),

                    );
                  },
                  itemCount: dispo.length,)
                  )
                ],
              ),
              cancellable: true);
        });//.whenComplete(() => Navigator.pop(context));
  }
}