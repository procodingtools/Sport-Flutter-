import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:phoenix_club/utils/entities/coachs/coach_entity.dart';
import 'package:phoenix_club/utils/entities/coachs/coach_reservation_entity.dart';
import 'package:phoenix_club/reservations/entity/reservation_entity.dart';
import 'package:phoenix_club/utils/webservice/coach_webservice.dart';
import 'package:phoenix_club/reservations/webservice/reservations_webservice.dart';
import 'package:phoenix_club/utils/attribs.dart';
import 'package:phoenix_club/utils/color_parse.dart';
import 'package:phoenix_club/utils/dialogs/dialogs.dart';
import 'package:phoenix_club/utils/horizontal_calendar/flutter_calendar.dart';
import 'package:phoenix_club/utils/res/strings.dart';

final _width = Attributes.SCREEN_WIDTH;
final _height = Attributes.SCREEN_HEIGHT;

typedef fabCallback(Color backColor, Color iconColor, IconData fabIcon,
    int coachId, String startDate, String duration, String name);

class ReservationsScreen extends StatefulWidget {
  _ReservationsState createState() => _ReservationsState();
}

class _ReservationsState extends State<ReservationsScreen> {
  List<dynamic> _data = List();
  List<dynamic> _thisDateReservations = List();
  ReservationWebService _webService = ReservationWebService();
  DateTime _now = DateTime.now();

  bool _isfetching = true, _isFetchingCoaches = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  VoidCallback _showBottomSheetCallback;
  IconData _fabIcon = Icons.add;
  Color _fabBack = Colors.white70;
  Color _fabIconColor = Colors.black87;
  bool _toClose = true;
  final now = DateTime.now();
  CoachWebService _coachWebService;
  List<CoachEntity> _coaches;
  List<ReservationEntity> _reservations;
  List<CoachReservationEntity> _reservedCoachs;
  int _coachId;
  String _coachName;
  String _startDate;
  String _duration;
  bool _isRequestionCoachReservation = false, _toCoachReserve = false;

  fabCallback(Color backColor, Color iconColor, IconData fabIcon, int coachId,
      String startDate, String duration, String name) {
    setState(() {
      _fabIcon = fabIcon;
      _fabIconColor = iconColor;
      _fabBack = backColor;
      _coachId = coachId;
      _duration = duration;
      _startDate = startDate;
      _toCoachReserve = true;
      _coachName = name;
    });
  }

  @override
  void initState() {
    super.initState();
    _coachWebService = CoachWebService();

    _showBottomSheetCallback = _showBottomSheet;
    _webService.get(context).then((_fetchedData) {
      if (_fetchedData != null) {
        _reservations = _fetchedData;
        _data.addAll(_fetchedData);
        for (int i = 0; i < _data.length; i++) {
          if (DateFormat("dd/MM/yyyy").format(_now) ==
              DateFormat("dd/MM/yyyy").format(_data[i] is ReservationEntity
                  ? _data[i].scDate
                  : _data[i].startDate)) {
            if (!_thisDateReservations.contains(_data[i]))
              _thisDateReservations.add(_data[i]);
          }
        }

        //TODO: start getting coachs
        _getCoaches();
      } else
        setState(() {
          Dialogs(context).showErrorDialog(Strings.ERROR_CONNEXION);
          _isfetching = false;
        });
    });
  }

  _getCoaches() {
    _coachWebService.getCoaches().then((list) {
      if (list == null)
        Dialogs(context).showErrorDialog(Strings.ERROR_CONNEXION);
      else
        _coaches = list;

      _coachWebService.getReservedCoaches().then((list) {
        setState(() {
          _reservedCoachs = list;
          if (list != null) {
            _data.addAll(list);
            for (int i = 0; i < _data.length; i++) {
              if (DateFormat("dd/MM/yyyy").format(_now) ==
                  DateFormat("dd/MM/yyyy").format(_data[i] is ReservationEntity
                      ? _data[i].scDate
                      : _data[i].startDate)) {
                if (!_thisDateReservations.contains(_data[i]))
                  _thisDateReservations.add(_data[i]);
              }
            }
          } else {}
          _isfetching = false;
          if (_data.isEmpty)
            Dialogs(context).showAlertDialog(Strings.NO_RESERVATIONS);
        });
      });
    });
  }

