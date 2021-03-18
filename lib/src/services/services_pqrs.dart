import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_flutter/src/services/service_url.dart';
import 'package:http/http.dart' as http;

class ServicioPQRS {
  String URL = Url().getUrl();

  Future<bool> addPQRS(String pqrs_asunto, String pqrs_desc) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await http.post(
        URL + 'pqrs',
        headers: {'x-access-token': prefs.getString('token')},
        body: {'pqrs_asunto': pqrs_asunto, 'pqrs_desc': pqrs_desc},
      ).timeout(Duration(seconds: 20));
      return (response.statusCode == 200) ? true : false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
