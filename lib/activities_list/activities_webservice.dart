import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:phoenix_club/activities_list/entity/acivity_entity.dart';
import 'package:phoenix_club/utils/entities/user_entity.dart';
import 'package:phoenix_club/utils/webservice/webservice_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivitiesWebService{

  Future<List<ActivityEntity>> fetch() async {
    List<ActivityEntity> _tmpList;

    UserEntity _user = null;
    final _prefs = await SharedPreferences.getInstance();

    if (_prefs.getString('user') != null) {
        _user = UserEntity(data: jsonDecode(_prefs.getString('user')));
      }

    try {
      String _id = _user != null ? "${_user.id}" : "-1";
      final _resp = await http.get(WebService.ACTIVITY).timeout(Duration(seconds: 15));
        List<dynamic> courses = json.decode(_resp.body);
        if (_resp.statusCode == 200) {
          _tmpList = List();
          for (int i = 0; i < courses.length; i++) {
            Map<String, dynamic> map = courses[i];
            ActivityEntity _entity = ActivityEntity(map);
            if (_id != null){

              Map<String, dynamic> _map = await getRatings(userId: _id, activityId: _entity.id);
              _entity.userRating = _map != null ? _map['Count']+.0 : 0;
              _entity.ratingId = _map != null ? _map['IdRating'] : null;
            }
            _tmpList.add(_entity);
          }
          return _tmpList;
        }

    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>> getRatings({String userId, int activityId}) async{
    final dio = Dio();
    final _resp = await dio.get(WebService.ACTIVITY + userId+ "/" + activityId.toString());
    List<dynamic> list = json.decode(_resp.data);
    Map<String, dynamic> _map = list.isEmpty ? {"Count": 0.0, "IdRating": null} : list[0] ;
    return _map;
  }

  Future<int> rate(int idActivity, int rating) async{
    FormData  _data = FormData();
    final sp = await SharedPreferences.getInstance();
    UserEntity _user;
    if (sp.get("user") != null)
      _user = UserEntity(data: jsonDecode(sp.getString("user")));

    _data['IdActivite'] = idActivity;
    _data['IdPersonne'] = _user != null ? _user.id : 0;
    _data['Number'] = rating;


    try{
      Dio dio = Dio();
      final _response = await dio.post(WebService.ADD_RATING, data: _data).timeout(Duration(seconds: 15));
      if (_response.statusCode == 200) {
        Map<String, dynamic> _map =  jsonDecode(_response.data)[0];
        return int.parse(_map["Id"].toString());
      }
      return -1;
    }catch (e){
      print(e.toString());
      return null;
    }
  }

  Future<bool> updateRating(int id, int rating) async{
    FormData data = FormData();

    data['Id'] = id;
    data['Number'] = rating;


    Dio dio = Dio();
    try{
      final response = await dio.post(WebService.UPDATE_RATING, data: data).timeout(Duration(seconds: 15));
      if (response.statusCode == 200)
        return true;
      return false;
    }catch (e){
      return null;
    }
  }
}