  void _showBottomSheet() {
    setState(() {
      // disable the button
      _showBottomSheetCallback = null;
      _fabBack = Colors.red;
      _fabIcon = Icons.close;
      _fabIconColor = Colors.white;
    });
    _scaffoldKey.currentState
        .showBottomSheet<void>((BuildContext context) {
          return _CoachBottomSheet(
              coaches: _coaches,
              coachsWebService: _coachWebService,
              callback: fabCallback);
        })
        .closed
        .whenComplete(() {
          if (mounted && _toClose) {
            setState(() {
              // re-enable the button
              _showBottomSheetCallback = _showBottomSheet;
              _fabIcon = Icons.add;
              _fabIconColor = Colors.black87;
              _fabBack = Colors.white70;
            });
          }
          _toClose = true;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!_isfetching || !_isRequestionCoachReservation) {
            if (_coaches == null)
              Dialogs(context).showErrorDialog(Strings.COACHES_NOT_FOUND);
            else {
              if (_showBottomSheetCallback != null) {
                if (_fabBack == Colors.white70) {
                  setState(() => _toCoachReserve = false);
                  _showBottomSheetCallback();
                }
              } else {
                Navigator.pop(context);
              }

              if (_toCoachReserve) {
                setState(() {
                  _isRequestionCoachReservation = true;
                });
                _reserveCoach(_startDate, _duration);
              }
            }
          }
        },
        child: _isRequestionCoachReservation
            ? SizedBox(
                height: _width * .03,
                width: _width * .03,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.black87),
                    strokeWidth: 1.0,
                  ),
                ),
              )
            : Icon(
                _fabIcon,
                color: _fabIconColor,
              ),
        backgroundColor: _fabBack,
        elevation: 5.0,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white12,
        title: Text("${Strings.RESERVATIONS}"),
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Calendar(
            isExpandable: false,
            onDateSelected: (date) {
              _now = date;
              _onDateChanged(date);
            },
          ),
          Container(
            height: 20.0,
          ),
          Expanded(
            child: _isfetching
                ? _loadingWidget()
                : ListView.builder(
                    itemBuilder: (context, index) {
                      String _label =
                          _thisDateReservations[index] is ReservationEntity
                              ? _thisDateReservations[index].courseName
                              : _thisDateReservations[index].name;
                      String _reservDate = DateFormat('dd/MM/yyyy').format(
                          _thisDateReservations[index] is ReservationEntity
                              ? _thisDateReservations[index].reservDate
                              : _thisDateReservations[index].startDate);
                      String start =
                          _thisDateReservations[index] is ReservationEntity
                              ? _thisDateReservations[index].start
                              : formatDate(
                                  _thisDateReservations[index].startDate,
                                  [HH, ':', nn]);
                      String end =
                          _thisDateReservations[index] is ReservationEntity
                              ? _thisDateReservations[index].end
                              : formatDate(_thisDateReservations[index].endTime,
                                  [HH, ':', nn]);
                      if (_thisDateReservations[index].toRemove)
                        return Container();

                      if (_thisDateReservations[index]
                          .startDate
                          .isBefore(DateTime.now()))
                        return _cardListRow(
                            _label,
                            _reservDate,
                            _thisDateReservations[index] is ReservationEntity
                                ? _thisDateReservations[index].scId.toString()
                                : _thisDateReservations[index].id.toString(),
                            start,
                            end,
                            _thisDateReservations[index] is ReservationEntity,
                            false);

                      return Slidable(
                        delegate: SlidableStrechDelegate(),
                        actionExtentRatio: 0.25,
                        child: _cardListRow(
                            _label,
                            _reservDate,
                            _thisDateReservations[index] is ReservationEntity
                                ? _thisDateReservations[index].scId.toString()
                                : _thisDateReservations[index].id.toString(),
                            start,
                            end,
                            _thisDateReservations[index] is ReservationEntity,
                            true),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: "Supprimer",
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              Scaffold.of(context).hideCurrentSnackBar(
                                  reason: SnackBarClosedReason.hide);
                              _showSnackBar(
                                  session: _thisDateReservations[index],
                                  name: _label,
                                  context: context);
                              setState(() {
                                _thisDateReservations[index].toRemove = true;
                              });
                            },
                          )
                        ],
                      );
                    },
                    itemCount: _thisDateReservations.length,
                  ),
          ),
        ],
      ),
    );
  }

  void _onDateChanged(DateTime date) {
    _thisDateReservations.clear();
    for (int i = 0; i < _data.length; i++) {
      if (DateFormat("dd/MM/yyyy").format(date) ==
          DateFormat("dd/MM/yyyy").format(_data[i] is ReservationEntity
              ? _data[i].scDate
              : _data[i].startDate)) {
        if (!_thisDateReservations.contains(_data[i]))
          _thisDateReservations.add(_data[i]);
      }
    }
    setState(() {});
  }

  Widget _cardListRow(String _label, String _reservDate, String _id,
      String start, String end, bool isActivity, bool isSlidable) {
    return Column(
      children: <Widget>[
        Container(
          height: 80.0,
          width: _width,
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: _width * .02),
                  child: Icon(
                    isActivity ? Icons.swap_calls : Icons.person,
                    color: Colors.white70,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                          child: AutoSizeText(
                        _label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        maxFontSize: _width * 0.055,
                        style: TextStyle(
                            fontSize: _width * 0.055, color: Colors.white),
                      )),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Text("Réservé le $_reservDate",
                            style: TextStyle(
                                fontSize: _width * 0.025, color: Colors.white)),
                      )
                    ],
                  ),
                ),

                Expanded(
                  child: Center(
                    child: Text(
                      "$start à $end",
                      style: TextStyle(
                          color: Colors.white, fontSize: _width * 0.035),
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: isSlidable
                        ? Transform(
                            transform: Matrix4.rotationZ(1.5708),
                            child: Icon(
                              Icons.drag_handle,
                              size: _width * 0.055,
                              color: Colors.white54,
                            ),
                          )
                        : Container(),
                  ),
                ) //drag icon
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.white,
          height: 1.0,
        ),
      ],
    );
  }

  void _showSnackBar({dynamic session, String name, BuildContext context}) {
    session.toRemove = true;
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Container(
        height: _height * 0.05,
        child: Material(
          child: Text(
            "$name supprimé",
            style: TextStyle(
                color: Color(ColorParse.getColorHexFromStr("d9d9db"))),
          ),
        ),
      ),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: "Annuler",
        onPressed: () {
          session.toRemove = false;
          Scaffold.of(context)
              .hideCurrentSnackBar(reason: SnackBarClosedReason.hide);
          setState(() {
            session.toRemove = false;
            _onDateChanged(_now);
          });
        },
        textColor: Colors.orange,
      ),
    ));

    removeReservation(session);
  }

  Future removeReservation(dynamic item) async {
    await Future.delayed(Duration(milliseconds: 3000));

    if (item.toRemove) {
      if (item is ReservationEntity)
        _webService
            .remove(context, reservationId: item.reservationId, scId: item.scId)
            .then((b) {
          if (b != null) {
            if (b)
              setState(() {
                _data.remove(item);
                _thisDateReservations.remove(item);
              });
            else
              setState(() {
                item.toRemove = false;
                _onDateChanged(_now);
              });
          } else
            setState(() {
              item.toRemove = false;
              _onDateChanged(_now);
            });
        });
      else
        CoachWebService().deleteReservation(item.id).then((b) {
          if (b != null) {
            if (b)
              setState(() {
                _data.remove(item);
                _thisDateReservations.remove(item);
              });
            else
              setState(() {
                item.toRomove = false;
                _onDateChanged(_now);
              });
          } else
            setState(() {
              item.toRemove = false;
              _onDateChanged(_now);
            });
        });
    }
  }

  Widget _loadingWidget() {
    return Center(
        child: SpinKitCubeGrid(
      color: Colors.white.withOpacity(0.8),
      size: _width * 0.15,
    ));
  }

  _reserveCoach(String startDate, String duration) {
    setState(() {
      _isRequestionCoachReservation = true;
    });

    _coachWebService
        .reserveCoach(_coachId, startDate, duration, _coachName)
        .then((coach) {
      if (coach != null) {
        if (coach is CoachReservationEntity) {
          setState(() {
            Dialogs(context).showSuccessDialog(Strings.SUCCESS_RESERVATION);
            setState(() {
              _data.add(coach);
              _onDateChanged(_now);
            });
          });
        } else {
          if ((coach as List).isNotEmpty)
            Dialogs(context).showCoachDisponibilityAlertDialogList(
                "$_coachName n'est disponible à cet moment\nCe ci les temps des disponibilitées pour le"
                " ${_startDate.split(' ')[0]}",
                coach,
                _reserveCoach);
          else Dialogs(context).showAlertDialog("$_coachName n'est disponible le ${_startDate.split(' ')[0]}");
        }
      } else
        Dialogs(context).showErrorDialog("Reservation Failed");

      setState(() {
        _isRequestionCoachReservation = false;
      });
    });
  }
}

