import 'dart:convert';

class CoachReservationEntity{

  int _id;
  DateTime _startDate;
  String _name;
  double _duration;
  DateTime _endTime;
  bool _toRemove;

  CoachReservationEntity({Map<String, dynamic> data}){
    if (data != null){
      _id = data['Id'];
      _startDate = DateTime.parse(data['DateReservation']);
      _duration = data['Duree']+.0;
      _endTime = startDate.add(Duration(hours: int.parse(_duration.toString().split('.')[0]), minutes: int.parse(_duration.toString().split('.')[1])*6));
      _name = utf8.decode(data['Coach'].toString().codeUnits);
      _toRemove = false;
    }
  }


  DateTime get endTime => _endTime;

  set endTime(DateTime value) {
    _endTime = value;
  }

  bool get toRemove => _toRemove;

  set toRemove(bool value) {
    _toRemove = value;
  }

  double get duration => _duration;

  set duration(double value) {
    _duration = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  DateTime get startDate => _startDate;

  set startDate(DateTime value) {
    _startDate = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }


}