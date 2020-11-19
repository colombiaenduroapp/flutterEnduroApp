import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:async';

class ServicioCiudad {
  Future<List> getCiudad() async {
    http.Response response =
        await http.get("https://colombiaenduro.herokuapp.com/sede");
    if (response.statusCode == 200) {
      List res = jsonDecode(response.body)['data'];

      return res;
    } else {
      return null;
    }
  }

  Future<bool> createProfile(String cd_desc) async {
    final response = await http.post(
        "https://colombiaenduro.herokuapp.com/ciudad",
        body: {"cd_desc": cd_desc});
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