class _CoachBottomSheet extends StatefulWidget {
  final coaches;
  final coachsWebService;
  final fabCallback callback;

  const _CoachBottomSheet(
      {Key key, this.coaches, this.coachsWebService, this.callback})
      : super(key: key);

  _CoachottomSheetState createState() =>
      _CoachottomSheetState(coaches, coachsWebService, callback);
}

class _CoachottomSheetState extends State<_CoachBottomSheet> {
  final List<CoachEntity> _coaches;
  List<String> _coachesNames;
  final CoachWebService _coachWebService;
  final fabCallback callback;

  _CoachottomSheetState(this._coaches, this._coachWebService, this.callback);

  String _coachName = "Choisir un cooach",
      _dispStartDateStr = "Début",
      _startDateStr,
      _durationStr = "Durée";

  String _durationToSend;

  bool _coach = false, _start = false, _end = false;

  int _coachId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _coachesNames = List();
    for (CoachEntity c in _coaches)
      _coachesNames.add("${c.name} ${c.lastName}");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final ThemeData themeData = Theme.of(context);
    return Container(
        width: _width,
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: themeData.disabledColor))),
        child: Padding(
          padding: const EdgeInsets.only(
              bottom: 32.0, left: 32.0, right: 23.0, top: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${Strings.RESERVE_COACH}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                height: 10.0,
              ),
              DropdownButton(
                items: _coachesNames.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (name) {
                  setState(() {
                    _coachName = name;
                    _coach = true;
                    for (int i = 0; i < _coaches.length; i++)
                      if (_coaches[i].name + " " + _coaches[i].lastName ==
                          name) {
                        _coachId = _coaches[i].id;
                        break;
                      }
                    if (_coach && _start && _end) {
                      callback(Colors.lightGreen, Colors.white, Icons.done,
                          _coachId, _startDateStr, _durationToSend, _coachName);
                    }
                  });
                },
                hint: Text(_coachName),
              ),
              Row(
                children: <Widget>[
                  Container(
                      height: _height * 0.05,
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "De: ",
                            style: TextStyle(fontSize: _width * 0.05),
                          ))),
                  Expanded(child: Container()),
                  InkWell(
                      splashColor: Colors.black87,
                      highlightColor: Colors.grey,
                      onTap: () {
                        showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                initialDate: DateTime.now(),
                                lastDate:
                                    DateTime.now().add(Duration(days: 365)))
                            .then((date) {
                          if (date != null) {
                            _showTime(date);
                          }
                        });
                      },
                      child: Container(
                          height: _height * 0.05,
                          child: Center(
                              child: Text(
                            _dispStartDateStr,
                            style: TextStyle(
                                fontSize: _width * 0.05,
                                decoration: TextDecoration.underline,
                                color: Colors.lightBlueAccent),
                          )))),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                      height: _height * 0.05,
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Durée: ",
                            style: TextStyle(fontSize: _width * 0.05),
                          ))),
                  Expanded(child: Container()),
                  DropdownButton(
                    items: <String>[
                      '1 h',
                      '1:30 h',
                      '2 h',
                      '2:30 h',
                      '3 h',
                    ].map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (duration) {
                      switch (duration) {
                        case '1 h':
                          _durationToSend = "1,0";
                          break;
                        case '1:30 h':
                          _durationToSend = "1,5";
                          break;
                        case '2 h':
                          _durationToSend = "2,0";
                          break;
                        case '2:30 h':
                          _durationToSend = "2,5";
                          break;
                        case '3 h':
                          _durationToSend = "3,0";
                          break;
                      }
                      setState(() {
                        _durationStr = duration;
                        _end = true;
                        if (_coach && _start && _end) {
                          callback(
                              Colors.lightGreen,
                              Colors.white,
                              Icons.done,
                              _coachId,
                              _startDateStr,
                              _durationToSend,
                              _coachName);
                        }
                      });
                    },
                    hint: Text(_durationStr),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  _showTime(DateTime date) {
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((time) {
      if (time != null) {
        DateTime selectedTime =
            DateTime(date.year, date.month, date.day, time.hour, time.minute);
        if (selectedTime.isBefore(DateTime.now())) {
          _showTime(date);
          Dialogs(context).showErrorDialog(Strings.SELECT_LESSER_TIME);
        } else
          setState(() {
            DateTime finalDate = DateTime(
                date.year, date.month, date.day, time.hour, time.minute);
            _startDateStr = formatDate(
                finalDate, [yyyy, '/', mm, '/', dd, ' ', HH, ':', nn]);

            _dispStartDateStr = formatDate(
                finalDate, [dd, '/', mm, '/', yyyy, ' à ', HH, ':', nn]);

            _start = true;
            if (_coach && _start && _end) {
              setState(() {
                callback(Colors.lightGreen, Colors.white, Icons.done, _coachId,
                    _startDateStr, _durationToSend, _coachName);
              });
            }
          });
      }
    });
  }
}
