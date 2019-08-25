class UserEntity{
  int _id;
  String _name;
  String _lastName;
  String _observation;
  DateTime _birthDay;
  int _age;
  String _sex;
  String _job;
  String _address;
  String _type;
  dynamic _photo;
  String _username;
  DateTime _creationDate;
  List<dynamic> _subscribes;
  List<dynamic> _insurences;
  List<dynamic> _presence;
  List<dynamic> _reservations;
  List<dynamic> _sessions;
  List<dynamic> _spents;
  List<dynamic> _badges;

  UserEntity({Map<String,dynamic> data}){
    _id = data["Id"];
    _name = data["Nom"];
    _lastName = data["Prenom"];
    _observation = data["Observation"];
    String _birthSrt = data["DateNaissance"].toString().split("T")[0];
    _birthDay = DateTime(int.parse(_birthSrt.split("-")[0]), int.parse(_birthSrt.split("-")[1]), int.parse(_birthSrt.split("-")[2]));
    _age = data["Age"];
    _sex = data["Genre"];
    _job = data["Profession"];
    _address = data["Adresse"];
    _type = data["Type"];
    _photo = data["Photo"];
    _username = data["Login"];
    String _creationStr = data["DateCreation"].toString().split("T")[0];
    _creationDate = DateTime(int.parse(_creationStr.split("-")[0]), int.parse(_creationStr.split("-")[1]), int.parse(_creationStr.split("-")[2]));
    _subscribes = data["Abonnement"];
    _insurences = data["Assurance"];
    _presence = data["Presence"];
    _reservations = data["Reservation"];
    _sessions = data["Seance"];
    _spents = data["Depense"];
    _badges = data["Badge"];
  }

  List<dynamic> get badges => _badges;

  set badges(List<dynamic> value) {
    _badges = value;
  }

  List<dynamic> get spents => _spents;

  set spents(List<dynamic> value) {
    _spents = value;
  }

  List<dynamic> get sessions => _sessions;

  set sessions(List<dynamic> value) {
    _sessions = value;
  }

  List<dynamic> get reservations => _reservations;

  set reservations(List<dynamic> value) {
    _reservations = value;
  }

  List<dynamic> get presence => _presence;

  set presence(List<dynamic> value) {
    _presence = value;
  }

  List<double> get insurences => _insurences;

  set insurences(List<double> value) {
    _insurences = value;
  }

  List<dynamic> get subscribes => _subscribes;

  set subscribes(List<dynamic> value) {
    _subscribes = value;
  }

  DateTime get creationDate => _creationDate;

  set creationDate(DateTime value) {
    _creationDate = value;
  }

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  dynamic get photo => _photo;

  set photo(dynamic value) {
    _photo = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get job => _job;

  set job(String value) {
    _job = value;
  }

  String get sex => _sex;

  set sex(String value) {
    _sex = value;
  }

  int get age => _age;

  set age(int value) {
    _age = value;
  }

  DateTime get birthDay => _birthDay;

  set birthDay(DateTime value) {
    _birthDay = value;
  }

  String get observation => _observation;

  set observation(String value) {
    _observation = value;
  }

  String get lastName => _lastName;

  set lastName(String value) {
    _lastName = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }


}
