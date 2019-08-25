import 'dart:convert';

import 'package:phoenix_club/utils/webservice/webservice_config.dart';

class ActivityEntity{

  int _id;
  String _label;
  String _description;
  double _rating;
  double _userRating;
  int _raters;
  int _ratingId;
  String _photo;

  ActivityEntity(Map<String, dynamic> map){
    _id = map['Id'];
    String _lab = map['Libelle'];
    String _desc = map['Description'];
    _label = utf8.decode(_lab.codeUnits);
    _description = utf8.decode(_desc.codeUnits);
    _rating = map['AllRating'] == null ? 0 : map['AllRating'];
    _userRating = 0;
    //_ratingId = map['RatingId'];
    _raters = map['TotalRater'] != null ? map['TotalRater'] : 0;
    _photo = map['Link'] != null ? WebService.PHOTOS +  map['Link'] : '';
  }


  String get photo => _photo;

  set photo(String value) {
    _photo = value;
  }

  int get raters => _raters;

  set raters(int value) {
    _raters = value;
  }

  double get rating => _rating;

  set rating(double value) {
    _rating = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get label => _label;


  String get description => _description;

  set description(String value) {
    _description = value;
  }

  set label(String value) {
    _label = value;
  }

  double get userRating => _userRating;

  set userRating(double value) {
    _userRating = value;
  }

  int get ratingId => _ratingId;

  set ratingId(int value) {
    _ratingId = value;
  }
}