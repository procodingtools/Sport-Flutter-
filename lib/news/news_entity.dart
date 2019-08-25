import 'dart:convert';

import 'package:phoenix_club/utils/webservice/webservice_config.dart';

class NewsEntity{

  String _title;
  String _description;
  int _id;
  String _photo;

  NewsEntity({Map<String, dynamic> data}){
   if (data !=null){
     _title = utf8.decode(data['Titre'].toString().codeUnits);
     _id= data['Id'];
     _description = utf8.decode(data['Description'].toString().codeUnits);
     try{
       _photo = WebService.PHOTOS + data['Photo'];
     }catch (e){
       _photo = WebService.PHOTOS;
     }
   }
  }

  String get photo => _photo;

  set photo(String value) {
    _photo = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }


}