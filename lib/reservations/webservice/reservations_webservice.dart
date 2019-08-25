import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:phoenix_club/reservations/entity/reservation_entity.dart';
import 'package:phoenix_club/utils/dialogs/dialogs.dart';
import 'package:phoenix_club/utils/entities/user_entity.dart';
import 'package:phoenix_club/utils/res/strings.dart';
import 'package:phoenix_club/utils/webservice/webservice_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationWebService {
  Future<List<ReservationEntity>> get(BuildContext _context) async {
    final _prefs = await SharedPreferences.getInstance();

    final _user = UserEntity(data: json.decode(_prefs.getString("user")));

    List<ReservationEntity> _reservations = List();
    try {
      final _response = await http
          .get(WebService.RESERVED + "/" + _user.id.toString())
          .timeout(Duration(seconds: 15));

      if (_response.body != null || _response.statusCode == 200) {
        List<dynamic> _list = json.decode(_response.body);



        if (_list.length > 0) {
          for (int i = 0; i < _list.length; i++) {
            ReservationEntity _entity = ReservationEntity(data: _list[i]);
            _reservations.add(_entity);
          }
          return _reservations;
        }
        return _reservations;
      }
    } catch (e) {
      return null;
    }
  }


  Future<bool> remove(BuildContext _context, {scId, reservationId}) async {
    final _prefs = await SharedPreferences.getInstance();
    final _user = UserEntity(data: json.decode(_prefs.getString("user")));

    final _formatter = DateFormat("dd/MM/yyyy");

    FormData _data = FormData();

    _data['IdAdherent'] = _user.id;
    _data['DateReservation'] = _formatter.format(DateTime.now());
    _data['IdSeance'] = scId;
    _data['Id'] = reservationId;


    try {
      final _response = await Dio().post(WebService.DELETE_RESERVATION, data: _data).timeout(Duration(seconds: 15));

      if (_response.statusCode == 200)
        return true;

      return false;
    } catch (e) {
      Dialogs(_context).showErrorDialog(Strings.ERROR_CONNEXION);
      return null;
    }
  }
}
