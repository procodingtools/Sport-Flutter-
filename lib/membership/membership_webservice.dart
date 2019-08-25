import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:phoenix_club/membership/entity/membership_entity.dart';
import 'package:phoenix_club/utils/entities/user_entity.dart';
import 'package:phoenix_club/utils/webservice/webservice_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MembershipWebservice{

  Future<List<MembershipEntity>> get() async{
    final _sharedPrefeerences = await SharedPreferences.getInstance();
    final _user = UserEntity(data: json.decode(_sharedPrefeerences.getString("user")));
    String _url = WebService.MEMBERSHIPS + _user.id.toString();
    List<MembershipEntity> _list = List();

    try {
      final _response = await Dio().get(_url).timeout(Duration(seconds: 15));
      if(_response.statusCode == 200){
        List<dynamic> _data = jsonDecode(_response.data);
        for (dynamic _entity in _data) {
          _list.add(MembershipEntity(data: _entity));
        }
      }
      return _list;
    }catch(e){
      return null;
    }
  }
}