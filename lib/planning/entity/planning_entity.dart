class PlanningEntity {
  int _idSc;
  DateTime _date;
  DateTime _startDate;
  String _label;
  int _capcity = null;
  String _start;
  String _end;
  String _coachName;
  String _coachLastName;
  bool _toRemove;
  int _status;


  PlanningEntity({dynamic data}) {
    if (data != null) {
      Map<String, dynamic> map = data;
      _idSc = map["Id"]; //map["IdSeance"];
      String _dateStr = map["Date"].split("T")[0];
      _date = DateTime(int.parse(_dateStr.split("-")[0]),
          int.parse(_dateStr.split("-")[1]), int.parse(_dateStr.split("-")[2]));

      _startDate = DateTime(int.parse(_dateStr.split("-")[0]),
          int.parse(_dateStr.split("-")[1]), int.parse(_dateStr.split("-")[2]),
          int.parse(map["TempDebut"].toString().split(':')[0]),
          int.parse(map["TempDebut"].toString().split(':')[1]));

      _start = map["TempDebut"].toString().split(':')[0] + ":" +
          map["TempDebut"].toString().split(':')[1];
      _end = map["TempFin"].toString().split(':')[0] + ":" +
          map["TempFin"].toString().split(':')[1];
      _label = map["Libelle"].toString().trim();
      _capcity = map["Capacite"];
      _nbReservations = map["NbReservation"];
      _isReserved = map["IsReserved"] == 0 ? false : true;
      _coachLastName = map['Prenom'];
      _coachName = map['Nom'];
      _toRemove = false;
      _status = map['Etat'];
    }
  }


  int get status => _status;

  set status(int value) {
    _status = value;
  }

  String get coachName => _coachName;

  set coachName(String value) {
    _coachName = value;
  }

  int _nbReservations;
  bool _isReserved;
  bool isRemoving = false;


  DateTime get startDate => _startDate;

  set startDate(DateTime value) {
    _startDate = value;
  }

  String get label => _label;

  set label(String value) {
    _label = value;
  }


  bool get toRemove => _toRemove;

  set toRemove(bool value) {
    _toRemove = value;
  }

  int get nbReservations => _nbReservations;

  set nbReservations(int value) {
    _nbReservations = value;
  }

  int get capcity => _capcity;

  set capcity(int value) {
    _capcity = value;
  }


  DateTime get date => _date;

  set date(DateTime value) {
    _date = value;
  }

  int get idSc => _idSc;

  set idSc(int value) {
    _idSc = value;
  }

  String get start => _start;

  set start(String value) {
    _start = value;
  }

  String get end => _end;

  set end(String value) {
    _end = value;
  }

  bool get isReserved => _isReserved;

  set isReserved(bool value) {
    _isReserved = value;
  }

  String get coachLastName => _coachLastName;

  set coachLastName(String value) {
    _coachLastName = value;
  }

}
