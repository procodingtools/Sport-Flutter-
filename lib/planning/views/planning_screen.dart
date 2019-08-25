import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:phoenix_club/home/views/home_screen.dart';
import 'package:phoenix_club/login/views/login_screen.dart';
import 'package:phoenix_club/planning/entity/planning_entity.dart';
import 'package:phoenix_club/planning/planning_webservice.dart';
import 'package:phoenix_club/utils/attribs.dart';
import 'package:phoenix_club/utils/color_parse.dart';
import 'package:phoenix_club/utils/dialogs/dialogs.dart';
import 'package:phoenix_club/utils/dialogs/reservation_dialog.dart';
import 'package:phoenix_club/utils/entities/coachs/coach_reservation_entity.dart';
import 'package:phoenix_club/utils/entities/user_entity.dart';
import 'package:phoenix_club/utils/fade_router.dart';
import 'package:phoenix_club/utils/horizontal_calendar/flutter_calendar.dart';
import 'package:phoenix_club/utils/res/colors.dart';
import 'package:phoenix_club/utils/res/strings.dart';
import 'package:phoenix_club/utils/webservice/coach_webservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlanningScreen extends StatefulWidget {
  @override
  _PlanningState createState() => _PlanningState();
}

class _PlanningState extends State<PlanningScreen> {
  bool _isFetching = true;
  List<dynamic> _events = List();
  List<dynamic> _dateEvents = List();
  //List<dynamic> _toRemove = List();
  final _webservice = PlanningWebService();
  final _coachsWebService = CoachWebService();
  final _width = Attributes.SCREEN_WIDTH;
  final _height = Attributes.SCREEN_HEIGHT;
  UserEntity _user = null;
  DateTime now;

  @override
  void initState() {
    now = DateTime.now();
    SharedPreferences.getInstance().then((_value) {
      String _usr = _value.getString("user");
      if (_usr != null) {
        _user = UserEntity(data: jsonDecode(_usr));
      }
      startFetching();
    });
  }

  startFetching() {
    _events.clear();
    //_toRemove.clear();
    _webservice.fetch().then((list) {
      if (list != null) {
        _events.addAll(list);
        for (PlanningEntity entity in _events) {
          //DateTime now = DateTime.now();
          if (entity.date.year == now.year &&
              entity.date.month == now.month &&
              entity.date.day == now.day &&
              !_dateEvents.contains(entity)) _dateEvents.add(entity);
        }

        if (_user != null)
          //getting coaches
          getCoachs();
        else
          setState(() {
            _isFetching = false;
          });
      } else {
        setState(() {
          _isFetching = false;
        });
        Dialogs(context).showErrorDialog(Strings.ERROR_CONNEXION);
      }
    });
  }

