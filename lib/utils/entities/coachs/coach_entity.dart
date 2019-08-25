import 'dart:convert';

class CoachEntity{
  int _id;
  String _name;
  String _prenom;

  CoachEntity({Map<String, dynamic> data}){
    if(data != null){
      _id = data['Id'];
      _name = utf8.decode(data['Nom'].toString().codeUnits).trim();
      _prenom = utf8.decode(data['Prenom'].toString().codeUnits).trim();
      
    }
  }

  String get lastName => _prenom;

  set lastName(String value) {
    _prenom = value;
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