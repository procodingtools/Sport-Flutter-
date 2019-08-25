

class ReservationEntity{
  int _scId;
  int _reservationId;

  int get reservationId => _reservationId;

  set reservationId(int value) {
    _reservationId = value;
  }

  DateTime _reservDate;
  String _activityName;
  DateTime _startDate;
  DateTime _scDate;
  String start;
  String end;
  String _coach;
  bool _toRemove;


  ReservationEntity({dynamic data}){
    if(data != null) {
      _scId = data["IdSeance"];
      _reservationId = data['Id'];
      final _resDate = data["DateReservation"].split("T")[0];
      _reservDate = DateTime(int.parse(_resDate.split("-")[0]), int.parse(_resDate.split("-")[1]), int.parse(_resDate.split("-")[2]));
      _activityName = data["Libelle"];
      _activityName = _activityName.trim();
      final _scDateStr = data["Date"].split("T")[0];
      _scDate = DateTime(int.parse(_scDateStr.split("-")[0]), int.parse(_scDateStr.split("-")[1]), int.parse(_scDateStr.split("-")[2]));
      start = data["TempDebut"].toString().substring(0,data["TempDebut"].toString().lastIndexOf(":"));
      end = data["TempFin"].toString().substring(0,data["TempFin"].toString().lastIndexOf(":"));
      _startDate = DateTime(int.parse(_scDateStr.split("-")[0]), int.parse(_scDateStr.split("-")[1]), int.parse(_scDateStr.split("-")[2]),
          int.parse(start.split(':')[0]), int.parse(start.split(':')[1]));
      _coach = "";
      _toRemove = false;
    }
  }


  DateTime get startDate => _startDate;

  set startDate(DateTime value) {
    _startDate = value;
  }

  bool get toRemove => _toRemove;

  set toRemove(bool value) {
    _toRemove = value;
  }

  int get scId => _scId;

  set scId(int value) {
    _scId = value;
  }

  DateTime get reservDate => _reservDate;

  String get coach => _coach;

  set coach(String value) {
    _coach = value;
  }

  DateTime get scDate => _scDate;

  set scDate(DateTime value) {

    _scDate = value;
  }

  String get courseName => _activityName;

  set courseName(String value) {
    _activityName = value;
  }

  set   reservDate(DateTime value) {
    _reservDate = value;
  }

  String get activityName => _activityName;

  set activityName(String value) {
    _activityName = value;
  }

}