import 'package:phoenix_club/utils/webservice/webservice_config.dart';

class MembershipEntity{

  String _label;
  int _id;
  String _photo;

  MembershipEntity({dynamic data}){
    if(data != null) {
      Map<String, dynamic> map = data;
      _id = map["Id"];
      _label = map["Libelle"];
      _photo = map['Link'] == null ? "" : WebService.PHOTOS +  map['Link'];
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

  String get label => _label;

  set label(String value) {
    _label = value;
  }


}