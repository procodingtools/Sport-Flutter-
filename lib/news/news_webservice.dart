import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:phoenix_club/news/news_entity.dart';
import 'package:phoenix_club/utils/webservice/webservice_config.dart';

class NewsWebService{

  Future<List<NewsEntity>> getNews({int id}) async {
    final url = id == null ? WebService.NEWS : WebService.NEWS + id.toString();
    try {
      final response = await http.get(url).timeout(Duration(seconds: 15));
      final List<NewsEntity> toReturn = List();
      if (response.statusCode == 200) {
        List<dynamic> list = json.decode(response.body);
        for (int i = 0; i < list.length; i++)
          toReturn.add(NewsEntity(data: list[i]));
        return toReturn;
      }
      return null;
    } catch(e){
      return null;
    }
  }
}