  getCoachs() {
    _coachsWebService.getReservedCoaches().then((_coachs) {
      if (_coachs != null) {
        _events.addAll(_coachs);
        for (CoachReservationEntity entity in _coachs)
          if (entity.startDate.year == now.year &&
              entity.startDate.month == now.month &&
              entity.startDate.day == now.day &&
              !_dateEvents.contains(entity)) _dateEvents.add(entity);

      }
      setState(() {
        _isFetching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${Strings.PLANNING}"),
        backgroundColor: Colors.white12,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Calendar(
            isExpandable: false,
            onDateSelected: (date) {
              onDateSelected(date);
            },
          ),
          _buildList(),
          _buildKeysBar(),
        ],
      ),
    );
  }

  Widget _loadingWidget() {
    return Center(
        child: SpinKitCubeGrid(
      color: Colors.white.withOpacity(0.8),
      size: _width * 0.15,
    ));
  }

  Widget _buildList() {
    return Expanded(
      child: _isFetching
          ? _loadingWidget()
          : ListView.builder(
              itemBuilder: (context, index) {
                /*if (_dateEvents[index] is CoachReservationEntity &&
                    _toRemove.contains(_dateEvents[index])) return Container();*/

                if (_dateEvents[index] is CoachReservationEntity && _dateEvents[index].toRemove)
                  return Container();

                if (_dateEvents[index].startDate.isBefore(DateTime.now()))
                  return _listContent(index, false);

                return Container(
                  color: Colors.white10,
                  child: Slidable(
                    delegate: SlidableStrechDelegate(),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: _btnCaption(_dateEvents[index]),
                        color: _btnColor(_dateEvents[index]),
                        icon: _btnIcon(_dateEvents[index]),
                        onTap: () {
                          _manageOnTap(_dateEvents[index], context);
                        },
                      )
                    ],
                    child: _listContent(index, true),
                  ),
                );
              },
              itemCount: _dateEvents.length,
            ),
    );
  }

  Widget _listContent(int index, bool isSlidable) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: _height * 0.02),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              //TODO: show event nature icon (coach or activity)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: _width * 0.02),
                child: Icon(
                  _dateEvents[index] is PlanningEntity
                      ? Icons.swap_calls
                      : Icons.person,
                  color: Colors.white70,
                ),
              ),

              //TODO: show timing
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _dateEvents[index] is PlanningEntity
                        ? _dateEvents[index].label.trim()
                        : _dateEvents[index].name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: _width * 0.05,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    height: _height * 0.01,
                  ),
                  Text(
                    _dateEvents[index] is PlanningEntity
                        ? "${_dateEvents[index].start} à ${_dateEvents[index].end}"
                        : "${formatDate(_dateEvents[index].startDate, [
                            dd,
                            "/",
                            mm,
                            "/",
                            yyyy,
                            " Durée ",
                            HH,
                            ':',
                            nn,
                            ' h'
                          ])}",
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: _dateEvents[index] is PlanningEntity
                            ? _width * 0.045
                            : _width * .04),
                  )
                ],
              ),

              //TODO: show x/capacity
              _dateEvents[index] is PlanningEntity
                  ? Expanded(
                      child: Center(
                          child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${_dateEvents[index].nbReservations}/${_dateEvents[index].capcity}",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                        Container(
                          height: _height * 0.01,
                        ),
                        Text(
                            "${_dateEvents[index].coachName} ${_dateEvents[index].coachLastName.trim()}",
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: _width * 0.025)),
                      ],
                    )))
                  : Expanded(child: Container()),

              //TODO: show status indicator and slidable indicator
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 15.0,
                    height: 15.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _indicatorColor(_dateEvents[index]),
                    ),
                  ),
                  Container(
                    width: _width * 0.05,
                  ),
                  isSlidable
                      ? Transform(
                          transform: Matrix4.rotationZ(1.5708),
                          child: Icon(
                            Icons.drag_handle,
                            size: 20.0,
                            color: Colors.white70,
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),

        //TODO: showing divider
        Divider(
          color: Colors.white,
          height: 1.0,
        ),
      ],
    );
  }

  _manageOnTap(dynamic event, BuildContext cxt) {
    if (_user != null) {
      if (event is PlanningEntity) {
        if (/*!_toRemove.contains(event)*/ !event.toRemove) {
          if (event.isReserved) {
            Scaffold.of(cxt)
                .hideCurrentSnackBar(reason: SnackBarClosedReason.hide);
            _showSnackBar(
                reservation: event, name: event.label, context: cxt);
            setState(() {
              //if (!_toRemove.contains(event)) _toRemove.add(event);
              event.toRemove = true;
            });
          } else {
            _webservice.reserve(event.idSc, action: true).then((status) {
              if (status == null)
                Dialogs(cxt).showErrorDialog(Strings.ERROR_CONNEXION);
              else
                setState(() {
                  event.status = status['Etat'];
                  event.isReserved = true;
                  if (status['Etat'] == 0) {
                    Dialogs(context).showAlertDialog(Strings.WAITING_LIST);
                  } else {
                    event.nbReservations += 1;
                    //event.idSc = status['Id'];
                  }
                });
            });
          }
        } else {
          Scaffold.of(cxt)
              .hideCurrentSnackBar(reason: SnackBarClosedReason.hide);
          setState(() {
            //_toRemove.remove(event);
            event.toRemove = false;
          });
        }
      } else if (event is CoachReservationEntity) {
        Scaffold.of(cxt).hideCurrentSnackBar(reason: SnackBarClosedReason.hide);
        _showSnackBar(reservation: event, name: event.name, context: cxt);
        setState(() {
          //if (!_toRemove.contains(event)) _toRemove.add(event);
          event.toRemove = true;
        });
      }
    } else
      Navigator.push(cxt, FadeRoute(builder: (context) => LoginScreen()));
  }

  Widget _buildKeysBar() {
    return Container(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 5.0),
                  width: 15.0,
                  height: 15.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                ),
                Text(
                  "${Strings.CAN_RESERVE}",
                  style:
                      TextStyle(color: Colors.white54, fontSize: _width * .03),
                ),
              ],
            ),
          ),
          Expanded(child: Container()),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 5.0),
                width: 15.0,
                height: 15.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent,
                ),
              ),
              Text(
                "${Strings.CANT_RESERVE}",
                style: TextStyle(color: Colors.white54, fontSize: _width * .03),
              ),
            ],
          ),
          Expanded(child: Container()),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 5.0),
                width: 15.0,
                height: 15.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent,
                ),
              ),
              Text(
                "${Strings.RESERVED}",
                style: TextStyle(color: Colors.white54, fontSize: _width * .03),
              ),
            ],
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 5.0),
                  width: 15.0,
                  height: 15.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orangeAccent,
                  ),
                ),
                Text(
                  "${Strings.WAITING}",
                  style:
                      TextStyle(color: Colors.white54, fontSize: _width * .03),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onDateSelected(DateTime date) {
    _dateEvents.clear();
    now = date;
    for (dynamic entity in _events) {
      if (entity is PlanningEntity) {
        if (entity.date.year == date.year &&
            entity.date.month == date.month &&
            entity.date.day == date.day &&
            !_dateEvents.contains(entity)) _dateEvents.add(entity);
      } else if (entity.startDate.year == date.year &&
          entity.startDate.month == date.month &&
          entity.startDate.day == date.day &&
          !_dateEvents.contains(entity)) _dateEvents.add(entity);

      setState(() {});
    }
  }

  String _btnCaption(dynamic event) {
    if (_user == null) return Strings.LOGIN;

    if (event is CoachReservationEntity) return 'Supprimer';

    if (event.toRemove) return Strings.ABORT;

    if (event.isReserved) return "Supprimer";

    return "Reserver";
  }

  Color _btnColor(dynamic event) {
    if (_user == null) return MyColors.secondaryColor;

    if (event is CoachReservationEntity) return Colors.red;

    if (event.toRemove) return Colors.orangeAccent;

    if (event.isReserved) return Colors.red;

    return Colors.blueAccent;
  }

  IconData _btnIcon(dynamic event) {
    if (_user == null) return Icons.person;

    if (event is CoachReservationEntity) return Icons.delete;

    if (event.toRemove) return Icons.close;

    if (event.isReserved) return Icons.delete;

    return Icons.archive;
  }

  Color _indicatorColor(dynamic event) {
    if (event is CoachReservationEntity) return Colors.blueAccent;

    if (event.status == 0 && event.isReserved) return Colors.orange;

    if (event.isReserved) return Colors.blueAccent;

    if (event.nbReservations >= event.capcity) return Colors.redAccent;

    return Colors.green;
  }

  void _showSnackBar(
      {dynamic reservation, String name, BuildContext context}) {
    /*dynamic reservation;
    for (dynamic e in _events)
      if (e == tmpReservation) {
        reservation = e;
        print('true');
        break;
      }*/

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Container(
        //height: _height * 0.05,
        child: Text(
          "Votre reservation de $name a été supprimé",
          maxLines: 2,
          softWrap: true,
          style: TextStyle(
              color: Color(ColorParse.getColorHexFromStr("d9d9db"))),
        ),
      ),
      duration: Duration(seconds: 3),
      action: SnackBarAction(label: 'Annuler', onPressed: () {
        setState(() {
          reservation.toRemove = false;
        });
      },
      textColor: Colors.orangeAccent,),
    ));

    removeReservation(reservation);
  }

  Future removeReservation(dynamic reservation) async {
    await Future.delayed(Duration(seconds: 3));

    if (reservation.toRemove){
      if (reservation is PlanningEntity)
        _webservice.reserve(reservation.idSc, action: false).then((action) {
          if (action == null)
            Dialogs(context).showErrorDialog(Strings.ERROR_CONNEXION);
          else if (action == false)
            Dialogs(context).showErrorDialog(Strings.ST_WENT_WRONG);
          else
            setState(() {
              /*if (item.status == 0)
                HomeScreen.firebaseMessaging.unsubscribeFromTopic(item.idSc.toString());*/
              reservation.isReserved = false;
              if (reservation.status != 0)
                reservation.nbReservations -= 1;
              reservation.toRemove = false;
            });
        });
      else if (reservation is CoachReservationEntity)
        _coachsWebService.deleteReservation(reservation.id).then((action) {
          if (action == null || action == false) {
            Dialogs(context).showErrorDialog(Strings.ERROR_CONNEXION);
            setState(() {
              //_events.remove(item);
              reservation.toRemove = false;
            });
          } else
            setState(() {
              reservation.toRemove = false;
              if (_dateEvents.contains(reservation)) _dateEvents.remove(
                  reservation);
              _events.remove(reservation);
              //_toRemove.remove(item);
            });
        });
    }
  }

}
