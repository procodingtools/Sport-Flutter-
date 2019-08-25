import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:phoenix_club/utils/entities/coachs/coach_entity.dart';
import 'package:phoenix_club/utils/entities/coachs/coach_reservation_entity.dart';
import 'package:phoenix_club/utils/entities/user_entity.dart';
import 'package:phoenix_club/utils/webservice/webservice_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoachWebService {
  Future<List<CoachEntity>> getCoaches() async {
    final Dio dio = Dio();
    List<CoachEntity> toReturn;

    try {
      final respose =
          await dio.get(WebService.COACHES).timeout(Duration(seconds: 15));

      if (respose.statusCode == 200) {
        toReturn = List();
        final list = json.decode(respose.data);
        for (dynamic e in list) toReturn.add(CoachEntity(data: e));
      }
    } catch (e) {
      print(e.toString());
    } finally {
      return toReturn;
    }
  }

  Future<dynamic> reserveCoach(
      int id, String startDate, String duration, String name) async {
    Dio dio = Dio();

    final prefs = await SharedPreferences.getInstance();

    final user = UserEntity(data: json.decode(prefs.getString("user")));

    FormData formData = FormData();

    formData['IdCoach'] = id;
    formData['IdAdherent'] = user.id;
    formData['DateReservation'] = startDate;
    formData['Duree'] = duration;
    //formData['DateCreation'] = formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy]);

    try {
      final response = await dio
          .post(WebService.RESERVE_COACH, data: formData)
          .timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        String resp = response.data
            .toString()
            .replaceAll('\\"', '"')
            .replaceAll('"[', '[')
            .replaceAll(']"', ']');
        Map<String, dynamic> data = jsonDecode(resp)[0];
        CoachReservationEntity coach = CoachReservationEntity();
        if (data['Id'] != 0) {
          coach.toRemove = false;
          coach.id = jsonDecode(response.data)[0]['Id'];
          coach.duration = double.parse(duration.replaceAll(',', '.'));
          String date = startDate.split(' ')[0];

          coach.startDate = DateTime(
              int.parse(date.split('/')[2]),
              int.parse(date.split('/')[1]),
              int.parse(date.split('/')[0]),
              int.parse(startDate.split(' ')[1].split(':')[0]),
              int.parse(startDate.split(' ')[1].split(':')[1]));
          coach.endTime = coach.startDate.add(Duration(hours: int.parse(coach.duration.toString().split('.')[0]), minutes: int.parse(coach.duration.toString().split('.')[1])*6));
          coach.name = name;
          return coach;
        } else {
          List list = data["Disponiblite"];
          return list;
        }
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<CoachReservationEntity>> getReservedCoaches() async {
    final prefs = await SharedPreferences.getInstance();

    final user = UserEntity(data: json.decode(prefs.getString("user")));

    try {
      final response = await Dio()
          .get(WebService.RESERVED_COACHS + user.id.toString())
          .timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        List<dynamic> list = jsonDecode(response.data);
        List<CoachReservationEntity> coaches = List();
        for (dynamic e in list) coaches.add(CoachReservationEntity(data: e));
        return coaches;
      } else
        return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteReservation(int id) async {
    try {
      final response = await Dio()
          .get(WebService.DELETE_COACH_RESERVATION + id.toString())
          .timeout(Duration(seconds: 15));
      if (response.statusCode == 200) return true;
      return false;
    } catch (e) {
      return null;
    }
  }
}
