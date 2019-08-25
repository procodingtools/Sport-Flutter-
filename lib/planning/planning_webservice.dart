import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:phoenix_club/planning/entity/planning_entity.dart';
import 'package:phoenix_club/utils/entities/user_entity.dart';
import 'package:phoenix_club/utils/webservice/webservice_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlanningWebService {

  Future<List<PlanningEntity>> fetch() async {
    final _prefs = await SharedPreferences.getInstance();
    List<PlanningEntity> list = List();
    String _url = WebService.RESUME;

    if (_prefs.getString("user") != null) {
      UserEntity user = UserEntity(data: json.decode(_prefs.getString("user")));
      _url += user.id.toString();
    } else
      _url += "0";
    try {
      final _response = await http.get(_url).timeout(Duration(seconds: 15));
      if (_response.statusCode == 200) {
        List<dynamic> data = json.decode(_response.body);
        for (int i = 0; i < data.length; i++) {
          list.add(PlanningEntity(data: data[i]));
        }
        return list;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> reserve(int idSc, {bool action}) async {
    bool _action;
    String _url;
    SharedPreferences _sharedPrefeerences =
        await SharedPreferences.getInstance();
    final _user =
    UserEntity(data: json.decode(_sharedPrefeerences.getString("user")));

    if (action == null)
      _action = false;
    else
      _action = action;

    _url = _action ? WebService.RESERVE : WebService.DELETE_RESERVATION;

      final _formatter = DateFormat("dd/MM/yyyy");

      FormData _data = FormData();

      _data['IdAdherent'] = _user.id;
      _data['DateReservation'] = _formatter.format(DateTime.now());
      _data['IdSeance'] = idSc;


    try {
      final _response = await Dio().post(_url, data: _data).timeout(Duration(seconds: 15));


      if (_response.statusCode == 200) {
        print(_response.data);
        return _action ? jsonDecode(_response.data)[0] : true;//jsonDecode(_response.data);
      }
      return null;
    } catch (e) {
      if (e is SocketException){
        print(e.toString());
        return null;
      }
    }
  }

}
