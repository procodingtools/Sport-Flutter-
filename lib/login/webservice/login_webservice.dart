import 'dart:async';

import 'package:dio/dio.dart';
import 'package:phoenix_club/utils/webservice/webservice_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWebService {

  Future<bool> login(String user, String passwd) async {
    try {
      String _url = WebService.LOGIN;
      FormData _data = FormData();
      _data['Login'] = user;
      _data['Pass'] = passwd;

      final response = await Dio().post(_url, data: _data,).timeout(Duration(seconds: 15));


      if (response.statusCode == 200) {
        if (response.data.toString() == "null" || response.data == null)
          return false;
        else {
          _setUser(response.data);
          return true;
        }
      }
    } catch (e) {
      return null;
    }
  }

  _setUser(String json) {
    SharedPreferences.getInstance().then((pref) {
      pref.setString("user", json);
    });
  }

  Future<bool> createAccount(
      String nameLastName, String phone, String birthDate, String sex) async {
    var _data = FormData();
    Dio dio = Dio();
    final _url = WebService.SIGNUP;

    _data['Nom'] = nameLastName.substring(0, nameLastName.lastIndexOf(" "));
    _data['Prenom'] = nameLastName.substring(nameLastName.lastIndexOf(' ') + 1);
    _data['Tel'] = phone;
    _data['DateNaissance'] = birthDate;
    _data['Genre'] = sex;

    try {
      final _response =
          await dio.post(_url, data: _data).timeout(Duration(seconds: 15));

      if (_response.statusCode == 200)
        return true;
      else
        return false;
    } catch (e) {
      return null;
    }
  }
}
