import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:phoenix_club/pricing/entities/membership_entity.dart';
import 'package:phoenix_club/pricing/entities/membership_type_entity.dart';
import 'package:phoenix_club/utils/webservice/webservice_config.dart';

class PricingWebService {
  Future<List<MembershipEntity>> getList() async {
    List<MembershipEntity> _memberships = List();

    try {
      final response = await http.get(WebService.PRICING).timeout(
          Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> list = json.decode(response.body);
        for (int i = 0; i < list.length; i++) {
          _memberships.add(MembershipEntity(data: list[i]));
        }
        return _memberships;
      }
      return null;
    }catch (e){
      return null;
    }
  }

  Future<List<MembershipTypeEntity>> getType(int id) async {
    final _url = WebService.MEMBERSHIP_TYPE + id.toString();
    final response = await http.get(_url).timeout(Duration(seconds: 10));

    List<MembershipTypeEntity> toReturn = List();

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);

      for (int i = 0; i < list.length; i++)
        toReturn.add(MembershipTypeEntity(data: list[i]));

      return toReturn;
    }

    return null;
    }
}
